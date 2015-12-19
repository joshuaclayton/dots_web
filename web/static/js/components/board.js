import React from "react";
import SquaresList from "./squares_list";

export default React.createClass({
  render() {
    const { data, game, gameId, ownerName } = this.props;
    return(
      <section className="board">
        <SquaresList data={data} game={game} gameId={gameId} ownerName={ownerName} />
      </section>
    )
  }
});
