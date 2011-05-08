package net.isobang.entities.mapevents 
{
	import net.isobang.MapVar;
	import net.isobang.utils.ParseUtilities;
	import net.isobang.*;
	/**
	 * Modifies an entity or map variable. Variable must be declared to use.
	 * @author Matt McFarland
	 */
	public class ModifyVar extends MapEvent
	{
		/**
		 * Unique name of variable to change. Variable must be declared through TILED
		 */
		public var targetVar:String;
		
		/**
		 * New value to change variable to.
		 */
		public var newValue:Object;
		
		
		/**
		 * Adds Specific Tiled Map Event to Map Event Vector
		 * @param	link	XML link from Tiled file.
		 */		
		public function ModifyVar(link:XML) 
		{
			super (link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "var") {
					targetVar = property.@value;
				}
				if (property.@name == "value") {
					newValue = property.@value;
				}
				if (property.@name == "next") nextEvents = ParseUtilities.stringToVector(property.@value);
			}
			if (!targetVar) throw new Error ("modifyVar Event("+name+") property var missing, remember property names are case-sensitive!");
			if (!newValue) throw new Error ("modifyVar Event("+name+") var value missing.");
		}
		/**
		 * Sets a new value to the mapvar.
		 */
		override public function action():void
		{
			var mapVar:MapVar = map.getVar(targetVar);
			mapVar.value = newValue;
		}
		
	}

}