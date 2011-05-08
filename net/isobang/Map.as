package net.isobang 
{
	/**
	 * ...
	 * @author Matt McFarland
	 */
	import flash.events.DataEvent;
	import flash.utils.Dictionary;
	import net.isobang.db.cache.*;
	import net.isobang.entities.*
	/**
	 * Object container for map properties and variables.
	 */
	public class Map 
	{
		/**
		 * Width of map in tiles
		 */
		public function get width():Number { return _width; }
		/**
		 * Width of map in pixels
		 */
		public function get pixelWidth():Number	{ return width * tileWidth;	}
		/**
		 * Height of map in tiles
		 */
		public function get height():Number { return _height; }
		/**
		 * Height of map in pixels
		 */
		public function get pixelHeight():Number { return height * tileHeight; }
		/**
		 * Width of each tile for this map.
		 */
		public function get tileWidth():Number { return _tileWidth;}
		/**
		 * Height of each tile for this map.
		 */
		public function get tileHeight():Number { return _tileHeight; }
		/**
		 * A special theme for the map, use to quickly change other tileset sources.
		 */
		public function get theme():String { return _theme; }
		
		
		/**
		 * Adds a new variable to the map.  Only used during map init.
		 * @param	v	Variable to add.
		 */
		internal function addVar(v:MapVar):void
		{
			_varNames[v] = v.name;
			_vars[_vars.length] = v;
		}
		/**
		 * Returns the map variable with the instance name.
		 * @param	name	Instance name of the map variable.
		 * @return	Instance
		 */
		public function getVar(name:String):*
		{
			if (name)
			{
				for (var i:Object in _varNames)
				{
					if (_varNames[i] == name)
					{
						return i;
					}
				}
			}
			return null;
		}
		
		
		/**
		 * Adds doodad to list
		 * @param	d	new MapDoodad
		 */
		internal function addDoodad(d:MapDoodad):void
		{
			_doodadNames[d] = d.name;
			_mapDoodads[_mapDoodads.length] = d;
		}
		/**
		 * Returns a map doodad with the instance name.
		 * @param	name	Instance name of MapDoodad.
		 * @return	Instance
		 */
		public function getDoodad(name:String):*
		{
			if (name)
			{
				for (var i:Object in _doodadNames)
				{
					if (_doodadNames[i] == name)
					{
						return i;
					}
				}
			}
			return null;
		}
				
		
		/**
		 * Adds event to list
		 * @param	e	new MapEvent.
		 */
		internal function addEvent(e:MapEvent):void
		{
			_eventNames[e] = e.name;
			_mapEvents[_mapEvents.length] = e;
		}	
		/**
		 * Returns a MapEvent with the instance name.
		 * @param	name	Instance name of MapEvent.
		 * @return	Instance
		 */
		public function getEvent(name:String):*
		{
			if (name)
			{
				for (var i:Object in _eventNames)
				{
					if (_eventNames[i] == name)
					{
						return i;
					}
				}
			}
			return null;
		}

		
		/**
		 * Adds trigger to list
		 * @param	t	new MapTrigger
		 */
		internal function addTrigger(t:MapTrigger):void
		{
			_triggerNames[t] = t.name;
			_mapTriggers[_mapTriggers.length] = t;
		}
		/**
		 * Returns a MapTrigger with the instance name.
		 * @param	name	Instance name of MapTrigger.
		 * @return	Instance
		 */
		public function getTrigger(name:String):*
		{
			if (name)
			{
				for (var i:Object in _triggerNames)
				{
					if (_triggerNames[i] == name)
					{
						return i;
					}
				}
			}
			return null;
		}
		
	
		

		
		//Map Properties 
		/** @private */ private var _vars:Vector.<MapVar> = new Vector.<MapVar>();
		/** @private */ private var _varNames:Dictionary = new Dictionary;
		/** @private */ internal var _width:Number;
		/** @private */ internal var _height:Number;
		/** @private */ internal var _tileWidth:Number;
		/** @private */ internal var _tileHeight:Number;
		/** @private */ internal var _theme:String;		

		//Map Layers
		/** @private */ internal var mapTiles:Vector.<MapTile> = new Vector.<MapTile>();
		/** @private */ internal var mapTileLayers:Vector.<MapTileLayer> = new Vector.<MapTileLayer>();
		/** @private */ internal var tileSetData:Vector.<DataTileSet>;
		/** @private */ internal var tileLayerData:Vector.<DataTileLayer>;
		
		//Map Objects
		/** @private */ internal var _mapDoodads:Vector.<MapDoodad> = new Vector.<MapDoodad>();
		/** @private */ private var _doodadNames:Dictionary = new Dictionary;
		/** @private */ internal var _mapEntities:Vector.<MapEntity> = new Vector.<MapEntity>();
		/** @private */ private var _entityNames:Dictionary = new Dictionary;
		/** @private */ internal var _mapEvents:Vector.<MapEntity> = new Vector.<MapEntity>();
		/** @private */ private var _eventNames:Dictionary = new Dictionary;
		/** @private */ internal var _mapTriggers:Vector.<MapEntity> = new Vector.<MapEntity>();
		/** @private */ private var _triggerNames:Dictionary = new Dictionary;
		
		
	}

}