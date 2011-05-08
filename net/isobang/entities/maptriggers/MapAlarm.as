package net.isobang.entities.maptriggers 
{
	import net.isobang.utils.ParseUtilities;
	import net.flashpunk.FP;
	import net.isobang.*;
	/**
	 * A countdown timer that activates an event when it reaches 0	
	 * @author Matt McFarland
	 */
	public class MapAlarm extends MapTrigger
	{
		/**
		 * 	Duration of countdown until event is activated in seconds.
		 */
		private var duration:Number;
		/**
		 * Timer used
		 */
		private var timer:Number;
		/**
		 * Adds Specific Tiled Map Trigger to Map Trigger Vector
		 * @param	link	XML link from Tiled file.
		 */		
		public function MapAlarm(link:XML) 
		{
			super(link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "event") mapEvents = ParseUtilities.stringToVector(property.@value);
				if (property.@name == "duration") {
					duration = Number(property.@value);
					timer = duration;
				}
				if (property.@name == "state") state = (property.@value);
				if (property.@name == "cycles") cycles = int(property.@value);
			}
			if (!mapEvents) throw new Error("Alarm Trigger(" + name + ") missing event name");
			if (!duration) throw new Error("Alarm Trigger(" + name + ") missing duration");
			if (!state) state = "On";
			if (!cycles) cycles = 1;
			if (cycles < 0) cycles = int.MAX_VALUE;
			
		}
		
		override public function update():void
		{
			if (state == "Off") {
				return;
			}
			if (cycles <= 0) {
				state = "Off";
				return;
			}
			timer -= FP.elapsed;
			if (timer <= 0) {
				timer += duration;
				executeEvents();
			}
		}
		
	}

}