package blackbird.framework.impl {
	import blackbird.framework.api.IMQTTSocket;
	import blackbird.framework.mqtt;
	import blackbird.protocol.api.IDataParser;
	import blackbird.protocol.api.IKeepAliveTimer;
	import blackbird.protocol.impl.DataParser;
	import blackbird.protocol.impl.KeepAliveTimer;
	import blackbird.protocol.messages.Connect;
	import blackbird.protocol.messages.Subscribe;
	import blackbird.protocol.messages.WritePublish;
	import blackbird.signals.api.IMQTTSignals;
	import blackbird.signals.impl.MQTTSignals;

	import robotlegs.bender.framework.impl.UID;

	import org.osflash.signals.natives.sets.SocketSignalSet;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.Endian;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public class MQTTSocket extends Object implements IMQTTSocket {
		/**
		 * @private if <code>true</code> object created
		 */
		private var isCreated : Boolean;
		/**
		 * @private
		 */
		private var _signals : MQTTSignals;
		/**
		 * @private
		 */
		private var _socket : Socket;
		/**
		 * @private
		 */
		private var _socketSignals : SocketSignalSet;
		/**
		 * @private
		 */
		private var _clientID : String;
		/**
		 * @private
		 */
		private var _keepalive : int = 60;
		/**
		 * @private
		 */
		private var isConnected : Boolean;
		/**
		 * @private
		 */
		private var _username : String;
		/**
		 * @private
		 */
		private var _password : String;
		/**
		 * @private
		 */
		private var _handler : IDataParser;
		/**
		 * @private
		 */
		private var _timer : IKeepAliveTimer;
		/**
		 * @private
		 */
		private var _messageID : int = 0;
		mqtt var connected : Boolean;

		public function MQTTSocket(clientUID : String = null, autoCreate : Boolean = true) {
			this.clientID = clientUID || UID.create(this);
			autoCreate && this.create();
		}

		/**
		 * @inheritDoc
		 */
		public function create() : void {
			if (!this.isCreated) {
				this.socketSignals.connect.add(this.onSocketConnected);
				this.socketSignals.socketData.add(this.onSocketData);
				this.socketSignals.ioError.add(this.onSocketError);
				this.socketSignals.securityError.add(this.onSocketError);
				this.socketSignals.close.add(this.onSocketClosed);
				this.signals.onConnect.addOnce(this.onMQTTConnected);

				this.isCreated = true;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function dispose() : void {
			if (this.isCreated) {
				this.close();
				this.signals.dispose();
				this._signals = null;

				this.socketSignals.removeAll();
				this._socketSignals = null;
				this.socket.close();
				this._socket = null;
				this.isCreated = false;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function connect(host : String, port : uint = 1883, username : String = null, password : String = null) : void {
			this.username = username || "";
			this.password = password || "";
			this.socket.connect(host, port);
		}

		/**
		 * @inheritDoc
		 */
		public function subscribe(topic : String, QoS : int = 0) : void {
			var subscribe : Subscribe = new Subscribe(topic, messageID, QoS);
			subscribe.position = 0;
			this.socket.writeBytes(subscribe);
			this.socket.flush();
		}

		/**
		 * @inheritDoc
		 */
		public function unsubscribe(topic : String, QoS : int = 0) : void {
		}

		/**
		 * @inheritDoc
		 */
		public function publish(topic : String, message : String, QoS : int = 0, retain : int = 0) : void {
			this.messageID++;
			var publishMessage : WritePublish = new WritePublish(topic, message, this.messageID);// , QoS, retain);
			publishMessage.position = 0;
			this.socket.writeBytes(publishMessage);
			this.socket.flush();

			publishMessage.clear();
			publishMessage = null;
		}

		/**
		 * @inheritDoc
		 */
		public function close() : void {
			this.signals.onClose.dispatch();
		}

		/**
		 * @inheritDoc
		 */
		public function get clientID() : String {
			return this._clientID;
		}

		public function set clientID(value : String) : void {
			if (this._clientID != value) this._clientID = value;
		}

		/**
		 * @inheritDoc
		 */
		public function get signals() : IMQTTSignals {
			return this._signals ||= new MQTTSignals();
		}

		/**
		 * Creates an instance of socket if its <code>null</code>, or returns previously copy
		 */
		public function get socket() : Socket {
			return this._socket ||= new Socket();
		}

		public function get keepalive() : int {
			return this._keepalive;
		}

		public function get username() : String {
			return this._username ||= "";
		}

		public function set username(value : String) : void {
			if (this._username != value) this._username = value;
		}

		public function get password() : String {
			return this._password ||= "";
		}

		public function set password(value : String) : void {
			if (this._password != value) this._password = value;
		}

		/**
		 * Native signals set, dispatching by <code>Socket</code> object
		 */
		public function get socketSignals() : SocketSignalSet {
			return this._socketSignals ||= new SocketSignalSet(this.socket);
		}

		public function get handler() : IDataParser {
			return this._handler ||= new DataParser(this);
		}

		public function get timer() : IKeepAliveTimer {
			return this._timer ||= new KeepAliveTimer(this);
		}

		private function establishMQTTConnection() : void {
			if (this.socket.endian != Endian.BIG_ENDIAN) {
				throw new Error("Wrong endian", 10201);
			}
			if (!this.isConnected) {
				var connection : Connect = new Connect(this.keepalive, this.clientID + Math.random().toFixed(8), this.username, this.password);
				this.socket.writeBytes(connection);
				this.socket.flush();
				connection.clear();
				connection = null;
				mqtt::connected = true;
			}
		}

		// Handlers
		/**
		 * @eventType flash.events.Event.CONNECT
		 */
		private function onSocketConnected(event : Event) : void {
			this.establishMQTTConnection();
		}

		private function onMQTTConnected() : void {
			this.isConnected = true;
			this.timer.start();
		}

		/**
		 * @eventType flash.events.ProgressEvent.SOCKET_DATA
		 */
		private function onSocketData(event : ProgressEvent) : void {
			this.handler.parse();
		}

		/**
		 * @eventType flash.events.ErrorEvent.ERROR
		 */
		private function onSocketError(event : ErrorEvent) : void {
			this.signals.onError.dispatch(new Error(event.text, event.errorID));
		}

		/**
		 * @eventType flash.events.Event.CLOSE
		 */
		private function onSocketClosed(event : Event) : void {
			this.signals.onClose.dispatch();
		}

		public function get messageID() : int {
			return this._messageID;
		}

		public function set messageID(value : int) : void {
			if (this._messageID != value) this._messageID = value;
		}

		public function get connected() : Boolean {
			var result : Boolean = mqtt::connected;
			return result;
		}
	}
}
