import * as _ from "underscore";
import React from "react";

export default class Registration extends React.Component {
  render() {
    return(
      <section className="registration modal">
        <h2 className="title">Let's get started!</h2>
        <form onSubmit={this._onSubmit.bind(this)}>
          <ul>
            <li>
              <label htmlFor="player_name">First, what's your name?</label>
              <input id="player_name" type="text" onChange={this._chooseName.bind(this)}/>
            </li>
            <li className={this._sizeSelectionClassName}>
              <label htmlFor="board_size">Next, what board size do you prefer?</label>
              <section className="size-selector">
                {this._boardSizes.map(boardSize => {
                  return <a onClick={this._chooseSize.bind(this)} key={boardSize} data-size={boardSize}>{boardSize}</a>
                })}
              </section>
            </li>
            <li>
              <input type="submit" value="Game on!" disabled={!this._formComplete}/>
            </li>
          </ul>
        </form>
      </section>
    )
  }

  _chooseSize(e) {
    e.preventDefault();
    const chosenSize = e.target.getAttribute("data-size");
    this.setState({ chosenSize: chosenSize });
  }

  _chooseName(e) {
    this.setState({ playerName: e.target.value });
  }

  get _formComplete() {
    return (this._boardSizeSelected || this._boardSizeChosen) && this.state && this.state.playerName;
  }

  get _boardSizeSelected() {
    return this.state && this.state.chosenSize;
  }

  _onSubmit(e) {
    e.preventDefault();

    const playerName = this.state.playerName;

    channel.push("game:begin",
      Object.assign({
        game_id: this.props.gameId,
        player: playerName
      }, this._chosenSize)
    );

    this.props.onNameAssignment(playerName);
  }

  get _boardSizeChosen() {
    return !!this.props.data.width;
  }

  get _sizeSelectionClassName() {
    if (this._boardSizeChosen) {
      return "hidden";
    } else {
      return "";
    }
  }

  get _chosenSize() {
    const sizeOptions = { width: 0, height: 0 };

    if (!this._boardSizeChosen) {
      const size = this.state.chosenSize.split("x");
      sizeOptions.width = size[0];
      sizeOptions.height = size[1];
    }

    return sizeOptions;
  }

  get _boardSizes() {
    const boardSizes = {};

    boardSizes[2] = "2x2";
    boardSizes[5] = "5x5";
    boardSizes[10] = "10x10";

    return _.values(boardSizes);
  }
};
