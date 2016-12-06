package blackbird.protocol.messages {
	import blackbird.protocol.impl.MQTT;
	import blackbird.protocol.types.MessageType;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public class PublishAcknowledgement extends MQTT {
		public function PublishAcknowledgement(messageID : int, publicationQoS : int) {
			super();
			this.bytes.writeByte(messageID >> 8);
			this.bytes.writeByte(messageID & 0xff);
			
			var messageType : int = MessageType.PUBACK;
			messageType += publicationQoS << 1;
			
			this.writeMessageType(messageType);
			this.writeMessageValue(this.bytes);
			
			this.bytes.clear();
			this._bytes = null;
		}
	}
}
