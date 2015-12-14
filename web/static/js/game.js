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
          if(this._gameStarted()) {
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

      _gameStarted() {
        return this.state.lobby.status != "not_started";
      },

      _renderRegistration() {
        return(
          <section className="registration">
            <Registration data={this.state.lobby}/>
          </section>
        )
      },

      _renderFullBoard() {
        return(
          <section>
            <PlayersList data={this.state.lobby.game.players} />
            <TurnDesignator data={this.state.lobby} />
            <Board data={this.state.lobby.game.board} />
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

        channel.push("game:start", {
          game_id: gameId
        });
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
        let boardSelector;

        if (this.props.data.width) {
          boardSelector = "hidden";
        } else {
          boardSelector = "";
        }

        return(
          <form onSubmit={this._onSubmit}>
            <ul>
              <li>
                <label htmlFor="player_name">Choose your name</label>
                <input id="player_name" type="text" />
              </li>
              <li className={boardSelector}>
                <label htmlFor="board_size">Board size</label>
                <select id="board_size">
                  <option>2x2</option>
                  <option>5x5</option>
                  <option>10x10</option>
                </select>
              </li>
              <li>
                <input type="submit" value="Start playing"/>
              </li>
            </ul>
          </form>
        )
      },
      _onSubmit(e) {
        const playerName = document.getElementById("player_name").value;
        const size = document.getElementById("board_size").options[document.getElementById("board_size").selectedIndex].text.split("x");

        channel.push("game:begin", {
          game_id: gameId,
          player: playerName,
          width: size[0],
          height: size[1]
        });

        self.player = playerName;

        e.preventDefault();
      }
    });

    let Board = React.createClass({
      render() {
        return(
          <section>
            <h2>Board ({this.props.data.width}x{this.props.data.height})</h2>
            <SquaresList data={this.props.data} />
          </section>
        )
      }
    });

    let SquaresList = React.createClass({
      render() {
        return(
          <div>
            {this.props.data.squares.map(square => {
              return <Square key={square.key} data={square} />
            })}
          </div>
        )
      }
    });

    let SquareSide = React.createClass({
      render() {
        const side = this.props.data.side;
        const claim = this.props.data.claim;
        let claimInformation;
        if (claim) {
          claimInformation = ` (taken by ${claim.player})`
        }
        return <li onClick={this._onClick}>{side}{claimInformation}</li>
      },

      _onClick() {
        channel.push("game:claim", {
          game_id: gameId,
          x: this.props.data.x,
          y: this.props.data.y,
          position: this.props.data.side
        });
      }
    });

    let Square = React.createClass({
      render() {
        const claimForSide = side => {
          return this.props.data.claims.find(claim => {
            return claim.position == side;
          });
        };

        return(
          <div>
            [{this.props.data.coordinates.x}, {this.props.data.coordinates.y}]
            <ul>
              {this._sides().map(side => {
                const data = {
                  side: side,
                  claim: claimForSide(side),
                  x: this.props.data.coordinates.x,
                  y: this.props.data.coordinates.y
                };

                return <SquareSide data={data} />
              })}
            </ul>
          </div>
        )
      },
      _sides() {
        return ["Top", "Right", "Bottom", "Left"];
      }
    });

    let PlayersList = React.createClass({
      render() {
        return(
          <ul>
            {this.props.data.map(player => {
              return <Player key={player} data={player} />
            })}
          </ul>
        )
      }
    });

    ReactDOM.render(<DotsGame />, document.getElementById("game"))
  }
}

export default Game;
