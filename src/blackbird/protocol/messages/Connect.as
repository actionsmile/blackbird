package blackbird.protocol.messages {
	import blackbird.framework.utils.writeString;
	import blackbird.protocol.impl.MQTT;
	import blackbird.protocol.types.MessageType;

	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
	 */
	public class Connect extends MQTT {
		public function Connect(keepalive : int, clientID : String, username : String = "", password : String = "") {
			super();
			// Protocol name + version
			this.bytes.writeByte(0x00);
			this.bytes.writeByte(0x06);
			this.bytes.writeByte(0x4d);
			this.bytes.writeByte(0x51);
			this.bytes.writeByte(0x49);
			this.bytes.writeByte(0x73);
			this.bytes.writeByte(0x64);
			this.bytes.writeByte(0x70);
			this.bytes.writeByte(0x03);

			/**
			 * TODO message flags
			 */
			this.bytes.writeByte(0x02);

			this.bytes.writeByte(keepalive >> 8);
			this.bytes.writeByte(keepalive & 0xff);

			writeString(this.bytes, clientID);
			writeString(this.bytes, username);
			writeString(this.bytes, password);

			this.writeMessageType(MessageType.CONNECT);
			this.writeMessageValue(this.bytes);

			this.bytes.clear();
			this._bytes = null;
		}
	}
}
