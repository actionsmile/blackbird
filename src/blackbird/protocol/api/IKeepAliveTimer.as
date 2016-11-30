package blackbird.protocol.api {
	import playstorm.additional.api.IDisposable;

	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
	 */
	public interface IKeepAliveTimer extends IDisposable {
		function start() : void;

		function stop() : void;

		function resetFailureTimer() : void;
	}
}
