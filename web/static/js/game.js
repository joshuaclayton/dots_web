const _ = require("underscore");
window.md5 = require("md5");

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
        return(
          <section>
            <PlayersList data={this.state.lobby.game.players} />
            <TurnDesignator data={this.state.lobby} />
            <Board data={this.state.lobby.game.board} game={this.state.lobby.game} />
          </section>
        )
      },

      _renderPending() {
        return(
          <section>
            <PlayersList data={this.state.lobby.game.players} />
            <PendingGameStart data={this.state.lobby} />
          </section>
        )
      },

      _renderLoadingScreen() {
        return(
          <section>
            <h2>Loading game...</h2>
          </section>
        )
      }
    });

    let Player = React.createClass({
      render() {
        return(
          <li>{this.props.data}</li>
        )
      }
    });

    let PendingGameStart = React.createClass({
      render() {
        return(
          <form onSubmit={this._onSubmit}>
            <ul>
              <li>
                <input type="submit" value="Start the game"/>
              </li>
            </ul>
          </form>
        )
      },

      _onSubmit(e) {
        e.preventDefault();
        channel.push("game:start", { game_id: gameId });
      }
    });

    let TurnDesignator = React.createClass({
      render() {
        return(
          <p>It's {this.props.data.game.current_player_name}'s turn</p>
        )
      }
    });

    let Registration = React.createClass({
      render() {
        let boardSelector = "";
        if (this._boardSizeChosen()) {
          boardSelector = "hidden";
        }

        const boardSizes = ["2x2", "5x5", "10x10"];

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
                    {boardSizes.map(boardSize => {
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

        self.player = playerName;
      },

      _boardSizeChosen() {
        return !!this.props.data.width;
      }
    });

    let Board = React.createClass({
      render() {
        return(
          <section className="board">
            <SquaresList data={this.props.data} game={this.props.game} />
          </section>
        )
      }
    });

    let SquaresList = React.createClass({
      render() {
        const squaresGroups = _.groupBy(this.props.data.squares, square => square.coordinates.y);
        const { game } = this.props;
        return(
          <div>
            {_.values(squaresGroups).reverse().map(squaresGroup => {
              return(
                <div className="square-row">
                  {squaresGroup.map(square => {
                    return <Square key={square.key} data={square} game={game} />
                  })}
                </div>
              );
            })}
          </div>
        )
      }
    });

    var color = function(string) {
      return `#${md5(string).slice(0, 6)}`;
    };

    let SquareSide = React.createClass({
      render() {
        const { side, claim } = this.props.data;
        let claimInformation, claimed = "";

        if (claim) {
          claimInformation = ` (taken by ${claim.player})`;
          claimed = "claimed";
        }
        const cssClass = `side-${side.toLowerCase()} ${claimed}`;

        return <li className={cssClass} onClick={this._onClick}></li>
      },

      _onClick() {
        if(self.player == this.props.game.current_player_name) {
          channel.push("game:claim", {
            game_id: gameId,
            x: this.props.data.x,
            y: this.props.data.y,
            position: this.props.data.side
          });
        }
      }
    });

    let Square = React.createClass({
      render() {
        const claimForSide = side => {
          return this.props.data.claims.find(claim => {
            return claim.position == side;
          });
        };
        const { game } = this.props;

        let style = {};

        if (this.props.data.completed_by) {
          style = {backgroundColor: color(this.props.data.completed_by)};
        }
        return(
          <ul className="square" style={style}>
            {this._sides().map(side => {
              const data = {
                side: side,
                claim: claimForSide(side),
                x: this.props.data.coordinates.x,
                y: this.props.data.coordinates.y
              };

              return <SquareSide data={data} game={game} />
            })}
          </ul>
        )
      },

      _sides() {
        return ["Top", "Right", "Bottom", "Left"];
      }
    });

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

    let Score = React.createClass({
      render() {

        const controls = _.map(this.props.data.game.score.scores, function(value, key) {
          return [
            (<dt>{key}</dt>),
            (<dd>{value}</dd>)
          ];
        });

        return(
          <section>
            <h2>Winner: {this.props.data.game.score.winners}</h2>
            <dl>
              {controls}
            </dl>
          </section>
        );
      }
    });

    ReactDOM.render(<DotsGame />, document.getElementById("game"))
  }
}

export default Game;
