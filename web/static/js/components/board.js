import React from "react";
import SquaresList from "./squares_list";

export default class Board extends React.Component {
  render() {
    const { data, game, gameId, owner } = this.props;
    return(
      <section className="board">
        <SquaresList data={data} game={game} gameId={gameId} owner={owner} />
      </section>
    )
  }
};
