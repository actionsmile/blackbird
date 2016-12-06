package blackbird.protocol.messages {
	import blackbird.protocol.impl.MQTT;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public class Connack extends MQTT {
		private var _status : uint;

		public function Connack(acknowledgment : MQTT) {
			super();
			this.bytes.writeBytes(acknowledgment.varHead);
			this.bytes.position = 1;
			
			this._status = this.bytes.readUnsignedByte();
			
			this.bytes.clear();
			this._bytes = null;
		}

		public function get status() : uint {
			return this._status;
		}
	}
}
