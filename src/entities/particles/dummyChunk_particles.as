package entities.particles 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author MakeShift Radio
	 */
	public class dummyChunk_particles extends FlxParticle
	{
		[Embed(source = "../../assets/images/dummy chunks/chunk_1.png")] public var P1:Class;
		[Embed(source = "../../assets/images/dummy chunks/chunk_2.png")] public var P2:Class;
		[Embed(source = "../../assets/images/dummy chunks/chunk_3.png")] public var P3:Class;
		[Embed(source = "../../assets/images/dummy chunks/chunk_4.png")] public var P4:Class;
		[Embed(source = "../../assets/images/dummy chunks/chunk_5.png")] public var P5:Class;
		[Embed(source = "../../assets/images/dummy chunks/chunk_6.png")] public var P6:Class;
		[Embed(source = "../../assets/images/dummy chunks/chunk_7.png")] public var P7:Class;
		[Embed(source = "../../assets/images/dummy chunks/chunk_8.png")] public var P8:Class;
		
		public var R1:Number = 0;
		public var R2:Number = 0;
		
		public function dummyChunk_particles() 
		{
			R1 = Math.random() * 100;
			R2 = 1 + Math.random() * 3
			
			if (R1 >= 0 && R1 < 12.5) {
				loadGraphic(P1, false, false, 2, 3);
			} else if (R1 >= 12.5 && R1 < 25) {
				loadGraphic(P2, false, false, 1, 1);
			} else if (R1 >= 25 && R1 < 37.5) {
				loadGraphic(P3, false, false, 2, 2);
			} else if (R1 >= 37.5 && R1 < 50) {
				loadGraphic(P4, false, false, 2, 2);
			} else if (R1 >= 50 && R1 < 62.5) {
				loadGraphic(P5, false, false, 1, 1);
			} else if (R1 >= 62.5 && R1 < 75) {
				loadGraphic(P6, false, false, 1, 2);
			} else if (R1 >= 75 && R1 < 87.5) {
				loadGraphic(P7, false, false, 1, 1);
			} else if (R1 >= 87.5 && R1 < 100) {
				loadGraphic(P8, false, false, 2, 1);
			} 
			
			exists = false;
		}
		protected function fade():void {
			if (alpha > 0)
				alpha -= FlxG.elapsed * R2;
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
			} else 
				exists = true;
		}
		
	}

}