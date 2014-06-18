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
			else if (name == "tiled_cave") return GFX.TILED_CAVE;
			else if (tilesets.hasOwnProperty(name)) return tilesets[name];
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
			else if (entities.hasOwnProperty(type)) return new entities[type];
			return null;
		}
		/**
		 * Register a new Tileset
		 * @param	name	The tileset name as given through TILED
		 * @param	class   The class containing the embedded graphic for the tileset
		 */
		public static function registerTileset(name:String, class:Class):void
		{
			tilesets[name] = class;
		}
		/**
		 * Register a new Entity
		 * @param	name	The type of the entity
		 * @param	class   The entity class to create a new one
		 */
		public static function registerEntity(type:String, class:Class):void
		{
			entities[type] = class;
		}
		
		protected static var tilesets:Object = new Object;
		protected static var entities:Object = new Object;
	}
}