import React from "react";

export default React.createClass({
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
    const { x, y, side } = this.props.data;
    if(this.props.ownerName == this.props.game.current_player_name) {
      channel.push("game:claim", {
        game_id: this.props.gameId,
        x: x,
        y: y,
        position: side
      });
    }
  }
});
