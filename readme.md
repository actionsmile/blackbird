# Blackbird. AS3 MQTT framework
---
### Requirement
[as3signals](https://github.com/robertpenner/as3-signals)
This is the best way to pass events, as I see it :)
### Usage
```as3
var clientID : String = "SOME_UID";
var autoCreate : Boolean = false; // If you pass TRUE create() method will be called in constructor
var dispatcher : IEventDispatcher;

this.dispatcher = new EventDisptahcer;
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
	switch(topic){
		case "ufo/Bridge_Device_Reset/commands":
			if(message == "all" || message == "cockpit") {
				this.dispatcher.dispatchEvent(new GameEvent(GameEvent.RESET));
			}
			break;
		case "ufo/Bridge_Cocpit_Game/commands":
			if(message.toLowerCase() == "status" || message.toLowerCase() == "ping") {
				this.mqtt.publish(<TOPIC_TO_PUBLISH>, <MESSAGE_TO_PUBLISH>);
			} else if(message.toLowerCase() == "reset") {
				this.dispatcher.dispatchEvent(new GameEvent(GameEvent.RESET));
			}
			break;
		default:
				break;
	}
}

private function onConnectionEstablished() : void {
	trace("Connected to '<HOST>:<PORT>'");
	this.dispatcher.dispatchEvent(new MQTTEvent(MQTTEvent.CONNECTED));
}

private function onConnectionLost() : void {
	trace("Connection lost");
	this.dispatcher.dispatchEvent(new MQTTEvent(MQTTEvent.CLOSE));
}
```