package blackbird.protocol.api {
	import playstorm.additional.api.IDisposable;

	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
	 */
	public interface IDataParser extends IDisposable {
		function parse() : void;
	}
}
