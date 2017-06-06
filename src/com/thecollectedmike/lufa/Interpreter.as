package com.thecollectedmike.lufa 
{
	import flash.utils.Dictionary;
	import flash.utils.clearInterval;	

	/**
	 * @author moj
	 */
	public class Interpreter 
	{
		private var stack : Array;
		private var funcs : Array;
		private var globals : Dictionary;
		private var stepInterval : uint;

		private var frame : Frame;
		private var func : LuaFunction;

		public function run(func : LuaFunction) : void
		{
			stack = [];
			funcs = [];
			globals = new Dictionary();
			
			globals["coroutine"] = {"wrap" : "foo"};
			globals["io"] = {"write" : this.write};
			globals["print"] = this.write;
			globals["string"] = {"format" : this.format};
			var frame : Frame = new Frame();
			stack.push(frame);
			funcs.push(func);
		
			while(funcs.length != 0)
			{
				step();
			}
		//	this.stepInterval = setInterval(this.step, 1);
		}

		public function step() : void
		{
			/*if(funcs.length == 0)
			{
			log("*** END");
			clearInterval(stepInterval);
			return;
			}*/

			this.frame = (stack[stack.length - 1] as Frame);
			this.func = (funcs[funcs.length - 1] as LuaFunction);
		
			var inst : Instruction = func.instructions[frame.pc];
		
			switch(inst.opcode)
			{
				// Control flow
				case Instruction.FORPREP:
					log("FORPREP init=" + frame.vars[inst.a] + ";limit=" + frame.vars[inst.a + 1] + ";step=" + frame.vars[inst.a + 2] + ";counter=" + frame.vars[inst.a + 3]);
					frame.vars[inst.a] -= frame.vars[inst.a + 2];
					frame.pc += inst.b;
					break;
				case Instruction.FORLOOP:
					log("FORLOOP init=" + frame.vars[inst.a] + ";limit=" + frame.vars[inst.a + 1] + ";step=" + frame.vars[inst.a + 2] + ";counter=" + frame.vars[inst.a + 3]);
					frame.vars[inst.a] += frame.vars[inst.a + 2];
					var step : int = frame.vars[inst.a + 2];
					if((step < 0 && frame.vars[inst.a] >= frame.vars[inst.a + 1]) || (step > 0 && frame.vars[inst.a] <= frame.vars[inst.a + 1]))
					{
						frame.pc += inst.b;
						frame.vars[inst.a + 3] = frame.vars[inst.a];	
					}				
					break;
				case Instruction.RETURN:
					
					/*var returns : Array = [];
					if(inst.b == 0)
					{
						trace("From " + inst.a + " to top of stack");
						returns = frame.vars.slice(inst.a);
					}
					else if(inst.b == 1)
					{
						trace("No return values");
						returns = [];
					}
					else
					{
						trace(inst.b + "-1 returns from " + inst.a);
						returns = frame.vars.slice(inst.a, inst.a + (inst.b - 1));
					}
					*/
					
					log("RETURN\t\t\tRETURN");
					
					if(!stack.length)
					{
						return;
					}
					
					var oldRegs : Array = frame.vars;
					var oldFrame : Frame = stack.pop();
					
					funcs.pop();
					
					var k : uint = inst.a;
					
					var fa : uint = oldFrame.a;
					var fc : uint = oldFrame.c;
					
					var j : uint = (!fc ? this.func.maxStack : fa + fc - 1);
					
					trace(this.func);
					trace("fa: "+fa);
					trace("fc: "+fc);
					trace("max stack: "+this.func.maxStack);
					trace("j: "+j);
					trace("k: "+k);
					
					frame = (stack[stack.length - 1] as Frame);
					for(;fa < j; fa++)
					{
						trace("Return value: "+oldRegs[k]);
						frame.vars[fa] = oldRegs[k];
						k++;
					}
					
					/*if(stack.length != 0)
					{
					frame = (stack[stack.length - 1] as Frame);
						
					// Store the returns
					var luaReturns : uint = (frame.returns == -1 ? returns.length : frame.returns);
					for(var i : uint = 0;i < luaReturns; i++)
					{
					trace("Store "+returns[i]+" in "+(frame.return_reg + i));
					frame.vars[frame.return_reg + i] = returns[i];
					}
					}*/
					return;
					break;
				case Instruction.EQ:
				case Instruction.LT:
				case Instruction.LE:
					var a : Number = (inst.b & 0x100 ? parseInt(func.constants[inst.b - 0x100] + "") : frame.vars[inst.b]);
					var b : Number = (inst.c & 0x100 ? parseInt(func.constants[inst.c - 0x100] + "") : frame.vars[inst.c]);
					var test : Boolean = (inst.a == 1);
					
					if(inst.opcode == Instruction.EQ) 
					{ 
						log("EQ\t\t\tR[" + inst.b + "] " + a + " == [" + inst.c + "]" + b + " == " + test);
						
						if((a == b) == test)
						{
							log("EQ YEP");
							frame.pc++;
						}
					}
					else if(inst.opcode == Instruction.LT)
					{
						log("LT\t\t\tR[" + inst.b + "] " + a + " < [" + inst.c + "]" + b + " == " + test);
						if((a < b) == test)
						{
							log("LT YEP");
							frame.pc++;
						}
					}
					else if(inst.opcode == Instruction.LE)
					{
						log("LE\t\t\t[" + inst.b + "] " + a + " <= [" + inst.c + "]" + b + " == " + test);
						if((a <= b) == test)
						{
							log("LE YEP");
							frame.pc++;
						}
					}
					else
					{
						log("Eeep");
					}
					
				case Instruction.JMP:
					log("JMP " + inst.b);
					
					frame.pc += inst.b;
					break;
				case Instruction.TFORLOOP:
					log("TFORLOOP " + inst.a + " " + inst.c);
					break;
				case Instruction.GETGLOBAL:
					log("GETGLOBAL\t\tR[" + inst.a + "] = G[" + func.constants[inst.b] + "]");
					frame.vars[inst.a] = globals[func.constants[inst.b]];
					break;
				case Instruction.SETGLOBAL:
					log("SETGLOBAL\t\tG[" + func.constants[inst.b] + "] = R[" + inst.a + "]");
					globals[func.constants[inst.b]] = frame.vars[inst.a];
					break;
				case Instruction.MOVE:
					log("MOVE\t\t\tR[" + inst.a + "] = R[" + inst.b + "]");
					frame.vars[inst.a] = frame.vars[inst.b];
					break;
				case Instruction.LOADK:
					log("LOADK\t\t\tR[" + inst.a + "] = " + func.constants[inst.b]);
					frame.vars[inst.a] = func.constants[inst.b];
					break;
				case Instruction.TAILCALL:
					log("TAILCALL " + inst.a);
				case Instruction.CALL:
					var params : Array = [];
					if(inst.b == 0)
					{
						params = frame.vars.slice(inst.a + 1);
					}
					else if(inst.b == 1)
					{
						params = [];
					}
					else
					{
						params = frame.vars.slice(inst.a + 1, inst.a + inst.b);
					}
					
					var numReturns : int;
					var return_reg : uint;
					
					if(inst.c == 0)
					{
						numReturns = -1;
					}
					else
					{
						numReturns = inst.c - 1;
					}
					
					return_reg = inst.a;
					
					if(frame.vars[inst.a] is LuaFunction)
					{
					
						var newFrame : Frame = new Frame();
						newFrame.vars = params;
						
						frame.returns = numReturns;
						frame.return_reg = return_reg;
						
						newFrame.a = inst.a;
						newFrame.b = inst.b;
						newFrame.c = inst.c;
						
						log("CALL\t\t\tR[" + inst.a + "] (" + params.join(",") + ") : " + frame.returns); 
						trace(inst.b);
						trace(inst.c);
						stack.push(newFrame);
						funcs.push(frame.vars[inst.a] as LuaFunction);
					}
					else if(frame.vars[inst.a] is Function)
					{
						log("CALL\t\t\tR[" + inst.a + "] (" + params.join(",") + ") : " + frame.returns); 
						trace(inst.b);
						trace(inst.c);
						var nativeFunc : Function = (frame.vars[inst.a] as Function);
						var nativeReturnValues : Array = nativeFunc(params);
						if(nativeReturnValues == undefined)
						{
							nativeReturnValues = [];
						}
						if(numReturns == -1) 
						{ 
							numReturns = nativeReturnValues.length; 
						}
					
						trace("Returns: " + numReturns);
						if(nativeReturnValues.length > 0)
						{
							for(var i : uint = 0;i < numReturns; i++)
							{
								trace("Val: " + nativeReturnValues[i]);
								frame.vars[frame.return_reg + i] = nativeReturnValues[i];
							}
						}
					}
					frame.pc++;
					return;
					break;
				case Instruction.CLOSURE:
					log("CLOSURE\t\t\tR[" + inst.a + "] = func " + func.functions[inst.b] + "");
					frame.vars[inst.a] = (func.functions[inst.b] as LuaFunction).instantiate();
					break;
				case Instruction.GETTABLE:
					
					var key : Object = (inst.c & 0x100 ? func.constants[inst.c - 0x100] : frame.vars[inst.c]);
					log("GETTABLE\t\tR[" + inst.a + "] = R[" + inst.b + "][" + key + "]");
					frame.vars[inst.a] = frame.vars[inst.b][key];
					break;
				// Maths Operations
				case Instruction.ADD:
				case Instruction.DIV:
				case Instruction.SUB:
				case Instruction.MUL:
				case Instruction.POW:
				case Instruction.MOD:
			
					var a : Number = (inst.b & 0x100 ? parseInt(func.constants[inst.b - 0x100] + "") : frame.vars[inst.b]);
					var b : Number = (inst.c & 0x100 ? parseInt(func.constants[inst.c - 0x100] + "") : frame.vars[inst.c]);
					
					var c : Number = 0;
					
					if(inst.opcode == Instruction.ADD) 
					{ 
						log("ADD\t\t\tR[" + inst.a + "] = " + a + " + " + b);
						c = a + b; 
					}
					if(inst.opcode == Instruction.DIV) 
					{ 
						log("DIV\t\t\tR[" + inst.a + "] = " + a + " / " + b);
						c = a / b; 
					}
					if(inst.opcode == Instruction.SUB) 
					{ 
						log("SUB\t\t\tR[" + inst.a + "] = " + a + " - " + b);
						c = a - b; 
					}
					if(inst.opcode == Instruction.MUL) 
					{ 
						log("MUL\t\t\tR[" + inst.a + "] = " + a + " * " + b);
						c = a * b; 
					}
					if(inst.opcode == Instruction.POW) 
					{ 
						log("POW\t\t\tR[" + inst.a + "] = " + a + " ^ " + b);
						c = Math.pow(a, b); 
					}
					if(inst.opcode == Instruction.MOD) 
					{ 
						log("MOD\t\t\tR[" + inst.a + "] = " + a + " % " + b);
						c = a % b; 
					}
					
					frame.vars[inst.a] = c;
					
					break;
				case Instruction.UNM:
					log("UNM\t\t\tR[" + inst.a + "] = -R[" + inst.b + "]");
					frame.vars[inst.a] = -frame.vars[inst.b];
					break;
				case Instruction.NEWTABLE:
					log("NEWTABLE\t\tR["+inst.a+"] = {} (size="+inst.b+","+inst.c+")");
					frame.vars[inst.a] = {};
					break;
				case Instruction.SETTABLE:
					
					var index : Object = (inst.b & 0x100 ? func.constants[inst.b - 0x100] : frame.vars[inst.b]);
					var value : Object = (inst.c & 0x100 ? func.constants[inst.c - 0x100] : frame.vars[inst.c]);
					
					log("SETTABLE\t\tR[" + inst.a + "][" + index + "]="+value);
					frame.vars[inst.a][index] = value;
					break;
				default:
					log("Unhandled: " + inst.opcode + " " + inst.a + " " + inst.b + " " + inst.c);
			}
				
			frame.pc++;
		}

		public function write(args : Array) : Array
		{
			trace("IO: " + args.join(",").replace("\n", ""));
			return [true];
		}

		public function format(args : Array) : Array
		{
			return [args.join(",")];
		}

		private function log(message : String) : void
		{
			message = message.replace("\n", " ");
			trace("* " + frame.pc + "\t" + message + "\t" + frame.vars.join(","));
		}
	}
}
