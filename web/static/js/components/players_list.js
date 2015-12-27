import React from "react";
import Player from "./player";

export default (props) => {
  const players = props.data;

  return(
    <section className="players-list">
      <h2>Players</h2>
      <ul>
        {players.map(player => {
          return <Player key={player} data={player} />
        })}
      </ul>
    </section>
  )
};
