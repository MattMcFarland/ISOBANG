package net.isobang.db.deprecated 
{
	/**
	 * ...
	 * @author Matt McFarland
	 */
	public class loadertools 
	{
		
		/**
		 * Parses map data and returns a bitmap.
		 * @param	map map class to be used
		 * @param 	layer	layer to parse
		 * @return  BitmapData to transform into an image.
		 */
		public static function layerToBitmap(map:Class, layer:int):BitmapData
		{
			var RawData:ByteArray = new map;
			var DataString:String = RawData.readUTFBytes(RawData.length);
			var tileData:XML = new XML(DataString);
			var mapWidth:Number = tileData.@width;
			var mapHeight:Number = tileData.@height;
			var tileWidth:Number = tileData.@tilewidth;
			var tilesetWidth:Number = tileData.tileset.@tilewidth;
			var tilesetHeight:Number = tileData.tileset.@tileheight;
			var tileHeight:Number = tileData.@tileheight;
			var layerData:String = tileData.layer[layer].data;
			var screenBitmapData:BitmapData;
			var tilesBitmapData:BitmapData;
			screenBitmapData = new BitmapData(mapWidth * tileWidth, mapHeight * tileHeight * 1.1, false, 0x000000);
			//gameworld.mapWidth = mapWidth * tileWidth;
			//gameworld.mapWidth = mapHeight * tileHeight * 1.1;
			//tilesBitmapData = FP.getBitmap(GFX.TILESET);
			var tileIndex:int = 0;
			var tiles:Array = [];
			tiles = layerData.split(",");
			var tileSet:Array = new Array();
			var tileRow:Array = [];
			var tileCol:Array = [];
			var tileSetX:int = 0;
			var tileSetY:int = 0;
			var tileNo:int=0;
			
			while (tileSetX < tilesBitmapData.width)
			{
				tileRow[tileNo+1] = tileSetX;
				tileCol[tileNo+1] = tileSetY;
				tileSetX += tilesetWidth;
				if (tileSetX >= tilesBitmapData.width) {
					if (tileSetY <= tilesBitmapData.height) {
					tileSetX = 0;
					tileSetY += tilesetHeight;
					}
				}
				tileNo++;
			}
			
			var offset:int = screenBitmapData.width / 2;
			for (var tileX:int = 0; tileX < mapWidth; tileX++) {
				for (var tileY:int = 0; tileY < mapHeight; tileY++) {
					var destX:int = offset + (tileX * -tileWidth / 2) - (tileY * -tileWidth / 2); 
					var destY:int = (tileY * tileHeight / 2) + (tileX * tileHeight / 2);
					var tile:int = tiles[tileIndex];
					screenBitmapData.copyPixels(tilesBitmapData, new Rectangle(tileRow[tile], tileCol[tile], tilesetWidth, tilesetHeight), new Point(destX - tilesetWidth * .5, destY - tilesetHeight * .5));
				tileIndex++;
				}
			}	
			return screenBitmapData;
		}	
		
		public static function getEvents(map:Class,eventType:String):XMLList		{
			var target:XMLList = new XMLList();
			var RawData:ByteArray = new map;
			var DataString:String = RawData.readUTFBytes(RawData.length);
			var mapData:XML = new XML(DataString);
			for each (var objectList:XML in mapData.objectgroup) 
			{
				if (objectList.@name == "Events") {
					for each (var search:XML in objectList.object) {
						if (search.@type == eventType) {
							target += search;
							
						}
					}
					return target;
				}
			}
			return null;
		}		
	}

}