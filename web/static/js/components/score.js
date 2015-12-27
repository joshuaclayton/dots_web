import React from "react";
import * as _ from "underscore";

export default class Score extends React.Component {
  render() {
    const { scores } = this.props.data.game.score;
    const controls = _.map(scores, function(value, key) {
      return [
        (<dt>{key}</dt>),
        (<dd>{value}</dd>)
      ];
    });

    return(
      <section className="modal">
        <h2>Winner: {this._winners}</h2>
        <dl>
          {controls}
        </dl>
      </section>
    );
  }

  get _winners() {
    return this.props.data.game.score.winners;
  }
};
