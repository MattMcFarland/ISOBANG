package net.isobang.entities.mapevents 
{
	import net.isobang.MapEntity;
	import net.isobang.utils.ParseUtilities;
	import net.isobang.Config;
	import net.isobang.*;
	/**
	 * Spawns a Map Entity
	 * @author Matt McFarland
	 */
	public class SpawnEntity extends MapEvent
	{
		/**
		 * Single Entity type to spawn
		 */
		public var spawnType:String;
		
		/**
		 * blank by default(uses this location), if not use the name of a waypoint trigger.
		 */
		public var location:String;
		
		/**
		 * Adds Specific Tiled Map Event to Map Event Vector
		 * @param	link	XML link from Tiled file.
		 */		
		public function SpawnEntity(link:XML) 
		{
			super(link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "type") spawnType = (property.@value);
				if (property.@name == "location") location = (property.@value);
				if (property.@name == "next") nextEvents = ParseUtilities.stringToVector(property.@value);
			}
			if (!spawnType) throw new Error("Spawn Event("+name+") must have type of entity!");
			
		}
		
		/**
		 * Spawns an entity as configured in the Config.as file
		 */
		override public function action():void
		{
			var e:MapEntity = Config.getEntity(spawnType) as MapEntity;
			if (!e) throw new Error("Spawn Event(" + name + ") cannot find entity type,'" + spawnType + "' in Config.as file!");
			
			if (!location) { 
				e.x = x, e.y = y;
			} else {
				var loc:MapEntity = world.getInstance(location);
				e.x = loc.x, e.y = loc.y;
			}
			e.type = spawnType;
			e.name = type+"_"+String(world.typeCount(e.type));
			world.add(e);
			e.spawn();
		}
		
		
	}

}