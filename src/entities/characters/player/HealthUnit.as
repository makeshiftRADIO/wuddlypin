package entities.characters.player 
{
	import org.flixel.*;
	import assets._nuke;
	import entities.characters.player.player_V4;
	/**
	 * ...
	 * @author Sortpherich
	 */
	public class HealthUnit extends FlxSprite
	{
		[Embed(source = "../../../assets/images/GUI_sheet_V2.gif")] public var SHEET:Class;
		public var STATUS:int = 10;
		protected var anim:String = "";
		
		public function HealthUnit(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			loadGraphic(SHEET, true, false, 6, 7);
			addAnimation("FULL", [0], 10, true);
			addAnimation("HALF", [1], 10, true);
			addAnimation("EMPTY", [2], 10, true);
			scrollFactor.x = 0;
			scrollFactor.y = 0;
		}
		override public function update():void {
			switch(STATUS) {
				case 10: {
					anim = "FULL";
				}
					break;
				case 5: {
					anim = "HALF";
				}
					break;
				case 0: {
					anim = "EMPTY";
				}
					break;
			}
			this.play(anim);
			
			super.update();
		}
		
	}

}