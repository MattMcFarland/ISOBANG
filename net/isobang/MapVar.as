package net.isobang 
{
	/**
	 * ...
	 * @author Matt McFarland
	 */
	public class MapVar 
	{
		public var name:String;
		private var _value:Object;
		
		public function MapVar() 
		{
			
		}
		
		public function init(arg:Array):void
		{
			if (arg[1] == "Integer") _value = new int(arg[2]);
			if (arg[1] == "Boolean") _value = new Boolean(arg[2]);
			if (arg[1] == "Number") _value = new Number(arg[2]);
			if (arg[1] == "String") _value = new String(arg[2]);			
		}
		/**
		 * The value property, which must be initialied before set.
		 */
		public function get value():Object { return _value; }
		public function set value(arg:Object):void
		{
			if (_value is int) _value = new int(arg);
			if (_value is Boolean) _value = new Boolean(arg);
			if (_value is Number) _value = new Number(arg);
			if (_value is String) _value = new String(arg);
		}
		
	}

}