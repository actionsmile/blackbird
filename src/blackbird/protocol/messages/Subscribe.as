package blackbird.protocol.messages {
	import blackbird.framework.utils.writeString;
	import blackbird.protocol.impl.MQTT;
	import blackbird.protocol.types.MessageType;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public class Subscribe extends MQTT {
		public function Subscribe(topicname : String, messageID : int, QoS : int = 1) {
			super();
			this.bytes.writeByte(messageID >> 8);
			this.bytes.writeByte(messageID & 0xff);
			
			writeString(this.bytes, topicname);
			this.bytes.writeByte(QoS);
			
			var messageType : int = MessageType.SUBSCRIBE;
			messageType += QoS << 1;
			
			this.writeMessageType(messageType);
			this.writeMessageValue(this.bytes);
			
			this.bytes.clear();
			this._bytes = null;
		}
	}
}
