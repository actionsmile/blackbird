package blackbird.protocol.messages {
	import blackbird.protocol.impl.MQTT;

	import scriptor.additional.enums.Charset;

	import flash.utils.getTimer;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public class ReadPublish extends MQTT {
		private var _topicName : String;
		private var _content : String;

		public function ReadPublish(publish : MQTT) {
			super();
			publish.position = 0;
			this.varHead.writeBytes(publish.varHead);
			this.varHead.position = 0;

			var stringLength : uint = (this.varHead.readUnsignedByte() << 8) + this.varHead.readUnsignedByte();
			this.topicName = this.varHead.readMultiByte(stringLength, Charset.UTF8);

			if (publish.readQoS()) {
				var messageId : uint = (this.varHead.readUnsignedByte() << 8) + this.varHead.readUnsignedByte();
				trace(int(getTimer() / 1000), 'Read messageId: ' + (messageId));
			}

			this.payLoad.writeBytes(publish.payLoad);
			this.payLoad.position = 0;
			if (this.payLoad.length > 0) {
				stringLength = (this.payLoad.readUnsignedByte() << 8) + this.payLoad.readUnsignedByte();
				if (stringLength > this.payLoad.length) {
					stringLength = this.payLoad.length;
					this.payLoad.position = 0;
				}

				this.content = this.payLoad.readMultiByte(stringLength, Charset.UTF8);
			}
		}

		public function set topicName(value : String) : void {
			if (this._topicName != value) this._topicName = value;
		}

		public function get topicName() : String {
			return this._topicName ||= "";
		}

		public function set content(value : String) : void {
			if (this._content != value) this._content = value;
		}

		public function get content() : String {
			return this._content ||= "";
		}
	}
}
