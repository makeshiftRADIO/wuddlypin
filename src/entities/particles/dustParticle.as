package entities.particles 
{
	import org.flixel.FlxParticle;
	/**
	 * ...
	 * @author bottlecap
	 */
	public class dustParticle extends FlxParticle
	{
		
		public function dustParticle() 
		{
			this.makeGraphic(1, 1, 0xeff9c2d0e);
		}
		override public function update():void 
		{
			this.alpha = this.alpha - 0.01
			super.update();
		}
		
	}

}