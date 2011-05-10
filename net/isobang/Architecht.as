package net.isobang 
{
	import adobe.utils.ProductManager;
	import flash.display.ActionScriptVersion;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Canvas;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Mask;
	import net.flashpunk.masks.Pixelmask;
	import net.isobang.db.cache.*;
	import net.isobang.entities.*;
	import net.flashpunk.utils.Draw;
	/**
	 * ...
	 * @author Matt McFarland
	 */
	internal class Architecht
	{
		
		/**
		 * Turns loaded data into entities.
		 * @param	map		map class to load
		 */
		public static function create(map:Map):void
		{
			createLayers(map);
			createDoodads(map);
			createEvents(map);
			createTriggers(map);
			//setCamera();
		}
		private static function setCamera():void
		{
			var all:Array = new Array();
			FP.world.getAll(all)
			for each (var e:Entity in all)
			{
				e.graphic.scrollX = 1;
				e.graphic.scrollY = 1;
			}
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
				if (l.render == "default") createDefaultLayer(map, l);
				if (!l.render) createDefaultLayer(map, l);
			}
		}
		
		
		/**
		 * Creates the default layer (just one image entity)
		 * @param	map
		 * @param	l
		 */
		private static function createDefaultLayer(map:Map, l:DataTileLayer):void
		{
			var tileIndex:int = 0;
			var layerBMP:BitmapData = new BitmapData(map.pixelWidth+map.tileWidth, map.pixelHeight+map.tileHeight, true, 0);
			for (var tileY:int = 0; tileY < map.height; tileY++) {
				for (var tileX:int = 0; tileX < map.width; tileX++) {
					var tile:int = l.tiles[tileIndex];
					for each (var t:DataTileSet in map.tileSetData) {
						if (tile < t.maxTiles && tile >= t.firstGid) {
							layerBMP.copyPixels(t.image, new Rectangle(t.tileRow[tile], t.tileCol[tile], t.tileWidth, t.tileHeight),tileToPixelCoords(map,new Point(tileX,tileY)),null,null,true);
						}
					}
					tileIndex++;
				}
			}
			var newLayer:MapTileLayer = new MapTileLayer();
			newLayer.graphic = new Image(layerBMP);
			newLayer.layer = l.zOrder;
			map.mapTileLayers.push(newLayer);
			FP.world.add(newLayer);			
		}
		
		
		/**
		 * Creates the default layer (just one image entity)
		 * @param	map
		 * @param	l
		 */
		private static function createMaskLayer(map:Map, l:DataTileLayer):void
		{
			var tileIndex:int = 0;
			var mask:BitmapData = new BitmapData(map.pixelWidth+map.tileWidth, map.pixelHeight+map.tileHeight, false, 0);
			for (var tileY:int = 0; tileY < map.height; tileY++) {
				for (var tileX:int = 0; tileX < map.width; tileX++) {
					var tile:int = l.tiles[tileIndex];
					for each (var t:DataTileSet in map.tileSetData) {
						if (tile < t.maxTiles && tile >= t.firstGid) {
							mask.copyPixels(t.image, new Rectangle(t.tileRow[tile], t.tileCol[tile], t.tileWidth, t.tileHeight), tileToPixelCoords(map,new Point(tileX,tileY)));
						}
					}
					tileIndex++;
				}
			}
			var tileMask:Pixelmask = new Pixelmask(mask);
			var newLayer:MapTileLayer = new MapTileLayer();
			tileMask.assignTo(newLayer);
			newLayer.mask = tileMask;
			newLayer.layer = l.zOrder;
			map.mapTileLayers.push(newLayer);
			FP.world.add(newLayer);			
		}
		
		/**
		 * Creates a solid layer of tiles (each tile is an entity)
		 * @param	map
		 * @param	l
		 */
		private static function createSolidLayer(map:Map, l:DataTileLayer):void
		{
			var tileIndex:int = 0;
			for (var tileY:int = 0; tileY < map.height; tileY++) {
				for (var tileX:int = 0; tileX < map.width; tileX++) {
					var tile:int = l.tiles[tileIndex];
					for each (var t:DataTileSet in map.tileSetData) {
						if (tile < t.maxTiles && tile >= t.firstGid) {
							var tileImage:Image = new Image(t.image, new Rectangle(t.tileRow[tile], t.tileCol[tile], t.tileWidth, t.tileHeight));
							var p:Point = tileToPixelCoords(map, new Point(tileX,tileY));
							var newTile:MapTile = new MapTile();
							newTile.x = p.x, newTile.y = p.y;
							newTile.graphic = tileImage;
							newTile.layer = l.zOrder;
							map.mapTiles.push(newTile);
							FP.world.add(newTile);
						}
					}
					tileIndex++;
				}
			}
		}

		
		/**
		 * Creates all Doodads
		 * @param	map
		 */
		private static function createDoodads(map:Map):void
		{
			for each (var d:MapDoodad in map._mapDoodads)
			{
				if (!d.tileGid) return;
				var p:Point = convertCoords(map, d.mapX, d.mapY);
				d.x = p.x, d.y = p.y - map._tileHeight;
				//Set Graphic and Layer
				d.graphic = getGraphic(d.tileGid, map);
				d.layer = 11;
				FP.world.add(d);
			}
		}
		/**
		 * Creates all events
		 * @param	map
		 */
		private static function createEvents(map:Map):void
		{
			for each (var e:MapEvent in map._mapEvents)
			{
				//Convert TMX coordinates to screen
				var bnds:Array = convertAlltoTile(map, e.mapX, e.mapY, e.mapWidth, e.mapHeight);
				var bounds:Rectangle = new Rectangle(bnds[0],bnds[1],bnds[2],bnds[3]);
				var pgon:Vector.<Point> = tileRectToPolygon(map, bounds);
				var center:Point = findCenter(pgon);
				e.x = pgon[0].x, e.y = pgon[0].y;
				e.y += map._tileHeight*2;
				e.x += map._tileHeight;
				e.y += 6;
				e.center = center;
				//IF debug mode show the event object.
				if (Config.DebugMode) {
					var img:BitmapData = polygon(map, pgon, e.color);
					var nm:Text = new Text(e.name);
					nm.size = 12;
					nm.color = 0xFFFFFF;
					nm.blend = "difference";
					nm.y += nm.height / 2;
					nm.x -= nm.width/2;
					
					var newImage:Image = new Image(img);
					newImage.originX = pgon[0].x;
					e.graphic = new Graphiclist(newImage, nm);
					e.layer = 11;
				}
				FP.world.add(e);				
			}
		}
		/**
		 * Creates all events
		 * @param	map
		 */
		private static function createTriggers(map:Map):void
		{
			for each (var t:MapTrigger in map._mapTriggers)
			{
				//Convert TMX coordinates to screen
				var bnds:Array = convertAlltoTile(map, t.mapX, t.mapY, t.mapWidth, t.mapHeight);
				var bounds:Rectangle = new Rectangle(bnds[0],bnds[1],bnds[2],bnds[3]);
				var pgon:Vector.<Point> = tileRectToPolygon(map, bounds);
				var center:Point = findCenter(pgon);
				t.x = pgon[0].x, t.y = pgon[0].y;
				t.y += map._tileHeight*2;
				t.x += map._tileHeight;
				t.y += 6;
				t.center = center;
				var img:BitmapData;
				//IF debug mode show the event object.
				if (Config.DebugMode) {
					img = polygon(map, pgon, t.color);
					var nm:Text = new Text(t.name);
					nm.size = 12;
					nm.color = 0xFFFFFF;
					nm.blend = "difference";
					nm.y += nm.height / 2;
					nm.x -= nm.width/2;
					
					var newImage:Image = new Image(img);
					newImage.originX = pgon[0].x;
					t.graphic = new Graphiclist(newImage, nm);
					t.layer = 11;
				}
				if (t.type == "collide")
				{
					img = polygon(map, pgon, t.color);
					var collideMask:Pixelmask = new Pixelmask(img);
					collideMask.assignTo(t);
					t.mask = collideMask;
					collideMask.x -= img.width / 2;
					
				}
				FP.world.add(t);	
				t.init();
			}
		}
		/**
		 * Convert TMX Isometric pixel coordinates and dimensions to onscreen coordinates and dimensions
		 * @param	map
		 * @param	x		Coordinates
		 * @param	y		Coordinates
		 * @param	w		Width
		 * @param	h		Height
		 * @return	Array of converted Numbers.
		 */
		private static function convertAlltoTile(map:Map, x:Number, y:Number, w:Number, h:Number):Array
		{
			
			var xF:Number = x / map._tileHeight;
			var yF:Number = y / map._tileHeight;
			var widthF:Number = w / map._tileHeight;
			var heightF:Number = h / map._tileHeight;
			return new Array(xF, yF, widthF, heightF);
		}

		/**
		 * Convert TMX Isometric pixel coordinates to on-screen coordinates.
		 * @param	map		map
		 * @param	x		x coordinates
		 * @param	y		y coordinates
		 * @return	Point
		 */
		private static function convertCoords(map:Map, x:Number, y:Number):Point
		{
			//Convert TMX Coordinates to Tile Coordinates.
			var a:Point = getTileCoords(map, x, y);
			//Convert Tile Coordinates to Screen Coordinates
			var b:Point = tileToPixelCoords(map, new Point(a.x, a.y));
			return b;
		}
		/**
		 * Returns the correct graphic per the tile ID
		 * @param	gid		Grid ID Number from TMX file
		 * @param	map
		 * @return	Image
		 */
		private static function getGraphic(gid:int,map:Map):Image
		{
			for each (var t:DataTileSet in map.tileSetData) {
				if (gid < t.maxTiles && gid >= t.firstGid) {	
					return new Image(t.image, new Rectangle(t.tileRow[gid], t.tileCol[gid], t.tileWidth, t.tileHeight));		
				}
			}
			return null;
		}
		
		/**
		 * Converts TMX Pixel Coordinates to Tile Coordinates
		 * @param	map
		 * @param	x
		 * @param	y
		 * @return	Point
		 */
		private static function getTileCoords(map:Map, x:Number, y:Number):Point
		{
			//y += map.tileHeight *2
			x = x / map.tileHeight;
			y = y / map.tileHeight;
			return new Point(x, y);
		}
		
		/**
		 * Convert a Tile's coordinates to pixel coordinates.
		 * @param	map		Map Class
		 * @return	Point with pixel coordinates
		 */
		private static function tileToPixelCoords(map:Map, p:Point):Point
		{
			var x:Number = p.x;
			var y:Number = p.y;
			var originX:int = map.height * map.tileWidth / 2;
			
			var offsetY:int = map.tileHeight * 2;
			return new Point(	(x - y) * map.tileWidth / 2 + originX,
								(x + y) * map.tileHeight / 2-offsetY);
		}
		
		/**
		 * Convert Pixel to Tile Coordinates.
		 * @param	map		Map Class
		 * @param	x		Pxiel X
		 * @param	y		Pixel Y
		 * @return	Point with Tile coordinates.
		 */
		private static function pixelToTileCoords(map:Map, x:Number, y:Number):Point
		{
			var ratio:Number =  map.tileWidth / map.tileHeight;
			var mx:Number = y + (x / ratio);
			var my:Number = y - (x / ratio);
			return new Point(mx / map.tileHeight, my / map.tileHeight);
		}
		
		/**
		 * Converts tile Rect data into Isometric polygon
		 * @param	map		
		 * @param	rect	
		 * @return	Vector containing Polygon Coordinates
		 */
		private static function tileRectToPolygon(map:Map, rect:Rectangle):Vector.<Point>
		{
			var topLeft:Point = rect.topLeft;
			var topRight:Point = new Point(rect.right, rect.y );
			var bottomLeft:Point = new Point(rect.x, rect.bottom);
			var bottomRight:Point = rect.bottomRight;
			var polygon:Vector.<Point> = new Vector.<Point>();
			polygon.push (tileToPixelCoords(map, topLeft));
			polygon.push (tileToPixelCoords(map, topRight));
			polygon.push (tileToPixelCoords(map, bottomRight));
			polygon.push (tileToPixelCoords(map, bottomLeft));
			return polygon;
		}
		/**
		 * Quick point
		 * @param	p	old point
		 * @return	new Point
		 */
		private static function qPoint(p:Object):Point
		{
			return new Point(p.x, p.y);
		}
		/**
		 * Draws a polygon to BitmapData
		 * @param	map
		 * @param	v		Vector of Polygon coordinates
		 * @param	color	TMX Polygon COlor
		 * @return	BitmapData
		 */
		private static function polygon(map:Map,v:Vector.<Point>,color:uint):BitmapData
		{
			if (!color) color = 0xFFFFFF;
			var topLeft:Point = v[0];
			var topRight:Point = v[1];
			var bottomRight:Point = v[2];
			var bottomLeft:Point = v[3];
			var width:Number = topRight.x - bottomLeft.x;
			var height:Number = bottomRight.y - topLeft.y;
			//create new zero
			var Top:Number = topLeft.y;
			var Left:Number = bottomLeft.x;
			for each (var p:Point in v)
			{
				p.x -= Left;
				p.y -= Top;
			}
			
			
			var polyImg:BitmapData = new BitmapData(width+2, height+2, true, color);
			Draw.setTarget(polyImg, null, "screen");
			Draw.linePlus(topLeft.x, topLeft.y, topRight.x, topRight.y,color,1,3);
			Draw.linePlus(topRight.x, topRight.y, bottomRight.x, bottomRight.y,color,1,3);
			Draw.linePlus(bottomRight.x,bottomRight.y,bottomLeft.x,bottomLeft.y,color,1,3);
			Draw.linePlus(bottomLeft.x, bottomLeft.y, topLeft.x, topLeft.y, color, 1, 3);
			var i:int = 0
			var fillerLeft:Point = new Point(topLeft.x, topLeft.y);
			var fillerRight:Point = new Point(topRight.x, topRight.y);
			while (fillerLeft.x > bottomLeft.x)
			{
				Draw.linePlus(fillerLeft.x, fillerLeft.y, fillerRight.x, fillerRight.y, color, .5, 1);
				fillerLeft.x -= 2;
				fillerRight.x -= 2;
				fillerLeft.y += 1;
				fillerRight.y += 1;
			}
			Draw.circlePlus(width / 2, height / 2, 10, color, .5);
			Draw.setTarget(polyImg, null, "difference");
			Draw.rectPlus(topLeft.x-4, topLeft.y-4, 8, 8, color);
			return polyImg;
		}
		/**
		 * Returns the center of a polygon
		 * @param	polygon		polygon vector
		 * @return	Point Center
		 */
		private static function findCenter(polygon:Vector.<Point>):Point
		{
			var topLeft:Point = polygon[0];
			var topRight:Point = polygon[1];
			var bottomRight:Point = polygon[2];
			var bottomLeft:Point = polygon[3];
			var width:Number = topRight.x - bottomLeft.x;
			var height:Number = bottomRight.y - topLeft.y;
			return new Point(width / 2, height / 2);
		}
		
		
		
	}

}