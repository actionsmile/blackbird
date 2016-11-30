package blackbird.protocol.messages {
	import blackbird.protocol.impl.MQTT;
	import blackbird.protocol.types.MessageType;

	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
	 */
	public class Pingreq extends MQTT {
		public function Pingreq() {
			this.writeMessageType(MessageType.PINGREQ);
			this.writeMessageValue(this.bytes);
			
			this._bytes = null;
		}
	}
}
