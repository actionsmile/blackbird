package scriptor.additional.api {
	public interface IDisposable {
		/**
		 * Creates all environment for the instance of an object
		 */
		function create();

		/**
		 * Prepares an object to dispose
		 */
		function dispose();
	}
}