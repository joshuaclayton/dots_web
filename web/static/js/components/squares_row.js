import React from "react";
import Square from "./square";

export default React.createClass({
  render() {
    const { squares } = this.props.data;
    const { game, gameId, ownerName } = this.props;

    return(
      <div className="square-row">
        {squares.map(square => {
          return <Square key={square.key} data={square} game={game} gameId={gameId} ownerName={ownerName} />
        })}
      </div>
    );
  }
});
