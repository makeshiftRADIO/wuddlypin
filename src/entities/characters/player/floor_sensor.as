package entities.characters.player 
{

	import org.flixel.FlxSprite;
	import assets._nuke;
	
	public class floor_sensor extends FlxSprite
	{
		
		public function floor_sensor() 
		{
			makeGraphic(6, 1);
			visible = false;
		}
		
		override public function update():void 
		{
				this.y = _nuke.mainPlayer.y + 10;
				
			super.update();
		}
		
	}

}