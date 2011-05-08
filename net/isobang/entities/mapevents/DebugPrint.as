package net.isobang.entities.mapevents 
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.Alarm;
	import net.flashpunk.tweens.misc.VarTween;
	import net.isobang.utils.ParseUtilities;
	import net.flashpunk.FP;
	import net.isobang.*;
	/**
	 * Displays a debug message at the bottom of the screen.
	 * @author Matt McFarland
	 */
	public class DebugPrint extends MapEvent
	{
		/**
		 * The message you wish to display.	
		 */
		public var text:String;
		/**
		 * The length of time you wish to show the message, in seconds.
		 */
		public var duration:Number;
		/**
		 * The message entity.
		 */
		public var msg:Entity;
		/**
		 * Adds Specific Tiled Map Event to Map Event Vector
		 * @param	link	XML link from Tiled file.
		 */		
		public function DebugPrint(link:XML) 
		{
			super(link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "duration") duration = Number(property.@value);
				if (property.@name == "text") text = (property.@value);
				if (property.@name == "next") nextEvents = ParseUtilities.stringToVector(property.@value);
			}
			if (!duration) throw new Error ("print event (" + name + ") missing duration value");
			if (!text) throw new Error ("print event (" + name + ") missing text value");
			
		}
		
		override public function action():void
		{
			var t:Text = new Text(text);
			t.size = 24;
			t.wordWrap = true;
			t.width = FP.width;
			t.y = t.height;
			var s:Text = new Text(text)
			s.size = 24;
			s.wordWrap = true;
			s.width = FP.width;
			s.y = t.height;
			s.x = t.x-1, s.y = t.y+1;
			s.color = 0x000000;
			msg = new Entity(0, 0, new Graphiclist(s,t));
			t.scrollX = 0;
			t.scrollY = 0;
			s.scrollX = 0;
			s.scrollY = 0;
			world.add(msg);
			var removeTimer:Alarm = new Alarm(duration, killText);
			world.addTween(removeTimer, true);
			
		}
		public function killText():void
		{
			world.remove(msg);
		}
		
	}

}