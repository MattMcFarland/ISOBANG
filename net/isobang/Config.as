package net.isobang 
{
	import net.isobang.entities.TestEntity;
	/**
	 * ...
	 * @author Matt McFarland
	 */
	public class Config 
	{
	
		public static var DebugMode:Boolean = true;
		/**
		 * Returns the correct tileset class depending on tileset name.
		 * @param	name	Tileset name as given through TILED.
		 * @return	Correct graphic class
		 */
		public static function getTileset(name:String):Class
		{
			if (name == "mock TILESET") return GFX.MOCK_TILESET;
			if (name == "tiled_cave") return GFX.TILED_CAVE;
			return null;
		}
		/**
		 * Returns the correct type and makes it.
		 * @param	type	Type of 
		 * @return
		 */
		public static function getEntity(type:String):Object
		{
			if (type == "test") return new TestEntity();
			return null;
		}
		
	}
	
	

}