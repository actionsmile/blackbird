package blackbird.protocol.impl {
	import blackbird.framework.impl.MQTTSocket;
	import blackbird.notification.BlackbirdNotifications;
	import blackbird.protocol.api.IDataParser;
	import blackbird.protocol.messages.Connack;
	import blackbird.protocol.messages.PublishAcknowledgement;
	import blackbird.protocol.messages.ReadPublish;
	import blackbird.protocol.types.ConnackType;
	import blackbird.protocol.types.MessageType;

	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
	 */
	public class DataParser implements IDataParser {
		/**
		 * @private
		 */
		private var isCreated : Boolean;
		/**
		 * @private
		 */
		private var _mqttSocket : MQTTSocket;

		public function DataParser(parentSocket : MQTTSocket, autoCreate : Boolean = true) {
			this._mqttSocket = parentSocket;
			autoCreate && this.create();
		}

		public function create() : void {
			if (!this.isCreated) {
				this.isCreated = true;
			}
		}

		public function dispose() : void {
			if (this.isCreated) {
				this.isCreated = false;
			}
		}

		public function get mqttSocket() : MQTTSocket {
			return this._mqttSocket;
		}

		public function parse() : void {
			while (this.mqttSocket.socket.bytesAvailable) {
				var result : MQTT = new MQTT();
				result.writeMessageFromBytes(this.mqttSocket.socket);
				var type : int = result.readType();
				switch (type) {
					case MessageType.CONNACK:
						this.onConnack(result);
						break;
					case MessageType.PINGRESP:
						this.mqttSocket.timer.resetFailureTimer();
						this.mqttSocket.signals.onNotification.dispatch(BlackbirdNotifications.PINGRESP);
						break;
					case MessageType.SUBACK:
						this.mqttSocket.signals.onNotification.dispatch(BlackbirdNotifications.SUBACK);
						break;
					case MessageType.PUBLISH:
						this.onPublish(result);
						break;
					case MessageType.PUBACK:
						this.onPublishAcknowledgement(result);
						break;
					default:
						break;
				}
			}
		}

		private function onPublishAcknowledgement(result : MQTT) : void {
			switch (result.readRemainingLength()) {
				case 0x02:
					result.varHead.position = 0;
					var messageId : uint = (result.varHead.readUnsignedByte() << 8) + result.varHead.readUnsignedByte();
					messageId;
					break;
				default:
					break;
			}
		}

		private function onPublish(result : MQTT) : void {
			var readPublish : ReadPublish = new ReadPublish(result);
			this.mqttSocket.signals.onMessage.dispatch(readPublish.topicName, readPublish.content);
			readPublish.clear();
			readPublish = null;

			var acknowledgement : PublishAcknowledgement = new PublishAcknowledgement(this.mqttSocket.messageID, result.readQoS());
			this.mqttSocket.socket.writeBytes(acknowledgement);
			this.mqttSocket.socket.flush();

			acknowledgement.clear();
			acknowledgement = null;
		}

		private function onConnack(result : MQTT) : void {
			var connack : Connack = new Connack(result);
			switch (connack.status) {
				case ConnackType.ACCEPTED:
					this.mqttSocket.signals.onConnect.dispatch();
					break;
				default:
			}

			connack.clear();
			connack = null;
		}
	}
}
