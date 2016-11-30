package blackbird.protocol.types {
	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
	 */
	public class ConnackType {
		/**
		 * Connection Accepted
		 */
		public static const ACCEPTED : uint = 0x00;
		/**
		 * Connection Refused: unacceptable protocol version
		 */
		public static const UNACCEPTABLE_PROTOCOL_VERSION : uint = 0x01;
		/**
		 * Connection Refused: identifier rejected
		 */
		public static const IDENTIFIER_REJECTED : uint = 0x02;
		/**
		 * Connection Refused: server unavailable
		 */
		public static const SERVER_UNAVAILABLE : uint = 0x03;
		/**
		 * Connection Refused: bad user name or password
		 */
		public static const BAD_USERNAME_OR_PASSWORD : uint = 0x03;
		/**
		 * Connection Refused: not authorized
		 */
		public static const NOT_AUTHORIZED : uint = 0x03;
	}
}
