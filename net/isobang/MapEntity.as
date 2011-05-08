package net.isobang 
{
	import flash.geom.Point;
	import net.isobang.Map;
	import net.isobang.utils.*;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author Matt McFarland
	 */
	public class MapEntity extends Entity
	{
		public var mapX:Number;
		public var mapY:Number;
		public var mapWidth:Number;
		public var mapHeight:Number;
		public var tileGid:int;
		/**
		 * Center of a MapEntity.
		 */
		public var center:Point;
		internal var _map:Map
		
		
		public function MapEntity() 
		{
			
		}
		
		/**
		 * Override this, this is what happens when your entity is spawned from SpawnEntity Event.  Use for graphic settings, etc.
		 */
		public function spawn():void
		{
			
		}
		
		public function get map():Map
		{ return _map; }
		/**
		 * Shared property, same as FP Entity type.
		 */
		public function get mapType():String { return type; }
		public function set mapType(arg:String):void
		{
			type = arg;
		}
		/**
		 * Shared property, same as FP Entity name.
		 */
		public function get mapName():String { return name; }
		public function set mapName(arg:String):void
		{
			name = arg;
		}
	}

}