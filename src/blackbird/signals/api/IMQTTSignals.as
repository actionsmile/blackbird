package blackbird.signals.api {
	import scriptro.additional.api.IDisposable;

	import org.osflash.signals.ISignal;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public interface IMQTTSignals extends IDisposable {
		function get onConnect() : ISignal;

		function get onClose() : ISignal;

		function get onError() : ISignal;

		function get onMessage() : ISignal;

		function get onNotification() : ISignal;

		function removeAllHanlders(disposeSignals : Boolean = false) : void;
	}
}
