package blackbird.protocol.messages {
	import blackbird.framework.utils.writeString;
	import blackbird.protocol.impl.MQTT;
	import blackbird.protocol.types.MessageType;

	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
	 */
	public class WritePublish extends MQTT {
		public function WritePublish(topic : String, message : String, messageID : int, QoS : int = 1, retain : int = 0) {
			super();
			writeString(this.bytes, topic);
			this.bytes.writeByte(messageID >> 8);
			this.bytes.writeByte(messageID & 0xff);
			this.bytes.writeUTFBytes(message);

			var messageType : int = MessageType.PUBLISH;
			messageType += (QoS << 1);
			if (retain) messageType += 1;

			this.writeMessageType(messageType);
			this.writeMessageValue(this.bytes);

			this.bytes.clear();
			this._bytes = null;
		}
	}
}
