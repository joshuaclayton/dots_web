import React from "react";

export default class SquareSide extends React.Component {
  render() {
    const cssClass = [this._sideClass, this._claimedClass].join(" ");

    return <li className={cssClass} onClick={this._onClick.bind(this)}></li>
  }

  _onClick() {
    const { gameId } = this.props;
    const { x, y, side } = this.props.data;

    if(this._ownerIsCurrentPlayer) {
      channel.push("game:claim", {
        game_id: gameId,
        x: x,
        y: y,
        position: side
      });
    }
  }

  get _ownerIsCurrentPlayer() {
    const { game, owner } = this.props;
    return owner == game.current_player_name;
  }

  get _claimedClass() {
    if (this._claimExists) {
      return "claimed";
    } else {
      return "";
    }
  }

  get _sideClass() {
    const { side } = this.props.data;
    return `side-${side.toLowerCase()}`;
  }

  get _claimExists() {
    const { claim } = this.props.data;
    return !!claim;
  }
};
