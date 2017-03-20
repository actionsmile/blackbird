![Blackbird][title_image]

---
### INSTALLATION

This distribution of Blackbird AS3 Micro-Architecture provides a production ready binary SWC file (blackbird-framework-v1.0.4.swc).

The SWC file should be enough to get started. Simply drop it in your projects libs folder (or wherever you keep external libraries) and you will have access to the fully functioning framework. 

---
### BUILDING

In addition to the SWC file in this distribution package, the Blacknird vv1.0.4 source code is also provided.

The source code is dependent on the [as3signals][signals] library.

If you would prefer to build from the source, it is highly recommended that you download the Blackbird project in its entirety. This project contains all of the required libraries and ANT build scripts to generate SWC files of the framework.

---
### USAGE
This is an example of usage Blackbird framework.
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

The [MIT License][license]

Copyright (c) 2015-2016 Aziz Zainutdin.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


[title_image]: https://photos-1.dropbox.com/t/2/AAAV7OR2ynXNEBth2hn4jSt0uOi71sBdbgmzIpKztYmXCQ/12/41163165/png/32x32/1/_/1/2/readme_title.png/EM2Ytx8YwKIBIAIoAg/YSyNZqukx_pGzykD5g9JSb3qHqvRCdZrFszdrnSStS0
[blackbird]: http://blackbird.scriptor.me
[signals]: https://github.com/robertpenner/as3-signals
[license]: https://github.com/actionsmile/blackbird/blob/master/LICENSE.md
