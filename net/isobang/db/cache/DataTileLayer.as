package net.isobang.db.cache 
{
	/**
	 * ...
	 * @author Matt McFarland
	 */
	public class DataTileLayer 
	{
		/**
		 * Tile Layer Name
		 */
		public var name:String;
		/**
		 * The render style, if not used it will use default(single image)
		 */
		public var render:String;
		/**
		 * used for layer property with flash punk
		 */
		public var zOrder:int;
		/**
		 * Movement will be modified by basemovement * moveMask value. 0 = wall.
		 * You'll need to add either a targetName or targetType for moveMask to work with.
		 */
		public var moveMask:Number;
		/**
		 * An array of targetnames used for movemask.
		 */
		public var targetName:Array;
		/**
		 * An array of target types used for movemask/
		 */
		public var targetType:Array;
		/**
		 * An array of stored tiles
		 */
		public var tiles:Array;
		
		
	}

}