import React from "react";

export default class SquareSide extends React.Component {
  render() {
    const { side, claim } = this.props.data;
    let claimInformation, claimed = "";

    if (claim) {
      claimInformation = ` (taken by ${claim.player})`;
      claimed = "claimed";
    }
    const cssClass = `side-${side.toLowerCase()} ${claimed}`;

    return <li className={cssClass} onClick={this._onClick.bind(this)}></li>
  }

  _onClick() {
    const { x, y, side } = this.props.data;
    if(this.props.owner == this.props.game.current_player_name) {
      channel.push("game:claim", {
        game_id: this.props.gameId,
        x: x,
        y: y,
        position: side
      });
    }
  }
};
