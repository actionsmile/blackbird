package blackbird.framework.api {
	import blackbird.signals.api.IMQTTSignals;

	import playstorm.additional.api.IDisposable;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public interface IMQTTSocket extends IDisposable {
		function connect(host : String, port : uint = 1883, username : String = null, password : String = null) : void;

		function subscribe(topic : String, QoS : int = 0) : void;

		function unsubscribe(topic : String, QoS : int = 0) : void;

		function publish(topic : String, message : String, QoS : int = 0, retain : int = 0) : void;

		function close() : void;

		function get keepalive() : int;

		function get signals() : IMQTTSignals;

		function get clientID() : String;

		function set clientID(value : String) : void;

		function get username() : String;

		function set username(value : String) : void;

		function get password() : String;

		function set password(value : String) : void;

		function get connected() : Boolean;
	}
}
