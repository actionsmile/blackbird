package blackbird.protocol.impl {
	import blackbird.protocol.api.IMQTT;
	import blackbird.protocol.types.MessageType;

	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
	 */
	public class MQTT extends ByteArray implements IMQTT {
		/**
		 * @private
		 */
		private var _version : String;
		/**
		 * @private
		 */
		private var type : uint;
		private var dup : uint;
		private var qos : uint;
		private var retain : uint;
		private var remainingLength : uint;
		/**
		 * @private
		 */
		private var _fixHead : ByteArray;
		private var _varHead : ByteArray;
		private var _payLoad : ByteArray;
		/**
		 * @protected
		 */
		protected var _bytes : ByteArray;

		public function get version() : String {
			return this._version ||= "v3.1";
		}

		/**
		 * @inheritDoc
		 */
		public function writeType(value : uint) : void {
			this.type = value;
			this.writeMessageType(this.type + (this.dup << 3) + (this.qos << 1) + this.retain);
		}

		/**
		 * @inheritDoc
		 */
		public function writeDUP(value : int) : void {
			this.dup = value;
			this.writeMessageType(this.type + (this.dup << 3) + (this.qos << 1) + this.retain);
		}

		/**
		 * @inheritDoc
		 */
		public function writeQoS(value : int) : void {
			this.qos = value;
			this.writeMessageType(this.type + (this.dup << 3) + (this.qos << 1) + this.retain);
		}

		/**
		 * @inheritDoc
		 */
		public function writeRetain(value : int) : void {
			this.retain = value;
			this.writeMessageType(this.type + (this.dup << 3) + (this.qos << 1) + this.retain);
		}

		/**
		 * @inheritDoc
		 */
		public function writeRemainingLength(value : int) : void {
			this.remainingLength = value;
			this.writeMessageType(this.type + (this.dup << 3) + (this.qos << 1) + this.retain);
		}

		/**
		 * @inheritDoc
		 */
		public function writeMessageType(value : int) : void {
			this.position = 0;
			this.writeByte(value);
			this.writeByte(this.remainingLength);
			this.readBytes(this.fixHead);

			this.type = value & 0xf0;
			this.dup = (value >> 3) & 0x01;
			this.qos = (value >> 1) & 0x03;
			this.retain = value & 0x01;
		}

		public function writeMessageValue(value : *) : void {
			this.position = 2;
			this.writeBytes(value);
			this.serialize();
			this.writeMessageType(this.type + (this.dup << 3) + (this.qos << 1) + this.retain);
		}

		public function writeMessageFromBytes(input : IDataInput) : void {
			this.position = 0;
			this.writeType(input.readUnsignedByte());
			this.remainingLength = input.readUnsignedByte();

			input.readBytes(this, 2, this.remainingLength);
			this.serialize();
			this.writeMessageType(this.type + (this.dup << 3) + (this.qos << 1) + this.retain);
		}

		public function readType() : uint {
			this.position = 0;
			return this.readUnsignedByte() & 0xf0;
		}

		public function readDUP() : uint {
			this.position = 0;
			return this.readUnsignedByte() >> 3 & 0x01;
		}

		public function readQoS() : uint {
			this.position = 0;
			return this.readUnsignedByte() >> 1 & 0x03;
		}

		public function readRetain() : uint {
			this.position = 0;
			return this.readUnsignedByte() & 0x01;
		}

		public function readRemainingLength() : uint {
			this.position = 1;
			return this.readUnsignedByte();
		}

		/**
		 * @inheritDoc
		 */
		public function get fixHead() : ByteArray {
			return this._fixHead ||= new ByteArray();
		}

		/**
		 * @inheritDoc
		 */
		public function get varHead() : ByteArray {
			return this._varHead ||= new ByteArray();
		}

		/**
		 * @inheritDoc
		 */
		public function get payLoad() : ByteArray {
			return this._payLoad ||= new ByteArray();
		}

		public function get bytes() : ByteArray {
			return this._bytes ||= new ByteArray();
		}

		public function serialize() : void {
			this.type = this.readType();
			this.dup = this.readDUP();
			this.qos = this.readQoS();
			this.retain = this.readRetain();

			this.position = 0;
			this.readBytes(this.fixHead, 0, 2);

			this.position = 2;
			switch (this.type) {
				// Remaining Length is the length of the variable header (12 bytes) and the length of the Payload
				case MessageType.CONNECT:
					this.readBytes(this.varHead, 0, 12);
					this.readBytes(this.payLoad);
					this.remainingLength = this.varHead.length + this.payLoad.length;
					break;
				// Remaining Length is the length of the variable header plus the length of the payload
				case MessageType.PUBLISH:
					var index : int = (this.readUnsignedByte() << 8) + this.readUnsignedByte();
					this.position = 2;
					this.readBytes(this.varHead, 0, index + (this.qos ? 4 : 2));
					this.readBytes(this.payLoad);
					this.remainingLength = this.varHead.length + this.payLoad.length;
					break;
				// Remaining Length is the length of the payload
				case MessageType.SUBSCRIBE:
				case MessageType.SUBACK:
				case MessageType.UNSUBSCRIBE:
					this.readBytes(this.varHead, 0, 2);
					this.readBytes(this.payLoad);
					this.remainingLength = this.varHead.length + this.payLoad.length;
					break;
				// Remaining Length is the length of the variable header (2 bytes)
				default:
					this.readBytes(this.varHead);
					this.remainingLength = this.varHead.length;
					break;
			}
		}
	}
}
