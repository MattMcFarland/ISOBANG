package net.isobang.entities.mapevents 
{
	import net.isobang.utils.ParseUtilities;
	import net.isobang.*;
	/**
	 * Disables a trigger by its unique identifier.(name)
	 * @author Matt McFarland
	 */
	public class DisableTrigger extends MapEvent
	{
		/**
		 * Name of triggers to disable
		 */
		public var triggerNames:Vector.<String>;
		
		/**
		 * Adds Specific Tiled Map Event to Map Event Vector
		 * @param	link	XML link from Tiled file.
		 */		
		public function DisableTrigger(link:XML) 
		{
			super(link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "name") triggerNames = ParseUtilities.stringToVector(property.@value);
				if (property.@name == "next") nextEvents = ParseUtilities.stringToVector(property.@value);
			}
			if (!triggerNames) throw new Error("disableTrigger Event ("+name+") missing trigger name");
			
		}
		/**
		 * Disable triggers in triggerNames.
		 */
		override public function action():void
		{
			for each (var ts:String in triggerNames) {
				var t:MapTrigger = map.getTrigger(ts);
				t.state = "Off";
			}
		}
		
		
	}

}