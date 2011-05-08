package net.isobang.entities.maptriggers 
{
	import net.flashpunk.Entity;
	import net.isobang.MapEntity;
	import net.isobang.utils.ParseUtilities;
	import net.isobang.*;
	/**
	 * A trigger that activates when an entity of the declared type touches it.
	 * @author Matt McFarland
	 */
	public class MapCollide extends MapTrigger
	{
		/**
		 * Entity types to test for collision
		 */
		public var entityTypes:Vector.<String>;
		
		/**
		 * Entity names to test for collision
		 */
		public var entityNames:Vector.<String>;
		
		public var target:MapEntity;
		/**
		 * Adds Specific Tiled Map Trigger to Map Trigger Vector
		 * @param	link	XML link from Tiled file.
		 */		
		public function MapCollide(link:XML) 
		{
			super(link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "event") mapEvents = ParseUtilities.stringToVector(property.@value);
				if (property.@name == "state") state = (property.@value);
				if (property.@name == "name") entityNames = ParseUtilities.stringToVector(property.@value);
				if (property.@name == "type") entityTypes = ParseUtilities.stringToVector(property.@value);
				if (property.@name == "cycles") cycles = int(property.@value);
			}
			if (!mapEvents) throw new Error("Collide Trigger(" + name + ") missing event name");
			if (!entityNames && !entityTypes) throw new Error("Collide Trigger(" + name + ") missing entity name or entity type");			
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
			//Test Against entity names.
			for each (var en:String in entityNames) {
				var e:MapEntity = world.getInstance(en) as MapEntity;
				if (e.collideWith(this, x, y)) {
					trace ("collision!");
					target = e;
					executeEvents();
				}
			}
			//Test Against entity types.
			for each (var et:String in entityTypes) {
				var te:MapEntity = collide(et, x, y) as MapEntity;
				if (te) {
					if (te.type == et) {
						trace ("collision!");
						target = te;
						executeEvents();
					}
				}
			}
		}
		
		override public function executeEvents():void
		{
			cycles --;
			for each (var es:String in mapEvents) {
				var e:MapEvent = map.getEvent(es);
				e.targetEntity = target;
				e.execute();
			}
			
		}
		
	}

}