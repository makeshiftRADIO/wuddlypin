package worlds
{
	import entities.characters.player.cameraPoint;
	import entities.characters.player.player_V4;
	import entities.characters.player.spit_chunk;
	import org.flixel.*;
	import entities.*;
	import assets._nuke;
	import entities.characters.player.gui;
 
	public class TestStage extends FlxState
	{
		public var camera:cameraPoint = new cameraPoint();
		public var sky:FlxSprite = new FlxSprite(335, 180, _nuke.SKY);
		[Embed(source = "../assets/images/KEN008---Classic-Kenya---web.jpg")] static public var BG:Class;
		public var BG_L:FlxSprite;
		public static var GROOP:FlxGroup = new FlxGroup();
		
		override public function create():void
		{
			_nuke.TILE_MAP.loadMap(new _nuke.MAP1, _nuke.TILE_SHEET, 10, 10);
			_nuke.TILE_MAP2.loadMap(new _nuke.MAP2, _nuke.TILE_SHEET, 10, 10);
			_nuke.TILE_MAP3.loadMap(new _nuke.MAP3, _nuke.TILE_SHEET, 10, 10);
			_nuke.TILE_MAP4.loadMap(new _nuke.MAP4, _nuke.TILE_SHEET, 10, 10);
			_nuke.TILE_MAP4 .setTileProperties(12, FlxObject.UP, null, null, 63);
			_nuke.TILE_MAP .setTileProperties(12, FlxObject.ANY, null, null, 63);
			_nuke.TILE_MAP5.loadMap(new _nuke.MAP5, _nuke.TILE_SHEET, 10, 10);
			sky.scrollFactor.x = sky.scrollFactor.y = 0;
			gui.updateGUI("HEALTH");
			
			
			add(sky);
			add(BG_L = new FlxSprite(0, 0, BG));
			BG_L.scrollFactor.x = 0.2;
			BG_L.scrollFactor.y = 0.2;
			add(_nuke.TILE_MAP);
			add(_nuke.TILE_MAP2);
			add(_nuke.TILE_MAP4);
			add(_nuke.TILE_MAP3);
			add(_nuke.allParticles);
			add(_nuke.colideParticles);
			add(_nuke.mainPlayer);// = new player_V4(300, 100));
			add(GROOP);
			add(_nuke.dummy1);
			add(_nuke.dummy2);
			add(_nuke.dummy3);
			add(_nuke.dummyRED1);
			add(_nuke.dummyRED2);
			add(_nuke.dummyRED3);
			add(_nuke.TILE_MAP5);
			add(gui.healthBAR_GR);
			//add(_nuke.healthUNIT);
			add(camera);
			
			FlxG.camera.setBounds( -335, -180, 1030 + 320, 530 + 180);
			//_nuke.healthUNIT.scrollFactor.x = 0;
			//_nuke.healthUNIT.scrollFactor.y = 0;
			
			
			
		}
		override public function update():void
		{
			
			if (FlxG.keys.justPressed("L") )
				_nuke.colideParticles.add(new spit_chunk(_nuke.mainPlayer.x, _nuke.mainPlayer.y, _nuke.mainPlayer.facing));
			
			super.update();
			//FlxG.timeScale = 0.2;
			if (FlxG.keys.justPressed("T")) {
				if (FlxG.timeScale == 1)
					FlxG.timeScale = 0.2;
				else
					FlxG.timeScale = 1;
			}
			//FlxG.log("x:"+camera.x+" y:"+camera.y);
		
			
			//FlxG.collide(_nuke.allParticles, TILE_MAP);
			//FlxG.collide(_nuke.allParticles, TILE_MAP4);
			FlxG.collide(_nuke.mainPlayer, _nuke.TILE_MAP4);
			FlxG.collide(_nuke.mainPlayer, _nuke.TILE_MAP);
			
			FlxG.collide(_nuke.colideParticles, _nuke.TILE_MAP4);
			
			FlxG.collide(_nuke.colideParticles, _nuke.TILE_MAP);
			
			FlxG.collide(_nuke.dummy1, _nuke.TILE_MAP);
			FlxG.collide(_nuke.dummy1, _nuke.TILE_MAP4);
			FlxG.collide(_nuke.dummy2, _nuke.TILE_MAP);
			FlxG.collide(_nuke.dummy2, _nuke.TILE_MAP4);
			FlxG.collide(_nuke.dummy3, _nuke.TILE_MAP);
			FlxG.collide(_nuke.dummy3, _nuke.TILE_MAP4);
			FlxG.collide(_nuke.dummyRED1, _nuke.TILE_MAP);
			FlxG.collide(_nuke.dummyRED1, _nuke.TILE_MAP4);
			FlxG.collide(_nuke.dummyRED2, _nuke.TILE_MAP);
			FlxG.collide(_nuke.dummyRED2, _nuke.TILE_MAP4);
			FlxG.collide(_nuke.dummyRED3, _nuke.TILE_MAP);
			FlxG.collide(_nuke.dummyRED3, _nuke.TILE_MAP4);
		}
	}
}