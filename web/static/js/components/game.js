import * as _ from "underscore";
import React from "react";
import { render } from "react-dom";
import TurnDesignator from "./turn_designator";
import PendingGameStart from "./pending_game_start";
import PlayersList from "./players_list";
import Registration from "./registration";
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
      if(self.player) {
        channel.push("player:leave", {game_id: gameId, player: self.player});
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
          } else if (self.player) {
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
          <Registration data={this.state.lobby} gameId={gameId} onNameAssignment={this._onNameAssignment}/>
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
            <TurnDesignator data={lobby} player={self.player} />
            <Board data={lobby.game.board} game={lobby.game} gameId={gameId} owner={self.player} />
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
      },

      _onNameAssignment(playerName) {
        self.player = playerName;
      }
    });

    render(<DotsGame />, document.getElementById("game"))
  }
}

export default Game;
