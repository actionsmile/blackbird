package blackbird.protocol.messages {
	import blackbird.protocol.impl.MQTT;
	import blackbird.protocol.types.MessageType;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public class Pingreq extends MQTT {
		public function Pingreq() {
			this.writeMessageType(MessageType.PINGREQ);
			this.writeMessageValue(this.bytes);
			
			this._bytes = null;
		}
	}
}
