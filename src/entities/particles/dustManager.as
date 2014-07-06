package entities.particles 
{
	import org.flixel.FlxGroup;
	import entities.particles.emitterUNI;
	/**
	 * ...
	 * @author MakeShift Radio
	 */
	public class dustManager extends FlxGroup
	{
		
		public function dustManager() 
		{
			super();
			for (var i:int = 0; i < 10; i++) {
				add(new emitterUNI(0, 0, dust_particle, 50, 500, -60, 60, -10, -100, 0, 0));
			}
			
		}
		
	}

}