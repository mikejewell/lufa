package com.thecollectedmike.lufa 
{
	import flash.utils.ByteArray;		

	/**
	 * @author moj
	 */
	public class LuaScript extends LuaFunction
	{
		private var state : LuaState;
		private var toggle : Boolean;
		private var bytes : LuaByteArray;

		public function LuaScript(byteArray:ByteArray)
		{
			this.state = new LuaState();
			this.bytes = new LuaByteArray(byteArray, state);
			
			this.toggle = false;
		
			parseHeader();
			
			this.fromBytes(bytes);
			
		}
			
		
		/*********************************
		 * File format
		 */
		
		
		private function parseHeader() : void
		{
			// Validate signature
			if(bytes.readBytes(4) != 0x61754c1b)
			{
				throw new Error("Invalid signature");
			}
	
			state.minorVersion = bytes.readNybble();
			trace("Minor: "+state.minorVersion);
			state.majorVersion = bytes.readNybble();
			state.formatVersion = bytes.readByte();
			
			state.endianness = bytes.readByte();
			state.intSize = bytes.readByte();
			state.size_tSize = bytes.readByte();
			state.instrSize = bytes.readByte();
			state.lua_NumberSize = bytes.readByte();
			state.integralFlag = bytes.readByte();	
			
			for(var s:String in state)
			{
				trace(s+"="+state[s]);
			}
		}

	}
}
