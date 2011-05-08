package net.isobang.entities.maptriggers 
{
	import net.isobang.MapVar;
	import net.isobang.utils.ParseUtilities;
	import net.isobang.*;
	/**
	 * A conditional trigger.
	 * @author Matt McFarland
	 */
	public class IfThen extends MapTrigger
	{
		/**
		 * List of triggers to execute if condition returns true
		 */
		public var thenEvents:Vector.<String>;
		/**
		 * List of triggers to execute if condition returns false
		 */
		public var elseEvents:Vector.<String>;
		/**
		 * 	name of variable to test, dot operator required.
		 */
		public var var1:String;
		/**
		 * name of variable or value to test against.
		 */
		public var var2:String;
		/**
		 * operator (use ==, !=, <=, >=, < or, >)
		 */
		public var op:String;
		
		private var mapVar1:MapVar;
		private var mapVar2:MapVar;
		
		/**
		 * Adds Specific Tiled Map Trigger to Map Trigger Vector
		 * @param	link	XML link from Tiled file.
		 */		
		public function IfThen(link:XML) 
		{
			super(link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "var1") { 
					var1 = (property.@value);
				}
				if (property.@name == "op") op = (property.@value);
				if (property.@name == "var2") {
					var2 = (property.@value);
				}
				if (property.@name == "then") thenEvents = ParseUtilities.stringToVector(property.@value)
				if (property.@name == "else") elseEvents = ParseUtilities.stringToVector(property.@value)
				if (property.@name == "state") state = (property.@value);
				if (property.@name == "cycles") cycles = int(property.@value);
			}
			if (!var1) throw new Error ("IfThen Trigger("+name+") missing var1 name or value");
			if (!op) throw new Error ("IfThen Trigger("+name+") missing or illegal operator");
			if (!var2) throw new Error ("IfThen Trigger("+name+") missing var1 name or value");
			if (!thenEvents) throw new Error("IfThen Trigger(" + name + ") missing then event name");
			if (!state) state = "On";
			if (!cycles) cycles = 1;
			if (cycles < 0) cycles = int.MAX_VALUE;
		}
		
		override public function init():void
		{
			mapVar1 = map.getVar(var1);
			mapVar2 = map.getVar(var2);	
			super.init();
		}
		
		/**
		 * operator (use ==, !=, <=, >=, < or, >)
		 */
		override public function update():void
		{
			if (state == "Off") {
				return;
			}
			if (!mapVar1) return;
			if (!mapVar2) return;
			if (cycles <= 0) {
				state = "Off";
				return;
			}
			
			if (op == "==") equals();
			if (op == "!-") notEquals();
			if (op == "<=") lessThanEquals();
			if (op == ">=") greaterThanEquals();
			if (op == "<") less();
			if (op == ">") greater();
			
		}
		
		public function equals():void
		{
			if (mapVar1 == mapVar2) {
				thenTrue();
			} else {
				elseTrue();
			}
		}
		public function notEquals():void
		{
			if (mapVar1 != mapVar2) {
				thenTrue();
			} else {
				elseTrue();
			}
		}
		public function lessThanEquals():void
		{
			if (mapVar1 <= mapVar2) {
				thenTrue();
			} else {
				elseTrue();
			}
		}
		public function greaterThanEquals():void
		{
			if (mapVar1 >= mapVar2) {
				thenTrue();
			} else {
				elseTrue();
			}
			
		}
		public function less():void
		{
			if (mapVar1 < mapVar2) {
				thenTrue();
			} else {
				elseTrue();
			}
			
		}
		public function greater():void
		{
			if (mapVar1 > mapVar2) {
				thenTrue();
			} else {
				elseTrue();
			}
			
		}
		
		public function thenTrue():void
		{
			cycles --;
			for each (var es:String in thenEvents) {
				var e:MapEvent = map.getEvent(es);
				e.execute();
			}
		}
		
		public function elseTrue():void
		{
			cycles --;
			for each (var es:String in elseEvents) {
				var e:MapEvent = map.getEvent(es);
				e.execute();
			}
		}
	}

}