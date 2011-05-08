package net.isobang 
{

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.text.engine.Kerning;
	import flash.utils.ByteArray;
	import net.flashpunk.graphics.Spritemap;
	import net.isobang.entities.mapevents.*;
	import net.isobang.entities.maptriggers.*;
	import XML;
	import flash.display.Bitmap;
	import net.flashpunk.graphics.Image;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.isobang.db.cache.*
	import net.isobang.entities.*;
	
	/**
	 * ...
	 * @author Matt McFarland
	 */
	
	internal class Parser 
	{
		/**
		 * A map's TMX file, only used during initilization.
		 */
		public static var TMX:XML;
		
		/**
		 * Sets the mapworld's map class.
		 * @return	new map.
		 */
		public static function setMap():Map
		{
			var map:Map = new Map;
			//Get major attributes.
			map._width = TMX.@width;
			map._height = TMX.@height;
			map._tileWidth = TMX.@tilewidth;
			map._tileHeight = TMX.@tileheight;
			if (TMX.properties) map = getProperties(map) 
			if (!map.theme) map._theme = "default";
			//Look for variables and set accordingly.
			return map;
		}
		
		
		/**
		 * Grab all properties from map
		 * @param	arg		current map
		 * @return	current map with properties.
		 */
		private static function getProperties(arg:Map):Map
		{
			var map:Map = arg;
			for each (var property:XML in TMX.properties.property)
			{
				var name:String = property.@name;
				var value:String = property.@value;
				if (name == "theme") map._theme = value;
				if (name.substr(0, 3) == "var") addMapVar(map, value);
			}
			return map;
		}
		
		/**
		 * Adds a MAP variable to the map
		 * @param	arg		Current map
		 * @param	addVar	Variable properties to add
		 * @return	current map with variables added.
		 */
		private static function addMapVar(arg:Map, addVar:String):Map
		{
			var map:Map = arg;
			var readVar:Array = addVar.split(",");
			var newVar:MapVar = new MapVar();
			newVar.name = "map." + readVar[0];
			newVar.init(readVar);
			map.addVar(newVar);
			return map;
		}
		
		
		/**
		 * Adds the tilesets to the map world and pushes them into a Vector.
		 * @return	vector of tilesets used for this map.
		 */
		public static function addTileSets():Vector.<DataTileSet>
		{
			var tilesets:Vector.<DataTileSet> = new Vector.<DataTileSet>();
			for each (var tset:XML in TMX.tileset)
			{
				var newset:DataTileSet = new DataTileSet();
				newset.firstGid = tset.@firstgid;
				newset.name = tset.@name;
				newset.tileWidth = tset.@tilewidth;
				newset.tileHeight = tset.@tileheight;
				tilesets.push(newset);
				newset.init();
			}
			return tilesets;
		}
		
		
		/**
		 * Defines map layers.
		 * @return	vector of layers.
		 */
		public static function addTileLayers():Vector.<DataTileLayer>
		{
			var layers:Vector.<DataTileLayer> = new Vector.<DataTileLayer>()
			for each (var l:XML in TMX.layer)
			{
				var newLayer:DataTileLayer = new DataTileLayer();
				var data:String = l.data;
				if (l.properties) newLayer = getLayerProperties(newLayer,l) 
				if (!newLayer.render) newLayer.render = "default";
				if (!newLayer.zOrder) newLayer.zOrder = 11;
				var newArr:Array = data.split(",");
				newLayer.tiles = newArr;
				layers.push(newLayer);
			}
			return layers;
		}
		
		
		/**
		 * Grab all properties from layer.
		 * @param	arg		current layer
		 * @return	current layer with properties.
		 */
		private static function getLayerProperties(arg:DataTileLayer,l:XML):DataTileLayer
		{
			
			for each (var property:XML in l.properties.property)
			{
				var name:String = property.@name;
				var value:String = property.@value;
				if (name == "render") arg.render = value;
				if (name == "zOrder") arg.zOrder = new int(value);
				if (name == "targetName") arg.targetName = new Array(value.split(","));
				if (name == "targetType") arg.targetType = new Array(value.split(","));
				if (name == "moveMask") arg.moveMask = new Number(value);
			}
			return arg;
		}
		
		
		/**
		 * Grabs the object data from the TMX file
		 * @param	map		current map
		 * @return	current map with object data added.
		 */
		public static function addObjects(map:Map):Map
		{
			for each (var objGrp:XML in TMX.objectgroup)
			{
				if (objGrp.@name != "Entities" &&
					objGrp.@name != "Triggers" &&						
					objGrp.@name != "Events"
				) getDoodads(map, objGrp);
				//if (objGrp.@name == "Entities") getEntities(map, objGrp);
				if (objGrp.@name == "Triggers") getTriggers(map, objGrp);
				if (objGrp.@name == "Events") getEvents(map, objGrp);
			}
			return map;
		}
		
		/**
		 * Grabs the map doodads and pushes them into the doodad vector
		 * @param	map		Current map
		 * @param	objGrp	objectgruop xml
		 * @return	map with doodads added
		 */
		private static function getDoodads(map:Map, objGrp:XML):Map
		{
			trace ("Parser.as - getDoodads");
			var counter:int = 0;
			for each (var obj:XML in objGrp.object)
			{
				counter ++;
				var o:MapDoodad = new MapDoodad();
				o.name = obj.@name;
				o.type = obj.@type;
				o.mapX = obj.@x;
				o.mapY = obj.@y;
				o.mapWidth = obj.@width;
				o.mapHeight = obj.@height;
				o.tileGid = obj.@gid;
				o._map = map;
				map.addDoodad(o);
				trace (counter, o.name, o.type, o.mapX, o.mapY);
			}
			trace (counter, "Doodads Added");
			return map;
		}
		
		/**
		 * Grabs the map events and pushes them into the map event vector
		 */
		private static function getEvents(map:Map, objGrp:XML):Map
		{
			trace ("Parser.as - getEvents");
			var counter:int = 0;
			for each (var o:XML in objGrp.object)
			{
				if (!o.@name) throw new Error("Event Object missing Name");
				if (o.@type != "activateTrigger" &&
					o.@type != "disableTrigger" &&
					o.@type != "modifyVar" &&
					o.@type != "moveCamera" &&
					o.@type != "print" &&
					o.@type != "remove" &&
					o.@type != "spawn" &&
					o.@type != "teleport" &&
					o) throw new Error ("Illegal Event: (Name:" + o.@name+"),(Type:"+o.@type + ") remember all event types are case sensetive!"+o);
				var e:MapEvent;
				if (o.@type == "activateTrigger") {
					e = new ActivateTrigger(o);
					map.addEvent(e);
					counter ++;
					trace (counter, e.name, e.type, e.mapX, e.mapY);
				}
				if (o.@type == "disableTrigger") {
					e = new DisableTrigger(o);
					map.addEvent(e);
					counter ++;
					trace (counter, e.name, e.type, e.mapX, e.mapY);
				}
				if (o.@type == "moveCamera") {
					e = new MoveCamera(o);
					map.addEvent(e);
					counter ++;
					trace (counter, e.name, e.type, e.mapX, e.mapY);
				}
				if (o.@type == "modifyVar") {
					e = new ModifyVar(o);
					map.addEvent(e);
					counter ++;
					trace (counter, e.name, e.type, e.mapX, e.mapY);
				}				
				if (o.@type == "print") {
					e = new DebugPrint(o);
					map.addEvent(e);
					counter ++;
					trace (counter, e.name, e.type, e.mapX, e.mapY);
				}
				if (o.@type == "remove") {
					e = new RemoveEntity(o);
					map.addEvent(e);
					counter ++;
					trace (counter, e.name, e.type, e.mapX, e.mapY);
				}
				if (o.@type == "spawn") {
					e = new SpawnEntity(o);
					map.addEvent(e);
					counter ++;
					trace (counter, e.name, e.type, e.mapX, e.mapY);
				}
				if (o.@type == "teleport") {
					e = new Teleport(o);
					map.addEvent(e);
					counter ++;
					trace (counter, e.name, e.type, e.mapX, e.mapY);
				}
				e._map = map;
				if (!e) trace ("illegal object");
			}
			trace (objGrp.@color);
			if (objGrp.@color) {
				var col:String = objGrp.@color;
				col.replace("#", "0x");
				e.color = new uint(col);
			}
			trace (counter, "Events Added");
			return map;
		}
		private static function getTriggers(map:Map, objGrp:XML):Map
		{
			trace ("Parser.as - getTriggers");
			var counter:int = 0;
			for each (var o:XML in objGrp.object)
			{
				if (!o.@name) throw new Error("Trigger Object missing Name");
				if (o.@type != "alarm" &&
					o.@type != "collide" &&
					o.@type != "ifThen" &&
					o) throw new Error ("Illegal Trigger Type: (Name:" + o.@name+"),(Unknown Type:"+o.@type + ") remember all trigger types are case sensetive!"+o);
				var t:MapTrigger
				if (o.@type == "alarm") {
					t = new MapAlarm(o);
					map.addTrigger(t);
					counter ++;
					trace (counter, t.name, t.type, t.mapX, t.mapY);
				}
				if (o.@type == "collide") {
					t = new MapCollide(o);
					map.addTrigger(t);
					counter ++;
					trace (counter, t.name, t.type, t.mapX, t.mapY);
				}
				if (o.@type == "ifThen") {
					t = new IfThen(o);
					map.addTrigger(t);
					counter ++;
					trace (counter, t.name, t.type, t.mapX, t.mapY);
				}
				t._map = map;
				if (objGrp.@color) {
					var col:String = objGrp.@color;
					var ncol:String = col.replace("#", "0x");
					trace (ncol);
					t.color = uint(ncol);
					trace (t.color);
				}
			}
			return map;
		}
				
	}
}