export default class Guid {
  static generate() {
    // Copied from http://stackoverflow.com/a/2117523
    return "xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx".replace(/[xy]/g, function(c) {
      var r = crypto.getRandomValues(new Uint8Array(1))[0]%16|0, v = c == "x" ? r : (r&0x3|0x8);
      return v.toString(16);
    });
  }

  static findOrCreate(storage = localStorage) {
    if(storage.getItem("playerGuid")) {
      return storage.getItem("playerGuid");
    } else {
      const guid = this.generate();
      storage.setItem("playerGuid", guid);
      return guid;
    }
  }
};
