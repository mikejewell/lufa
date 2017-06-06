package com.thecollectedmike.lufa 
{

	/**
	 * @author moj
	 */
	public class Frame 
	{
		private var _pc : uint;
		private var _vars : Array;
		private var _return_reg : uint;
		private var _returns : int;
		public var _a : int;
		public var _b : int;
		public var _c : int;

		public function Frame()
		{
			_pc = 0;
			_vars = [];
		}
		
		public function get pc() : uint
		{
			return _pc;
		}
		
		public function set pc(pc : uint) : void
		{
			_pc = pc;
		}
		
		public function get vars() : Array
		{
			return _vars;
		}
		
		public function set vars(vars : Array) : void
		{
			_vars = vars;
		}
		
		public function get return_reg() : uint
		{
			return _return_reg;
		}
		
		public function set return_reg(return_reg : uint) : void
		{
			_return_reg = return_reg;
		}
		
		public function get returns() : int
		{
			return _returns;
		}
		
		public function set returns(returns : int) : void
		{
			_returns = returns;
		}
		
		public function get a() : int
		{
			return _a;
		}
		
		public function set a(a : int) : void
		{
			_a = a;
		}
		
		public function get b() : int
		{
			return _b;
		}
		
		public function set b(b : int) : void
		{
			_b = b;
		}
		
		public function get c() : int
		{
			return _c;
		}
		
		public function set c(c : int) : void
		{
			_c = c;
		}
	}
}
