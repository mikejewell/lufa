package  
{
	import com.thecollectedmike.lufa.Interpreter;
	import com.thecollectedmike.lufa.LuaScript;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;	

	/**
	 * @author moj
	 */
	public class LufaTest extends Sprite
	{
		public function LufaTest()
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(new URLRequest("../test/func2.out"));
			
			loader.addEventListener(Event.COMPLETE, this.handleLoaded);
		}
		
		private function handleLoaded(event : Event) : void
		{
			trace("Loaded "+((event.target as URLLoader).data as ByteArray).length);
			
			var arr:ByteArray = (event.target as URLLoader).data as ByteArray;
			var luaScript:LuaScript = new LuaScript(arr);
			
			var interpreter : Interpreter = new Interpreter();
			interpreter.run(luaScript);
			
			
			/*for(var i:uint=0; i<arr.length; i++)
			{
				var byte:int = arr.readByte();
				trace(byte.toString(16));
			}*/
		}
	}
}
