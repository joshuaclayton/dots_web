import * as _ from "underscore";
import React from "react";
import { render } from "react-dom";
import TurnDesignator from "./turn_designator";
import PendingGameStart from "./pending_game_start";
import Player from "./player";
import Board from "./board";
import Score from "./score";

// +--+---------------------------+--+---------------------------+--+---------------------------+--+
// |  |                           |  |                           |  |                           |  |
// +--+---------------------------+--+---------------------------+--+---------------------------+--+
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// +--+---------------------------+--+---------------------------+--+---------------------------+--+
// |  |                           |  |                           |  |                           |  |
// +--+---------------------------+--+---------------------------+--+---------------------------+--+
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// |  |                           |  |                           |  |                           |  |
// +--+---------------------------+--+---------------------------+--+---------------------------+--+
// |  |                           |  |                           |  |                           |  |
// +--+---------------------------+--+---------------------------+--+---------------------------+--+

class Game {
  constructor(gameId, channel) {
    this.gameId = gameId;
    this.channel = channel;
    this.player = null;
  }

  register() {
    const channel = this.channel;
    const gameId = this.gameId;
    const self = this;

    window.onbeforeunload = function() {
      if(self.playerName) {
        channel.push("player:leave", {game_id: gameId, player: self.playerName});
      }
    };

    let DotsGame = React.createClass({
      componentDidMount() {
        channel.on(`game:update:${gameId}`, payload => {
          this.setState(payload);
        });
      },

      render() {
        if(this._lobbyAvailable()) {
          if (this._gameCompleted()) {
            return this._renderScore();
          } else if(this._gameStarted()) {
            return this._renderFullBoard();
          } else if (self.playerName) {
            return this._renderPending();
          } else {
            return this._renderRegistration();
          }
        } else {
          return this._renderLoadingScreen();
        }
      },

      _lobbyAvailable() {
        return this.state && this.state.lobby;
      },

      _gameCompleted() {
        return this.state.lobby.game.completed;
      },

      _gameStarted() {
        return this.state.lobby.status != "not_started";
      },

      _renderRegistration() {
        return(
          <Registration data={this.state.lobby}/>
        )
      },

      _renderScore() {
        return(
          <section className="score">
            <Score data={this.state.lobby}/>
          </section>
        );
      },

      _renderFullBoard() {
        const { lobby } = this.state;
        return(
          <section className="full-board">
            <PlayersList data={lobby.game.players} />
            <TurnDesignator data={lobby} player={self.playerName} />
            <Board data={lobby.game.board} game={lobby.game} gameId={gameId} ownerName={self.playerName} />
          </section>
        )
      },

      _renderPending() {
        const { lobby } = this.state;
        return(
          <section className="modal">
            <PlayersList data={lobby.game.players} />
            <PendingGameStart data={lobby} gameId={gameId} />
          </section>
        )
      },

      _renderLoadingScreen() {
        return(
          <section className="modal loading">
            <h2>Loading game...</h2>
          </section>
        )
      }
    });

    let Registration = React.createClass({
      _boardSizes() {
        const boardSizes = {};
        boardSizes[2] = "2x2";
        boardSizes[5] = "5x5";
        boardSizes[10] = "10x10";
        return boardSizes;
      },

      render() {
        let boardSelector = "";
        if (this._boardSizeChosen()) {
          boardSelector = "hidden";
        }

        return(
          <section className="registration modal">
            <h2 className="title">Let's get started!</h2>
            <form onSubmit={this._onSubmit}>
              <ul>
                <li>
                  <label htmlFor="player_name">First, what's your name?</label>
                  <input id="player_name" type="text" onChange={this._chooseName}/>
                </li>
                <li className={boardSelector}>
                  <label htmlFor="board_size">Next, what board size do you prefer?</label>
                  <section className="size-selector">
                    {_.values(this._boardSizes()).map(boardSize => {
                      return <a onClick={this._chooseSize} data-size={boardSize}>{boardSize}</a>
                    })}
                  </section>
                </li>
                <li>
                  <input type="submit" value="Game on!" disabled={!this._formComplete()}/>
                </li>
              </ul>
            </form>
          </section>
        )
      },

      _chooseSize(e) {
        const chosenSize = e.target.getAttribute("data-size")
        this.setState({chosenSize: chosenSize});
        e.preventDefault();
      },

      _chooseName(e) {
        this.setState({playerName: e.target.value});
      },

      _formComplete() {
        return (this._boardSizeSelected() || this._boardSizeChosen()) && this.state && this.state.playerName;
      },

      _boardSizeSelected() {
        return this.state && this.state.chosenSize;
      },

      _onSubmit(e) {
        e.preventDefault();

        const playerName = this.state.playerName;

        let sizeOptions = {width: 0, height: 0};
        if (!this._boardSizeChosen()) {
          const size = this.state.chosenSize.split("x");
          sizeOptions.width = size[0];
          sizeOptions.height = size[1];
        }

        channel.push("game:begin",
          Object.assign({
            game_id: gameId,
            player: playerName
          }, sizeOptions)
        );

        self.playerName = playerName;
      },

      _boardSizeChosen() {
        return !!this.props.data.width;
      }
    });

    var color = function(string) {
      return `#${md5(string).slice(0, 6)}`;
    };

    let PlayersList = React.createClass({
      render() {
        return(
          <section className="players-list">
            <h2>Players</h2>
            <ul>
              {this.props.data.map(player => {
                return <Player key={player} data={player} />
              })}
            </ul>
          </section>
        )
      }
    });

    render(<DotsGame />, document.getElementById("game"))
  }
}

export default Game;
