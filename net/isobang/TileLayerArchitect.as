package net.isobang 
{
	import flash.display.ActionScriptVersion;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Pixelmask;
	import net.isobang.db.cache.*
	import net.flashpunk.FP;
	import net.isobang.entities.MapTile;
	import net.isobang.entities.MapTileLayer;
	import net.isobang.Map;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Matt McFarland
	 */
	internal class TileLayerArchitect
	{
		
		/**
		 * Turns loaded data into entities.
		 * @param	map		map class to load
		 */
		public static function create(map:Map):void
		{
			createLayers(map);
		}
		
		
		/**
		 * Load all layers as entities.
		 * @param	map
		 */
		private static function createLayers(map:Map):void
		{
			for each (var l:DataTileLayer in map.tileLayerData) {
				if (l.render == "solid") createSolidLayer(map,l);
				if (l.render == "mask") createMaskLayer(map,l);
				if (l.render == "default") createDefaultLayer(map,l);
				if (!l.render) createDefaultLayer(map,l);
			}
		}
		/**
		 * Creates the default layer (just one image entity)
		 * @param	map
		 * @param	l
		 */
		private static function createDefaultLayer(map:Map, l:DataTileLayer):void
		{
			var g:Graphiclist = new Graphiclist();
			var tiles:Array = scanMapByTileOnLayer(map, l);
			for each (var newTile:Image in tiles) {	
				g.add(newTile);			
			}
			var newLayerEntity:MapTileLayer = new MapTileLayer();
			newLayerEntity.graphic =g;
			newLayerEntity.layer = l.zOrder;
			map.mapTileLayers.push(newLayerEntity);
			FP.world.add(newLayerEntity);			
		}
		/**
		 * Searches the map for tiles then adds them to the stage
		 * @param	map
		 * @param	l
		 * @return
		 */
		private static function scanMapByTileOnLayer(map:Map,l:DataTileLayer):Array
		{
			var newTiles:Array = new Array();
			var tileIndex:int = 0;
			for (var tileX:int = 0; tileX < map.width; tileX++) {
				for (var tileY:int = 0; tileY < map.height; tileY++) {
					var destX:int = (tileX * -map.tileWidth / 2) - (tileY * -map.tileWidth / 2); 
					var destY:int = (tileY * map.tileHeight / 2) + (tileX * map.tileHeight / 2);
					var tile:int = l.tiles[tileIndex];
					for each (var t:DataTileSet in map.tileSetData) {
						if (tile < t.maxTiles && tile >= t.firstGid) {
							var newTile:Image = new Image(t.image, new Rectangle(t.tileRow[tile], t.tileCol[tile], t.tileWidth, t.tileHeight));
							newTile.x = destX - t.tileWidth, newTile.y = destY - t.tileHeight;
							newTiles.push(newTile);
						}
					}
					tileIndex++;
				}
			}
			return newTiles;
		}
		/**
		 * Creates a solid layer of tiles (each tile is an entity)
		 * @param	map
		 * @param	l
		 */
		private static function createSolidLayer(map:Map, l:DataTileLayer):void
		{
			var tiles:Array = scanMapByTileOnLayer(map, l);
			for each (var t:Image in tiles) {	
				var newTile:MapTile = new MapTile;
				newTile.x = t.x;
				newTile.y = t.y;
				newTile.graphic = t;
				t.x = 0;
				t.y = 0;
				newTile.layer = l.zOrder;
				map.mapTiles.push(newTile);
				FP.world.add(newTile);			
			}
				
		}
		/**
		 * Searches a map for masks then applies them to the world.
		 * @param	map
		 * @param	l
		 * @return
		 */
		private static function scanMapByTileForMasks(map:Map,l:DataTileLayer):Array
		{
			var newTiles:Array = new Array();
			var tileIndex:int = 0;
			
			for (var tileX:int = 0; tileX < map.width; tileX++) {
				for (var tileY:int = 0; tileY < map.height; tileY++) {
					var destX:int = (tileX * -map.tileWidth / 2) - (tileY * -map.tileWidth / 2); 
					var destY:int = (tileY * map.tileHeight / 2) + (tileX * map.tileHeight / 2);
					var tile:int = l.tiles[tileIndex];
					for each (var t:DataTileSet in map.tileSetData) {
						if (tile < t.maxTiles && tile >= t.firstGid) {
							var mask:BitmapData = new BitmapData(t.tileWidth, t.tileHeight);
							var tileImg:Image = new Image(t.image);
							mask.copyPixels(tileImg.source, new Rectangle(t.tileRow[tile], t.tileCol[tile], t.tileWidth, t.tileHeight), new Point(0, 0));
							var tileMask:Pixelmask = new Pixelmask(mask);
							var newTile:MapTile = new MapTile();
							if (l.moveMask) {
								if (l.moveMask[tile-t.firstGid]) newTile.moveModifier = l.moveMask[tile-t.firstGid];
							}
							newTile.targetNames = l.targetName;
							newTile.targetTypes = l.targetType;
							tileMask.assignTo(newTile);
							newTile.x = destX - t.tileWidth, newTile.y = destY - t.tileHeight;
							newTiles.push(newTile);
						}
					}
				tileIndex++;
				}
			}
			return newTiles;
		}
		/**
		 * Creates a mask layer.
		 * @param	map
		 * @param	l
		 */
		private static function createMaskLayer(map:Map, l:DataTileLayer):void
		{
			var tiles:Array = scanMapByTileForMasks(map, l);
			for each (var m:MapTile in tiles) {	
				map.mapTiles.push(m);
				m.type = "moveMask";
				FP.world.add(m);			
			}
				
		}
		
		
	}

}















  if (mMap->orientation() == Map::Isometric) {
617	
        // Isometric needs special handling, since the pixel values are based
618	
        // solely on the tile height.
619	
        xF = (qreal) x / tileHeight;
620	
        yF = (qreal) y / tileHeight;
621	
        widthF = (qreal) width / tileHeight;
622	
        heightF = (qreal) height / tileHeight