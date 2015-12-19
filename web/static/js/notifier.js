class Notifier {
  static notify(title, body) {
    if (!("Notification" in window)) {
      // no support
    } else if (Notification.permission === "granted") {
      new Notification(title, { body: body });
    } else if (Notification.permission !== 'denied') {
      Notification.requestPermission(function (permission) {
        if (permission === "granted") {
          new Notification(title, { body: body });
        }
      });
    }
  }
}

export default Notifier;
