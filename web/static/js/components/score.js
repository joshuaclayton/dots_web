import React from "react";
import * as _ from "underscore";

export default React.createClass({
  render() {
    const { scores, winners } = this.props.data.game.score;
    const controls = _.map(scores, function(value, key) {
      return [
        (<dt>{key}</dt>),
        (<dd>{value}</dd>)
      ];
    });

    return(
      <section className="modal">
        <h2>Winner: {winners}</h2>
        <dl>
          {controls}
        </dl>
      </section>
    );
  }
});
