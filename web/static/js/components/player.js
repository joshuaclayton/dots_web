import React from "react";

export default (props) => {
  const { data } = props;
  let activeState = "";
  if (data.active) {
    activeState = "";
  } else {
    activeState = "(inactive)"
  }

  return(
    <li>{data.name} {activeState}</li>
  );
};
