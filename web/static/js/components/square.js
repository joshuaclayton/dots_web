import React from "react";
import SquareSide from "./square_side";
import ColorCalculator from "../color_calculator";

const SIDES = ["Top", "Right", "Bottom", "Left"];

export default React.createClass({
  render() {
    const { game } = this.props;
    const { completed_by } = this.props.data;
    const { x, y } = this.props.data.coordinates;

    const style = {};

    if (completed_by) {
      style.backgroundColor = ColorCalculator.calculate(completed_by);
    }

    return(
      <ul className="square" style={style}>
        {SIDES.map(side => {
          const data = {
            side: side,
            claim: this._claimForSide(side),
            x: x,
            y: y
          };

          return <SquareSide data={data} game={game} gameId={this.props.gameId} ownerName={this.props.ownerName} />
        })}
      </ul>
    )
  },

  _claimForSide(side) {
    return this.props.data.claims.find(claim => {
      return claim.position == side;
    });
  }
});
