![Blackbird][title_image]
# [Blackbird. AS3 MQTT framework][blackbird]

### Requirement
[as3signals][signals]
This is the best way to pass events, as I see it :)
### Usage
```as3
var clientID : String = "SOME_UID";
var autoCreate : Boolean = false; // If you pass TRUE create() method will be called in constructor

this.mqtt = new MQTTSocket(clientID, autoCreate);

if (!this.mqtt.connected) {
	this.mqtt.signals.onConnect.add(this.onConnectionEstablished);
	this.mqtt.signals.onClose.add(this.onConnectionLost);
	this.mqtt.signals.onMessage.add(this.onIncomingMessage);
	this.mqtt.clientID = clientID;
	this.mqtt.create();
	trace("Connecting to mqtt-server at '<HOST>:<PORT>'");
	this.mqtt.connect();
}

private function onIncomingMessage(topic : String, message : String) : void {
	trace("Topic: " + topic + "\nMessage: " + message);
}

private function onConnectionEstablished() : void {
	trace("Connected to '<HOST>:<PORT>'");
}

private function onConnectionLost() : void {
	trace("Connection lost");
}
```

---
### LICENSE
[MIT][license]

[title_image]: https://dl.dropboxusercontent.com/u/41163165/readme_title.png
[blackbird]: http://blackbird.scriptor.me
[signals]: https://github.com/robertpenner/as3-signals
[license]: https://github.com/actionsmile/blackbird/blob/master/LICENSE.md
