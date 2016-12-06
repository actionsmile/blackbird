package blackbird.protocol.types {
	/**
	 * @author Aziz Zainutdin (hello at scriptor.me)
	 */
	public final class MessageType {
		/**
		 * Client request to connect to Server
		 */
		public static const CONNECT : uint = 0x10;
		/**
		 * Connect Acknowledgment
		 */
		public static const CONNACK : uint = 0x20;
		/**
		 * Publish message
		 */
		public static const PUBLISH : uint = 0x30;
		/**
		 * Publish Acknowledgment
		 */
		public static const PUBACK : uint = 0x40;
		/**
		 * Publish Received assured delivery part 1
		 */
		public static const PUBREC : uint = 0x50;
		/**
		 * Publish Release assured delivery part 2
		 */
		public static const PUBREL : uint = 0x60;
		/**
		 * Publish Complete assured delivery part 3
		 */
		public static const PUBCOMP : uint = 0x70;
		/**
		 * Client Subscribe request
		 */
		public static const SUBSCRIBE : uint = 0x80;
		/**
		 * Subscribe Acknowledgment
		 */
		public static const SUBACK : uint = 0x90;
		/**
		 * Client Unsubscribe request
		 */
		public static const UNSUBSCRIBE : uint = 0xa0;
		/**
		 * Unsubscribe Acknowledgment
		 */
		public static const UNSUBACK : uint = 0xb0;
		/**
		 * PING Request
		 */
		public static const PINGREQ : uint = 0xc0;
		/**
		 * PING Response
		 */
		public static const PINGRESP : uint = 0xd0;
		/**
		 * Client is Disconnecting
		 */
		public static const DISCONNECT : uint = 0xe0;
	}
}
