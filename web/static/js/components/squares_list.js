import * as _ from "underscore";
import React from "react";
import SquaresRow from "./squares_row";

export default class SquaresList extends React.Component {
  render() {
    const { game, gameId, owner } = this.props;
    return(
      <div>
        {this._squaresGroups.map(squaresGroup => {
          return (
            <SquaresRow data={{ squares: squaresGroup }} game={game} gameId={gameId} owner={owner}/>
          );
        })}
      </div>
    )
  }

  get _squaresGroups() {
    const { squares } = this.props.data;
    return _.values(_.groupBy(squares, square => square.coordinates.y)).reverse();
  }
};
