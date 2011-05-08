package net.isobang.entities.mapevents 
{
	import net.isobang.*;
	import net.isobang.utils.ParseUtilities;
	/**
	 * Enables a trigger
	 * @author Matt McFarland
	 */
	public class ActivateTrigger extends MapEvent
	{
		/**
		 * Name of triggers to activate
		 */
		public var triggerNames:Vector.<String>;
		
		/**
		 * Adds Specific Tiled Map Event to Map Event Vector
		 * @param	link	XML link from Tiled file.
		 */		
		public function ActivateTrigger(link:XML) 
		{
			super(link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "name") triggerNames = ParseUtilities.stringToVector(property.@value);
				if (property.@name == "next") nextEvents = ParseUtilities.stringToVector(property.@value);
			}
			if (!triggerNames) throw new Error("activateTrigger Event("+name+") missing trigger name.");
		}
		/**
		 * Activate the triggers in triggernames.
		 */
		override public function action():void
		{
			for each (var ts:String in triggerNames) {
				var t:MapTrigger = map.getTrigger(ts);
				t.state = "On";
			}
		}
		
		
		
	}

}