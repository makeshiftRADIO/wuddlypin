package entities.particles 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author MakeShift Radio
	 */
	public class dust_particle extends FlxParticle
	{
		[Embed(source = "../../assets/images/DustParticl_1.png")] public static var P1:Class;
		[Embed(source = "../../assets/images/DustParticl_2.png")] public static var P2:Class;
		
		public var R1:Number = 0;
		public var R2:Number = 0;
		public var R3:Number = 0;
		
		public function dust_particle() 
		{
			super();
			
			R1 = Math.random();
			R2 = Math.random();
			R3 = 1 + Math.random() * 3;
			
			if (R1 < 0.5) {
				if (R2 < 0.25)
					loadGraphic(P1, false, false, 2, 2);
				else
					loadGraphic(P1, false, false, 1, 1);
			}
			else {
				if (R2 < 0.25)
					loadGraphic(P2, false, false, 2, 2);
				else
					loadGraphic(P2, false, false, 1, 1);
			}
			
			exists = false;
		}
		
		protected function fade():void {
			if (alpha > 0)
				alpha -= FlxG.elapsed * R3;
		}
		
		override public function onEmit():void {
			alpha = 1;
			elasticity = 0;
			drag = new FlxPoint(4, 0);
		}
		
		override public function update():void {
			fade();
			if (alpha <= 0 || !onScreen()) {
				exists = false;
				kill();
			}
			else
				exists = true;
				
			super.update();
		}
		
	}

}