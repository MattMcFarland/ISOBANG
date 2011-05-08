package net.isobang.entities 
{
	import net.isobang.MapEntity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	/**
	 * ...
	 * @author Matt McFarland
	 */
	public class TestEntity extends MapEntity
	{
		
		public function TestEntity() 
		{
			graphic = Image.createCircle(10);
			setHitbox(20, 20, 5, 5);
		}
		
		override public function update():void
		{
			var mx:Number = world.mouseX;
			var my:Number = world.mouseY;
			moveTowards(mx, my, 10);
		}
		
	}

}