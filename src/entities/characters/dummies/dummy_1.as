package entities.characters.dummies 
{
	import assets._nuke;
	import entities.particles.*;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author MakeShift Radio
	 */
	
	public class dummy_1 extends FlxSprite
	{
		[Embed(source = "../../../assets/images/DUMMY1.png")] public static var SHEET:Class;
		protected const M:int = 10000;
		public var Rx:Number = 0;
		public var Ry:Number = 0;
		public var emtr:emitterUNI;
		
		public function dummy_1(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			loadGraphic(SHEET, true, true, 9, 6);
			addAnimation("R", [0], 10, false);
			this.play("R");
			/*this.velocity.x = 50;
			this.velocity.y = -50;*/
			this.maxVelocity.x = 100;
			this.maxVelocity.y = 100;
		}
		
		override public function update():void {
			Rx = _nuke.mainPlayer.x - this.x;
			Ry = _nuke.mainPlayer.y - this.y;
			
			//this.acceleration.x = M / Rx;
			//this.acceleration.y = M / Ry;
			
			//trace("DUMMY", this.acceleration.x, this.acceleration.y);
			
			super.update();
		}
		
	}

}