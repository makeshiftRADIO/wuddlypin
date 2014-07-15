package entities.characters.player 
{

	import org.flixel.FlxSprite;
	import assets._nuke;
	
	public class floor_sensor extends FlxSprite
	{
		public var Ply:Boolean = true;
		public function floor_sensor(Pl:Boolean = true) 
		{	
			if (Pl)
				makeGraphic(6, 1);
			else 
				makeGraphic(1, 1);
			visible = false;// Pl ? false : true;
			Ply = Pl;
		}
		
		override public function update():void 
		{
			if (Ply)
				this.y = _nuke.mainPlayer.y + 10;
				
			super.update();
		}
		
	}

}