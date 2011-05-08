package net.isobang.entities.mapevents 
{
	import net.isobang.utils.*;	
	import net.flashpunk.utils.Ease;
	import net.flashpunk.FP;
	import net.flashpunk.tweens.misc.VarTween;
	import net.isobang.*;
	/**
	 * Moves the camera to the object's location.
	 * @author Matt McFarland
	 */
	public class MoveCamera extends MapEvent
	{
		/**
		 * duration of the camera movement, in seconds.
		 */
		public var duration:Number;
		/**
		 * An easing function that can be used to modify the camera movement. 
		 */
		public var ease:Function;
		/**
		 * The mover
		 */
		public var xMover:VarTween;
		public var yMover:VarTween;
		/**
		 * Adds Specific Tiled Map Event to Map Event Vector
		 * @param	link	XML link from Tiled file.
		 */		
		
		public function MoveCamera(link:XML) 
		{
			super(link);
			for each (var property:XML in link.properties.property) {
				if (property.@name == "duration") duration = Number(property.@value);
				if (property.@name == "ease") ease = ParseUtilities.getEase(property.@value);
				if (property.@name == "next") nextEvents = ParseUtilities.stringToVector(property.@value);
			}			
		}
		
		
		override public function action():void
		{
			xMover = new VarTween();
			yMover = new VarTween();
			if (duration > 0) {
				xMover.tween(FP.camera, "x", x-FP.halfWidth, duration, ease);
				yMover.tween(FP.camera, "y", y-FP.halfHeight, duration, ease);
				world.addTween(xMover, true);
				world.addTween(yMover, true);
				
			} else {
				FP.camera.x = x;
				FP.camera.y = y;
			}
			
			
		}
		
	}

}