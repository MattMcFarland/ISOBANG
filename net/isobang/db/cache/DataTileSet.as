package net.isobang.db.cache 
{
	import flash.display.BitmapData;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.isobang.Config;
	/**
	 * ...
	 * @author Matt McFarland
	 */
	public class DataTileSet 
	{
		/**
		 * Name of the tileset, this is used to find out which image to grab.
		 */
		public var name:String;
		/**
		 * Image grabbed for tileset
		 */
		public var image:BitmapData;
		/**
		 * First Grid ID from TILED.
		 */
		public var firstGid:int;
		/**
		 * Each tiles width
		 */
		public var tileWidth:int;
		/**
		 * Each tiles height
		*/ 
		public var tileHeight:int;
		/**
		 * Array holding row coordinates
		 */
		public var tileRow:Array = [];
		/**
		 * Array holding column coordinates
		 */
		public var tileCol:Array = [];

		private var _maxTiles:int;
		
		/**
		 * Initializes the tilest by grabbing the correct image and setting up
		 * the grid arrays tileRow and tileCol.
		 */
		public function init():void
		{
			image = FP.getBitmap(Config.getTileset(name));
			var tileSetX:int = 0;
			var tileSetY:int = 0;
			var tileNo:int = firstGid-1;
			while (tileSetX < image.width)
			{
				tileRow[tileNo+1] = tileSetX;
				tileCol[tileNo+1] = tileSetY;
				tileSetX += tileWidth;
				if (tileSetX >= image.width) {
					if (tileSetY <= image.height) {
					tileSetX = 0;
					tileSetY += tileHeight;
					}
				}
				tileNo++;
			}
			_maxTiles = tileNo;
			
		}

		/**
		 * The max tiles used for this tile set.
		 */
		public function get maxTiles():int	{ return _maxTiles; }
		
	}
	
	

}