package com.thecollectedmike.lufa 
{
	import flash.utils.ByteArray;	

	/**
	 * @author moj
	 */
	public class BitArray
	{
		public var bytes : ByteArray;
		private var position : uint;

		public function BitArray(bytes : ByteArray)
		{
			this.bytes = bytes;
			this.position = 0;
		}

		public function readFloat() : Number
		{
			return bytes.readFloat();
		}

		public function readByte() : int
		{
			var byte : uint = 0;
			for(var i : uint = 0;i < 8; i++)
			{
				byte = (readBit() << i) + byte;
			}
			return byte;
		}
		
		public function readBits(number : uint) : int
		{
			var byte : uint = 0;
			for(var i : uint = 0;i < number; i++)
			{
				byte = (readBit() << i) + byte;
			}
			return byte;
		}
		
		public function readBytes(number : uint) : int
		{
			var out : int = 0;
			for(var i : uint = 0;i < number; i++)
			{
				out =  (readByte() << (i*8)) + out;
				
			}
			
			return out;
		}

		public function peekByte() : int
		{
			var byte : int = bytes.readByte();
			bytes.position--;
			return byte;
		}

		public function readNybble() : int
		{
			var nybble : uint = 0;
			for(var i : uint = 0;i < 4; i++)
			{
				nybble = (readBit() << i) + nybble;
			}
			return nybble;
		}

		public function readBit() : int
		{
			var bitPos : int = position % 8;
			var byte : int = peekByte();
			var bit : int = (byte >> bitPos) & 1;
			position++;
			if(position % 8 == 0)
			{
				bytes.position++;
			}
			return bit;
		}
	}
}
