import * as _ from "underscore";
import React from "react";
import SquaresRow from "./squares_row";

export default class SquaresList extends React.Component {
  render() {
    const { data, game, gameId, ownerName } = this.props;
    const squaresGroups = _.groupBy(data.squares, square => square.coordinates.y);
    return(
      <div>
        {_.values(squaresGroups).reverse().map(squaresGroup => {
          return (
            <SquaresRow data={{ squares: squaresGroup }} game={game} gameId={gameId} ownerName={ownerName}/>
          );
        })}
      </div>
    )
  }
};
