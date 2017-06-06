package com.thecollectedmike.lufa 
{

	/**
	 * @author moj
	 */
	public class LuaState 
	{
		private var _majorVersion : uint;
		private var _minorVersion : uint;
		private var _endianness : uint;
		private var _intSize : uint;
		private var _size_tSize:uint;
		private var _instrSize : uint;
		private var _lua_NumberSize : uint;
		private var _integralFlag : uint;
		private var _formatVersion : uint;
		
		public function get majorVersion() : uint
		{
			return _majorVersion;
		}
		
		public function set majorVersion(majorVersion : uint) : void
		{
			_majorVersion = majorVersion;
		}
		
		public function get minorVersion() : uint
		{
			return _minorVersion;
		}
		
		public function set minorVersion(minorVersion : uint) : void
		{
			_minorVersion = minorVersion;
		}
		
		public function get endianness() : uint
		{
			return _endianness;
		}
		
		public function set endianness(endianness : uint) : void
		{
			_endianness = endianness;
		}
		
		public function get intSize() : uint
		{
			return _intSize;
		}
		
		public function set intSize(intSize : uint) : void
		{
			_intSize = intSize;
		}
		
		public function get size_tSize() : uint
		{
			return _size_tSize;
		}
		
		public function set size_tSize(size_tSize : uint) : void
		{
			_size_tSize = size_tSize;
		}
		
		public function get instrSize() : uint
		{
			return _instrSize;
		}
		
		public function set instrSize(instrSize : uint) : void
		{
			this._instrSize = instrSize;
		}
		
		public function get lua_NumberSize() : uint
		{
			return _lua_NumberSize;
		}
		
		public function set lua_NumberSize(lua_NumberSize : uint) : void
		{
			this._lua_NumberSize = lua_NumberSize;
		}
		
		public function get integralFlag() : uint
		{
			return _integralFlag;
		}
		
		public function set integralFlag(integralFlag : uint) : void
		{
			this._integralFlag = integralFlag;
		}
		
		public function get formatVersion() : uint
		{
			return _formatVersion;
		}
		
		public function set formatVersion(formatVersion : uint) : void
		{
			_formatVersion = formatVersion;
		}
	}
}
