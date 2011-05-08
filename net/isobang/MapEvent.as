package net.isobang 
{
	import net.isobang.MapEntity
	/**
	 * Map Event Master Template
	 * @author Matt McFarland
	 */
	
	public class MapEvent extends MapEntity
	{
		/**
		 * A target as declared by some triggers (colliding triggers);
		 */
		public var targetEntity:MapEntity;
		/**
		 * Trigger an event once this event is complete. (domino effect)
		 */
		public var nextEvents:Vector.<String>;
		
		public var color:uint;
		
		/**
		 * All Map events have name, type,x,y,width,height fields.
		 * @param	link	the XML link to populate master fields.
		 */
		public function MapEvent(link:XML) 
		{
			mapHeight = link.@height;
			mapName = link.@name;
			mapType = link.@type;
			mapX = link.@x;
			mapY = link.@y;
			mapWidth = link.@width;
			tileGid = link.@gid;		
			active = false;
		}
		/**
		 * Fired when an event executes.
		 */
		public function execute():void
		{
			trace (map);
			action();
			doNext();
		}
		/**
		 * Override this: specific action taken by event execution.
		 */
		public function action():void
		{
			
		}
		/**
		 * Fired at end of execution, run next events.
		 */
		public function doNext():void
		{
			for each (var es:String in nextEvents) {
				var n:MapEvent = map.getEvent(es);
				n.execute();
				}
		}
		
	}

}