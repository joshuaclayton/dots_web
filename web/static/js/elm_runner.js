import Guid from "./guid"
import Notifier from "./notifier"
import Elm from "./elm/DotsAndBoxes"

export default class ElmRunner {
  constructor(options) {
    this.channel = options.channel;
    this.element = options.element;
    this.gameId = options.gameId;
    this.game = this._buildGame();
  }

  run() {
    this._configurePorts();
    this._registerUnloadCallback();
    this._subscribeToUpdates();
    this._registerNotifications();
    this._subscribeToWebSocket();
  }

  _configurePorts() {
    this.game.ports.setGameId.send(this.gameId);
    this.game.ports.setPlayerGuid.send(Guid.findOrCreate());
  }

  _registerUnloadCallback() {
    window.onbeforeunload = ()=> {
      this.channel.push("player:leave", { game_id: this.gameId, player: Guid.findOrCreate() });
    };
  }

  _subscribeToUpdates() {
    this.game.ports.broadcastUpdates.subscribe(data => {
      var clonedData = Object.assign({}, JSON.parse(data));
      var action = clonedData.action;
      delete(clonedData.action);

      this.channel.push(action, clonedData);
    });
  }

  _registerNotifications() {
    this.game.ports.broadcastIsCurrentPlayer.subscribe(isCurrentPlayer => {
      if (isCurrentPlayer && document.hidden) {
        Notifier.notify("Dots and Boxes", "It's your turn!");
      }
    });
  }

  _subscribeToWebSocket() {
    this.channel.on(`game:update:${this.gameId}`, payload => {
      console.log('receiving payload', payload);
      this.game.ports.setState.send(payload.lobby);
    });
  }

  _buildGame() {
    return Elm.embed(
      Elm.DotsAndBoxes,
      this.element,
      this._elmDefaultState
    );
  }

  get _elmDefaultState() {
    return { setGameId: 0, setState: {}, setPlayerGuid: "" };
  }
}
