package blackbird.protocol.api {
	import scriptor.additional.api.IDisposable;

	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public interface IDataParser extends IDisposable {
		function parse() : void;
	}
}
