package com.thecollectedmike.lufa 
{

	/**
	 * @author moj
	 */
	public class LuaFunction 
	{
		private var _instructions : Array;
		private var _constants : Array;
		private var _functions : Array;
		private var _sourceLines : Array;
		private var _locals : Array;
		private var _upvalues : Array;
		private var _maxStack : int;

		public function LuaFunction()
		{			
			this._functions = [];
			this._constants = [];
			this._instructions = [];
			this._upvalues = [];
			this._locals = [];
			this._sourceLines = [];
		}

		public function instantiate() : LuaFunction
		{
			var out : LuaFunction = this.clone();
			return out;	
		}

		private function clone() : LuaFunction
		{
			var cloned : LuaFunction = new LuaFunction();
			cloned.constants = this.constants;
			cloned.instructions = this.instructions;
			cloned.upvalues = this.upvalues;
			cloned.locals = this.locals;
			cloned.sourceLines = this.sourceLines;
			cloned.maxStack = this.maxStack;
			
			for each(var func:LuaFunction in this.functions)
			{
				cloned.functions.push(func.clone());
			}
			
			return cloned;
		}

		public function fromBytes(byteArray : LuaByteArray) : void
		{
						
			trace("Name: " + byteArray.readString());
			trace("Line def: " + byteArray.readInteger());
			trace("Last line def: " + byteArray.readInteger());
			trace("Up vals: " + byteArray.readByte());
			trace("Params: " + byteArray.readByte());
			trace("var: " + byteArray.readByte());
			this._maxStack = byteArray.readByte();
			trace("maxStack: "+this._maxStack);

			this.parseInstructionList(byteArray);			
			this.parseConstantList(byteArray);
			this.parseFunctionList(byteArray);
			this.parseSourceLinePositionList(byteArray);
			this.parseLocalsList(byteArray);
			this.parseUpValueList(byteArray);
		}

		public static function createFromByteArray(byteArray : LuaByteArray) : LuaFunction
		{		
			var out : LuaFunction = new LuaFunction();	
			out.fromBytes(byteArray);
			return out;
		}

		public function get instructions() : Array
		{
			return _instructions;
		}

		public function get constants() : Array
		{
			return _constants;
		}

		public function get functions() : Array
		{
			return _functions;
		}

		public function get sourceLines() : Array
		{
			return _sourceLines;
		}

		public function get locals() : Array
		{
			return _locals;
		}

		public function get upvalues() : Array
		{
			return _upvalues;
		}

		
		private function parseConstantList(byteArray : LuaByteArray) : void
		{
			trace("Constants");
			var sizek : uint = byteArray.readInteger();
			for(var i : uint = 0;i < sizek; i++)
			{
				var value : Object = null;
				var type : uint = byteArray.readByte();
				switch(type)
				{
					case 1:
						value = byteArray.readBit();
						trace(i+" = Boolean "+value);
						break;
					case 3:
						value = byteArray.readNumber();
						trace(i+" = Number "+value);
						break;
					case 4:
						value = byteArray.readString();
						trace(i+" = String "+value);
						break;
				}
				
				this._constants.push(value);
			}
		}

		private function parseInstructionList(byteArray : LuaByteArray) : void
		{
			var sizecode : uint = byteArray.readInteger();
			trace(sizecode + " instructions");
			
			for(var i : uint = 0;i < sizecode; i++)
			{
				this._instructions.push(Instruction.fromBytes(byteArray));
			}
		}

		private function parseFunctionList(byteArray : LuaByteArray) : void
		{
			var sizep : uint = byteArray.readInteger();
		
			trace(sizep + " funcs");	
			for(var i : uint = 0;i < sizep; i++)
			{
				this._functions.push(LuaFunction.createFromByteArray(byteArray));	
			}
		}
		
		private function parseUpValueList(byteArray : LuaByteArray) : void
		{
			var sizeupvalues : uint = byteArray.readInteger();
			trace(sizeupvalues+" upvalues");
			for(var i:uint=0; i<sizeupvalues; i++)
			{
				byteArray.readString();
			}
		}

		private function parseLocalsList(byteArray : LuaByteArray) : void
		{
			var sicelocvars : uint = byteArray.readInteger();
			trace(sicelocvars+" locavars");
			for(var i:uint=0; i<sicelocvars; i++)
			{
				byteArray.readString();
				byteArray.readInteger();
				byteArray.readInteger();
			}
		}

		private function parseSourceLinePositionList(byteArray : LuaByteArray) : void
		{
			var sizelinepos : uint = byteArray.readInteger();
			trace(sizelinepos+" linepos");
			for(var i:uint=0; i<sizelinepos; i++)
			{
				byteArray.readInteger();
			}
		}

		public function set instructions(instructions : Array) : void
		{
			_instructions = instructions;
		}

		public function set constants(constants : Array) : void
		{
			_constants = constants;
		}

		public function set functions(functions : Array) : void
		{
			_functions = functions;
		}

		public function set sourceLines(sourceLines : Array) : void
		{
			_sourceLines = sourceLines;
		}

		public function set locals(locals : Array) : void
		{
			_locals = locals;
		}

		public function set upvalues(upvalues : Array) : void
		{
			_upvalues = upvalues;
		}
		
		public function get maxStack() : int
		{
			return _maxStack;
		}
		
		public function set maxStack(maxStack : int) : void
		{
			_maxStack = maxStack;
		}
	}
}
