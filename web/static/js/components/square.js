import React from "react";
import SquareSide from "./square_side";
import ColorCalculator from "../color_calculator";

const SIDES = ["Top", "Right", "Bottom", "Left"];

export default class Square extends React.Component {
  render() {
    const { game, gameId, owner, data } = this.props;
    const { x, y } = data.coordinates;

    return(
      <ul className="square" style={this._squareStyle}>
        {SIDES.map(side => {
          const squareSideData = {
            side: side,
            claim: this._claimForSide(side),
            x: x,
            y: y
          };

          return <SquareSide data={squareSideData} game={game} gameId={gameId} owner={owner} />
        })}
      </ul>
    );
  }

  _claimForSide(side) {
    const { claims } = this.props.data;
    return claims.find(claim => {
      return claim.position == side;
    });
  }

  get _squareStyle() {
    const { completed_by } = this.props.data;

    if (completed_by) {
      return { backgroundColor: ColorCalculator.calculate(completed_by.id) };
    } else {
      return {};
    }
  }
};
