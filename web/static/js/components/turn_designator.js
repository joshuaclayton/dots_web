import React from "react";
import Notifier from "../notifier";

export default class TurnDesignator extends React.Component {
  render() {
    this._notifyCurrentPlayer();

    return(
      <p>It's {this.props.data.game.current_player_name}'s turn</p>
    );
  }

  _currentPlayersTurn() {
    return this._currentPlayer() == this._thisPlayer();
  }

  _currentPlayer() {
    return this.props.data.game.current_player_name;
  }

  _thisPlayer() {
    return this.props.player;
  }

  _notifyCurrentPlayer() {
    if (this._currentPlayersTurn() && document.hidden) {
      Notifier.notify("Dots and Boxes", "It's your turn!");
    }
  }
};
