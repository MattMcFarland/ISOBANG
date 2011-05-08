package net.isobang 
{
	import net.isobang.MapEntity;
	/**
	 * Master Map Trigger Template
	 * @author Matt McFarland
	 */
	public class MapTrigger extends MapEntity
	{
		/**
		 * List of Events to execute when trigger activates.
		 */
		public var mapEvents:Vector.<String>;
		/**
		 * Initial state of trigger.  use "On" or "Off". default is On so it starts immediately.
		 */ 
		public var state:String;
		/**
		 * Trigger will fire event for num cycles, then state will set to Off. default is 1
		 */
		public var cycles:int;
		
		public var color:uint;
		
		/**
		 * All Map triggers have name, type,x,y,width,height,state, and mapEvent fields.
		 * @param	link	the XML link to populate master fields.
		 */
		public function MapTrigger(link:XML) 
		{
			if (link.@color) {
				var col:String = link.@color;
				col.replace("#", "0x");
				trace (col);
				color = new uint(col);
			}
			name = link.@name;
			type = link.@type;
			mapType = link.@type;
			mapX = link.@x;
			mapY = link.@y;
			mapWidth = link.@width;
			mapHeight = link.@height;
			tileGid = link.@gid;
			active = false;
		}
		
		public function executeEvents():void
		{
			cycles --;
			for each (var es:String in mapEvents) {
				var e:MapEvent = map.getEvent(es);
				e.execute();
			}
			
		}
		
		/**
		 * Called when architect adds to world.
		 */
		public function init():void
		{
			active = true;
		}
		
	}

}