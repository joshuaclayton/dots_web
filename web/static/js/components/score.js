import React from "react";

export default class Score extends React.Component {
  render() {
    return(
      <section className="modal">
        <h2>Winner: {this._winners}</h2>
        <dl>
          {this._scoresItems}
        </dl>
      </section>
    );
  }

  get _scoresItems() {
    const { scores } = this.props.data.game.score;

    return scores.map(scoreItem => {
      const { player, score } = scoreItem;
      return [
        (<dt>{player.name}</dt>),
        (<dd>{score}</dd>)
      ];
    });
  }

  get _winners() {
    const { winners } = this.props.data.game.score;
    return winners.map(winner => winner.name);
  }
};
