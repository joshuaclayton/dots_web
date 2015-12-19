import React from "react";
import Notifier from "../notifier";

export default React.createClass({
  render() {
    if (this._currentPlayersTurn() && document.hidden) {
      Notifier.notify("Dots and Lines", "It's your turn!");
    }

    return(
      <p>It's {this.props.data.game.current_player_name}'s turn</p>
    );
  },

  _currentPlayersTurn() {
    return this._currentPlayer() == this._thisPlayer();
  },
  _currentPlayer() {
    return this.props.data.game.current_player_name;
  },

  _thisPlayer() {
    return this.props.player;
  }
});
