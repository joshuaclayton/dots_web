import * as _ from "underscore";
import React from "react";
import SquaresRow from "./squares_row";

export default React.createClass({
  render() {
    const { data, game, gameId, ownerName } = this.props;
    const squaresGroups = _.groupBy(data.squares, square => square.coordinates.y);
    return(
      <div>
        {_.values(squaresGroups).reverse().map((squaresGroup, index) => {
          const lastRow = index == _.values(squaresGroups).length;
          return (
            <SquaresRow data={{ squares: squaresGroup }} game={game} gameId={gameId} ownerName={ownerName}/>
          );
        })}
      </div>
    )
  }
});