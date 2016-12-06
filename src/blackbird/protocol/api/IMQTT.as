package blackbird.protocol.api {
	import flash.utils.ByteArray;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public interface IMQTT {
		function writeType(value : uint) : void;

		function writeDUP(value : int) : void;

		function writeQoS(value : int) : void;

		function writeRetain(value : int) : void;

		function writeRemainingLength(value : int) : void;

		function writeMessageType(value : int) : void;

		function get fixHead() : ByteArray;
	}
}
