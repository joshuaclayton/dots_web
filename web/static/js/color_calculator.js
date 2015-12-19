import md5 from "md5";

export default class ColorCalculator {
  static calculate(value) {
    return `#${md5(value).slice(0, 6)}`;
  }
}
