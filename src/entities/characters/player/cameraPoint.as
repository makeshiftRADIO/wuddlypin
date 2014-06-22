package entities.characters.player 
{
	import org.flixel.*;
	import assets._nuke;
	
	public class cameraPoint extends FlxSprite
	{
		public var vSign:int;
		public var midPoint:Number;
		public var playerMidPoint:Number;
		public var resetX:Number;
		
		public function cameraPoint() 
		{
			super(0, 100);
			visible = false;
		}
		
		override public function update():void
		{
			
			super.update();
			FlxG.camera.zoom = 4;
			FlxG.camera.follow(this);
			this.velocity.y = ((_nuke.mainPlayer.y - 0 - this.y) * 7)-50;
			this.x = _nuke.mainPlayer.x;
			
		}
	}
}