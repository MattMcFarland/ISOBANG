package net.isobang 
{
	import flash.utils.ByteArray;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import net.isobang.entities.*;
	/**
	 * ...
	 * @author Matt McFarland
	 */
	public class MapWorld extends World
	{
		/**
		 * Container for map data..
		 */
		private var _map:Map;
		public var mapTime:Number;
		
		/**
		 * Load an embedded TMX file and port it into a new Map Class
		 */
		public function loadMap(mapClass:Class):void {
			
			//Load the embedded file and store it in the TMX variable.
			var rawData:ByteArray = new mapClass;
			var dataString:String = rawData.readUTFBytes(rawData.length);
			Parser.TMX = new XML(dataString);
			_map = Parser.setMap();
			_map.tileSetData = Parser.addTileSets();
			_map.tileLayerData = Parser.addTileLayers();
			Parser.addObjects(_map);
		}
		//Access Read-Only map 
		public function get map():Map { return _map; }
		
		/**
		 * Initialized loaded map and brings it into life, call in world begin function.
		 */
		public function init():void
		{
			Parser.TMX = new XML();
			Architecht.create(_map);
			//TileLayerArchitect.create(_map);	
			//ObjectLayerArchitect.create(_map);
		}
		
		override public function update():void
		{
			mapTime += FP.elapsed;
			super.update();
		}

	}

}