package entities.characters.dummies 
{
	import assets._nuke;
	import org.flixel.*;
	
	/**
	 * ...
	 * @author MakeShift Radio
	 */
	
	public class dummy_1 extends FlxSprite
	{
		[Embed(source = "../../../assets/images/DUMMY1.png")] public static var SHEET:Class;
		public var d:int = 0;
		public var r:Number = 0;
		public const M:Number = 500000;
		
		
		public function dummy_1(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			loadGraphic(SHEET, false, true, 9, 6);
			addAnimation("p", [0], 10, false);
			this.play("p");
			this.maxVelocity.x = 300;
			
		}
		override public function update():void
		{
			this.drag.x = 1000;
			d = (_nuke.mainPlayer.x - this.x) / Math.abs(_nuke.mainPlayer.x - this.x);
			r = Math.abs(_nuke.mainPlayer.x - this.x);
			this.acceleration.y = 500;
			if (_nuke.mainPlayer._suckIND[0]) {
				if (d > 0 && !_nuke.mainPlayer._suckIND[1]) 
					this.acceleration.x = M / (r) * d;
				else if (d < 0 && _nuke.mainPlayer._suckIND[1])
					{
					this.acceleration.x = M / (r) * d;
					trace("troll");
					}
				else
					this.acceleration.x = 0;
				trace(this.acceleration.x);
			}
			else
				this.acceleration.x = 0;
			//trace(this.acceleration.x);
		}
		
	}

}