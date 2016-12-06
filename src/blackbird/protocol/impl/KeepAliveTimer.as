package blackbird.protocol.impl {
	import blackbird.framework.impl.MQTTSocket;
	import blackbird.protocol.api.IKeepAliveTimer;
	import blackbird.protocol.messages.Pingreq;

	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public class KeepAliveTimer extends Object implements IKeepAliveTimer {
		/**
		 * @private
		 */
		private var isCreated : Boolean;
		/**
		 * @private
		 */
		private var _mqttSocket : MQTTSocket;
		/**
		 * @private
		 */
		private var _timer : Timer;
		/**
		 * @private
		 */
		private var _failureTimer : Timer;

		public function KeepAliveTimer(parentSocket : MQTTSocket, autoCreate : Boolean = true) {
			this._mqttSocket = parentSocket;
			autoCreate && this.create();
		}

		public function create() : void {
			if (!this.isCreated) {
				this.timer.addEventListener(TimerEvent.TIMER, this.onTick);
				this.failureTimer.addEventListener(TimerEvent.TIMER, this.onNotResponding);
				this.isCreated = true;
			}
		}

		public function dispose() : void {
			if (this.isCreated) {
				this.stop();

				this.timer.hasEventListener(TimerEvent.TIMER) && this.timer.removeEventListener(TimerEvent.TIMER, this.onTick);
				this.failureTimer.hasEventListener(TimerEvent.TIMER) && this.failureTimer.removeEventListener(TimerEvent.TIMER, this.onNotResponding);
				this._timer = null;
				this._failureTimer = null;
				this.isCreated = false;
			}
		}

		public function get mqttSocket() : MQTTSocket {
			return this._mqttSocket;
		}

		public function get timer() : Timer {
			return this._timer ||= new Timer(this.mqttSocket.keepalive * 1000);
		}

		public function get failureTimer() : Timer {
			return this._failureTimer ||= new Timer(this.mqttSocket.keepalive * 4500);
		}

		public function start() : void {
			this.timer.start();
			this.failureTimer.start();
		}

		public function stop() : void {
			this.timer.stop();
			this.failureTimer.stop();
		}

		public function resetFailureTimer() : void {
			this.failureTimer.reset();
			this.failureTimer.start();
		}

		// Handlers
		private function onTick(event : TimerEvent) : void {
			if (this.mqttSocket.socket.connected) {
				var ping : Pingreq = new Pingreq();
				this.mqttSocket.socket.writeBytes(ping);
				this.mqttSocket.socket.flush();
				ping.clear();
				ping = null;
			}
		}

		private function onNotResponding(event : TimerEvent) : void {
			this.mqttSocket.close();
		}
	}
}
