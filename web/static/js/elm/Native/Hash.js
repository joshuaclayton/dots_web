var md5 = require('md5')

function ElmNativeModule(name, values) {
  Elm.Native[name] = {};
  Elm.Native[name].make = function (elm) {
    elm.Native = elm.Native || {};
    elm.Native[name] = elm.Native[name] || {};
    if (elm.Native[name].values) return elm.Native[name].values;
    return elm.Native[name].values = values;
  };
}

ElmNativeModule('Hash', {md5: md5})
