package blackbird.signals.api {
	import playstorm.additional.api.IDisposable;

	import org.osflash.signals.ISignal;

	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
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
