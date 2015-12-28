import React from "react";
import Notifier from "../notifier";

export default class TurnDesignator extends React.Component {
  render() {
    this._notifyCurrentPlayer();

    return(
      <p>It's {this._currentPlayer.name}'s turn</p>
    );
  }

  get _currentPlayersTurn() {
    return this._currentPlayer.name == this._thisPlayer.name;
  }

  get _currentPlayer() {
    return this.props.data.game.current_player;
  }

  get _thisPlayer() {
    return this.props.player || {};
  }

  _notifyCurrentPlayer() {
    if (this._currentPlayersTurn && document.hidden) {
      Notifier.notify("Dots and Boxes", "It's your turn!");
    }
  }
};
