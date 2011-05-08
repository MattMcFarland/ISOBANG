package net.isobang.entities.mapevents 
{
	import net.isobang.MapEntity;
	import net.isobang.utils.ParseUtilities;
	import net.isobang.*;
	/**
	 * Teleports an entity.  
	 * @author Matt McFarland
	 */
	public class Teleport extends MapEvent
	{
		/**
		 * the type of the entity you wish to teleport.   If null all types will teleport.
		 */
		public var targetType:String;
		/**
		 * the name of a waypoint the entity will teleport to.
		 */
		public var location:String;
		/**
		 * Adds Specific Tiled Map Event to Map Event Vector
		 * @param	link	XML link from Tiled file.
		 */		
		public function Teleport(link:XML) 
		{
			super(link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "type") targetType = (property.@value);
				if (property.@name == "location") location = (property.@value);
				if (property.@name == "next") nextEvents = ParseUtilities.stringToVector(property.@value);
			}
			if (!location) throw new Error("Teleport Event(" + name + ") must have location name");
			
		}
		
		/**
		 *Teleports the target Entity.
		 */
		override public function action():void
		{
			//Teleport by colliding trigger to location entity.
			if (targetEntity) {
				if (targetType) {
					if (type != targetType) return;
				}
				if (location) {
					var loc:MapEntity = world.getInstance(location);
					targetEntity.x = loc.x, targetEntity.y = loc.y;
				}
			}
		}
		
		
	}

}