package com.thecollectedmike.lufa 
{
	import flash.utils.Endian;	
	import flash.utils.ByteArray;

	/**
	 * @author moj
	 */
	public class LuaByteArray extends BitArray
	{
		private var toggle : Boolean;
		private var state : LuaState;

		public function LuaByteArray(bytes : ByteArray, state : LuaState)
		{
			super(bytes);
			this.state = state;
			this.toggle = false;
		}

		/*********************************
		 * Data structures
		 */

		/*	public function readNybble() : uint
		{
		var byte : uint = readByte();
		var result : uint;
			
		if(!toggle)
		{
		// msb
		result = (byte & 0xF0) >> 4;
		position--;
		}
		else
		{
		result = (byte & 0x0F);
		}
			
		toggle = !toggle;
			
		return result;
		}

		public function readLuaByte() : int
		{
		var msb : int = readNybble();
		var byte : int = (msb << 4) + readNybble();
		return byte;
		} */

		public function readString() : String
		{
			var size_t : uint = readSize_t();
			var out : String = "";
			for(var i : uint = 0;i < size_t; i++)
			{
				var char : uint = readByte();
				if(char != 0)
				{
					out += String.fromCharCode(char);
				}
			}
			
			return out;
		}

		public function readInteger() : int
		{
			return readBytes(state.intSize);
		}

		public function readSize_t() : int
		{
			return readBytes(state.size_tSize);
		}

		public function readNumber() : Number
		{
			var mantissa : Number = 0;
			var exponent : Number = 0;
			var sign : uint;
			
			if(state.lua_NumberSize == 8)
			{
				// Get an array of bits
				var bits : Array = [];
				for(var i : Number = 0;i < 64; i++) 
				{ 
					bits.unshift(readBit());
				}
				
				sign = bits.shift();
				
				exponent = 0;
				for(var e : uint = 0;e < 11; e++)
				{
					exponent = exponent * 2;
					exponent = exponent + bits.shift();
				}
				
				var total : Number = 0;
				for(var m : uint = 0;m < 52; m++)
				{
					total = total * 2;
					total = total + bits.shift();
				}
				
				
				
				// Add leading 1
				var a : Number = Math.pow(2, 51) + (total / 2);
				mantissa = (a / Math.pow(2, 52)) * 2;
				
				
				if(exponent == 0 && total == 0)
				{
					return 0;
				}
				
				exponent -= 1023;
			}
			else if(state.lua_NumberSize == 4)
			{
				mantissa = readBits(23);
				exponent = readBits(8);
				sign = readBits(1);
			}
			
			var value : Number = Math.pow(-1, sign) * (Math.pow(2, exponent)) * (mantissa);
			
			
			return value; 
		}
	}
}
