import React from "react";

export default class PendingGameStart extends React.Component {
  render() {
    return(
      <form onSubmit={this._onSubmit.bind(this)}>
        <ul>
          <li>
            <input type="submit" value="Start the game"/>
          </li>
        </ul>
      </form>
    );
  }

  _onSubmit(e) {
    e.preventDefault();
    channel.push("game:start", { game_id: this.props.gameId });
  }
};
