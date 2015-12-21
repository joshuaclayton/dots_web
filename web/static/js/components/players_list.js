import React from "react";
import Player from "./player";

export default (props) => {
  return(
    <section className="players-list">
      <h2>Players</h2>
      <ul>
        {props.data.map(player => {
          return <Player key={player} data={player} />
        })}
      </ul>
    </section>
  )
};
