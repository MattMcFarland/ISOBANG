package net.isobang.entities.mapevents 
{
	import net.flashpunk.Entity;
	import net.isobang.MapEntity;
	import net.isobang.utils.ParseUtilities
	import net.isobang.*;
	/**
	 * Removes a MapEntity Object
	 * @author Matt McFarland
	 */
	public class RemoveEntity extends MapEvent
	{
		/**
		 * List of entity types you wish to remove.  use (collide_<triggername>) if it is an entity colliding with a trigger.
		 */
		public var targetTypes:Vector.<String>;
		/**
		 * List of entity names you wish to remove.
		 */
		public var targetNames:Vector.<String>;
		/**
		 * Normally false, if set to true, leave type and name blank.
		 */
		public var collider:Boolean= false;
		/**
		 * Adds Specific Tiled Map Event to Map Event Vector
		 * @param	link	XML link from Tiled file.
		 */		
		public function RemoveEntity(link:XML) 
		{
			super(link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "type") targetTypes = ParseUtilities.stringToVector(property.@value);
				if (property.@name == "name") targetNames = ParseUtilities.stringToVector(property.@value);
				if (property.@name == "collider") collider = new Boolean(property.@value);
				if (property.@name == "next") nextEvents = ParseUtilities.stringToVector(property.@value);
			}
			if (!targetNames && !targetTypes && !collider) throw new Error("Remove Event("+name+") must have a target name, target type, or collider must be true");
			
			
		}
		
		
		/**
		 * Removes the targets by type and name from the world.
		 */
		override public function action():void
		{
			//If the trigger was not a collision trigger, just remove types or names.
			if (!targetEntity)
			{
				//remove all targets by type
				if (targetTypes) 
				{
					for each (var es:String in targetTypes) {
						var types:Array = [];
						world.getType(es, types);
						for each (var e:MapEntity in types) {
							world.remove(e);
						}
					}
				}
				//remove all targets by name
				if (targetNames) 
				{
					for each (var eNs:String in targetNames) {
						var eN:MapEntity = world.getInstance(es);
						world.remove(eN);
					}
				}
			}
			
			//If the trigger was a collision trigger, remove entity.
			if (targetEntity) {
				//remove colliding entity.
				world.remove(targetEntity);
				targetEntity = null;
			}
			
		}
		
		
		
	}

}