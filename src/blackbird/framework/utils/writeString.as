package blackbird.framework.utils {
	import scriptor.additional.enums.Charset;

	import flash.utils.ByteArray;

	/**
	 * @author Aziz Zaynutdinov (aziz.zaynutdinov at playstorm.com)
	 */
	public function writeString(bytes : ByteArray, string : String) : void {
		var len : int = string.length;
		var msb : int = len >> 8;
		var lsb : int = len & 0xff;
		bytes.writeByte(msb);
		bytes.writeByte(lsb);
		bytes.writeMultiByte(string, Charset.UTF8);
	}
}
