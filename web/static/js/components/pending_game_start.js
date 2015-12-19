import React from "react";

export default React.createClass({
  render() {
    return(
      <form onSubmit={this._onSubmit}>
        <ul>
          <li>
            <input type="submit" value="Start the game"/>
          </li>
        </ul>
      </form>
    );
  },

  _onSubmit(e) {
    console.log(this);
    e.preventDefault();
    console.log(this.props);
    channel.push("game:start", { game_id: this.props.gameId });
  }
});
