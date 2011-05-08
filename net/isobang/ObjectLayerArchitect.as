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
	import net.isobang.entities.MapDoodad;
	import net.isobang.entities.MapTile;
	import net.isobang.entities.MapTileLayer;
	import net.isobang.Map;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Matt McFarland
	 */
	internal class ObjectLayerArchitect
	{
		
		/**
		 * Turns loaded data into entities.
		 * @param	map		map class to load
		 */
		public static function create(map:Map):void
		{
			createDoodads(map);
		}
		
		
		private static function createDoodads(map:Map):void
		{
			for each (var d:MapDoodad in map._mapDoodads)
			{
				if (!d.tileGid) return;
				var loc:Point = pixelToTileCoords(map, d.mapX, d.mapY);
				trace (loc.x, loc.y);
				loc = scanTiles(map, loc);
				d.x = loc.x, d.y = loc.y;
				d.graphic = getGraphic(d.tileGid,map);
				FP.world.add(d);
			}
		}
		
		private static function getGraphic(gid:int,map:Map):Image
		{
			for each (var t:DataTileSet in map.tileSetData) {
				if (gid < t.maxTiles && gid >= t.firstGid) {	
					return new Image(t.image, new Rectangle(t.tileRow[gid], t.tileCol[gid], t.tileWidth, t.tileHeight));		
				}
			}
			return null;
		}
		
		
		private static function scanTiles(map:Map,loc:Point):Point
		{
			var p:Point = new Point();
			for (var tileX:Number = 0; tileX < map.width; tileX+=.1) {
				for (var tileY:Number = 0; tileY < map.height; tileY+=.1) {
					var destX:int = (tileX * -map.tileWidth / 2) - (tileY * -map.tileWidth / 2); 
					var destY:int = (tileY * map.tileHeight / 2) + (tileX * map.tileHeight / 2);
					
					if (loc.x >= tileX && loc.x <= tileX + .2) {
						if (loc.y >=tileY && loc.y <= tileY + .2)
						p.x = destX-map.tileWidth, p.y = destY-map.tileHeight;
					}
				}
			}
			return p;
		}
		
		private static function tileToPixelCoords(map:Map, x:Number, y:Number):Point
		{
			var originX:int = map.height * map.tileWidth / 2;
			var loc:Point = new Point();
			loc.x = (x - y) * map.tileWidth / 2 + originX;
			loc.y = (x + y) * map.tileHeight / 2;
			trace (loc.x, loc.y);
			return loc;
		}
		
		private static function pixelToTileCoords(map:Map, x:Number, y:Number):Point
		{
			var tileWidth:int = map.tileWidth;
			var tileHeight:int = map.tileHeight;
			var ratio:Number = tileWidth / tileHeight;
			trace (ratio);
			x -= map.height * tileWidth / 2;
			var mx:Number = y - (x / ratio);
			var my:Number = y + (x / ratio);
			trace ("mx", mx, "my", my);
			return new Point(mx / tileHeight, my / tileHeight);
		}

	}
	

}