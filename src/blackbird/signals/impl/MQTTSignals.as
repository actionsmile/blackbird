package blackbird.signals.impl {
	import blackbird.signals.api.IMQTTSignals;

	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
	 */
	public class MQTTSignals implements IMQTTSignals {
		/**
		 * @private
		 */
		private var _onConnect : ISignal;
		/**
		 * @private
		 */
		private var _onClose : ISignal;
		/**
		 * @private
		 */
		private var _onError : ISignal;
		/**
		 * @private
		 */
		private var _onMessage : ISignal;
		private static var SIGNALS : Vector.<String> = new <String>["onConnect", "onClose", "onError", "onMessage"];
		/**
		 * @private
		 */
		private var isCreated : Boolean;
		/**
		 * @private
		 */
		private var _onNotification : ISignal;

		public function MQTTSignals(autoCreate : Boolean = true) {
			autoCreate && this.create();
		}

		public function create() : void {
			if (!this.isCreated) {
				this.isCreated = true;
			}
		}

		public function dispose() : void {
			if (this.isCreated) {
				this.removeAllHanlders(true);
				this.isCreated = false;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get onConnect() : ISignal {
			return this._onConnect ||= new Signal();
		}

		/**
		 * @inheritDoc
		 */
		public function get onClose() : ISignal {
			return this._onClose ||= new Signal();
		}

		/**
		 * @inheritDoc
		 */
		public function get onError() : ISignal {
			return this._onError ||= new Signal(Error);
		}

		/**
		 * @inheritDoc
		 */
		public function get onMessage() : ISignal {
			return this._onMessage ||= new Signal(String, String);
		}

		/**
		 * @inheritDoc
		 */
		public function get onNotification() : ISignal {
			return this._onNotification ||= new Signal();
		}

		/**
		 * @inheritDoc
		 */
		public function removeAllHanlders(disposeSignals : Boolean = false) : void {
			for each (var signalName : String in SIGNALS) {
				(this[signalName] as ISignal).removeAll();
				if (disposeSignals) this["_" + signalName] = null;
			}
		}
		// Private
	}
}
