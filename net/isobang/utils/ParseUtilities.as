package net.isobang.utils 
{
	import net.flashpunk.utils.Ease;
	/**
	 * ...
	 * @author Matt McFarland
	 */
	public class ParseUtilities 
	{
		/**
		 * Converts a map ease property into the real 'thang.
		 * @param	arg	map property
		 * @return	teh ease function ;p
		 */
		public static function getEase(arg:String):Function
		{
			var ease:Function;
			if (arg == "backIn") ease = Ease.backIn;
			if (arg == "backInOut") ease = Ease.backInOut;
			if (arg == "backOut") ease = Ease.backOut;
			if (arg == "bounceIn") ease = Ease.bounceIn;
			if (arg == "bounceInOut") ease = Ease.bounceInOut;
			if (arg == "bounceOut") ease = Ease.bounceOut;
			if (arg == "circIn") ease = Ease.circIn;
			if (arg == "circInOut") ease = Ease.circInOut;
			if (arg == "circOut") ease = Ease.circOut;
			if (arg == "cubeIn") ease = Ease.cubeIn;
			if (arg == "cubeInOut") ease = Ease.cubeInOut;
			if (arg == "cubeOut") ease = Ease.cubeOut;
			if (arg == "expoIn") ease = Ease.expoIn;
			if (arg == "expoInOut") ease = Ease.expoInOut;
			if (arg == "expoOut") ease = Ease.expoOut;
			if (arg == "quadIn") ease = Ease.quadIn;
			if (arg == "quadInOut") ease = Ease.quadInOut;
			if (arg == "quadOut") ease = Ease.quadOut;
			if (arg == "quartIn") ease = Ease.quartIn;
			if (arg == "quartInOut") ease = Ease.quartInOut;
			if (arg == "quartOut") ease = Ease.quartOut;
			if (arg == "quintIn") ease = Ease.quintIn;
			if (arg == "quintInOut") ease = Ease.quintInOut;
			if (arg == "quintOut") ease = Ease.quintOut;
			if (arg == "sineIn") ease = Ease.sineIn;
			if (arg == "sineInOut") ease = Ease.sineInOut;
			if (arg == "sineOut") ease = Ease.sineOut;
			return ease;
		}
		/**
		 * Converts a csv formatted string into a single Vector of strings.
		 * @param	s	String to convert	
		 * @return	Vector
		 */
		public static function stringToVector(s:String):Vector.<String>
		{
			var v:Vector.<String> = new Vector.<String>();
			var a:Array = s.split(",");
			for each (var i:String in a) {
				v.push(i);
			}
			trace (v.length);
			return v;
		}
		
	}

}