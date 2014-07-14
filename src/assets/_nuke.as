package assets 
{
	import entities.characters.player.player_V2;
	import entities.characters.player.player_V3;
	import entities.characters.player.player_V4;
	import org.flixel.*;
	import entities.characters.player.player;
	import entities.characters.dummies.dummy_1;
	import worlds.TestStage;
	/**
	 * ...
	 * @author makeshiftRADIO
	 */
	public class _nuke 
	{
		
		[Embed(source = "../data/mapCSV_lvl1_Solid.csv", mimeType = "application/octet-stream")] static public var MAP1:Class;
		[Embed(source = "../data/mapCSV_lvl1_Over.csv", mimeType = "application/octet-stream")] static public var MAP5:Class;
		[Embed(source = "../data/mapCSV_lvl1_Grass.csv", mimeType = "application/octet-stream")] static public var MAP3:Class;
		[Embed(source = "../data/mapCSV_lvl1_One_way.csv", mimeType = "application/octet-stream")] static public var MAP4:Class;
		[Embed(source = "../data/mapCSV_lvl1_nonSolid.csv", mimeType = "application/octet-stream")] static public var MAP2:Class;
		[Embed(source = "images/tilesheet_1.png")] static public var TILE_SHEET:Class;
		[Embed(source = "images/sky.png")] static public var SKY:Class;
		
		public static var TILE_MAP:FlxTilemap = new FlxTilemap();
		public static var TILE_MAP2:FlxTilemap = new FlxTilemap();
		public static var TILE_MAP3:FlxTilemap = new FlxTilemap();
		public static var TILE_MAP4:FlxTilemap = new FlxTilemap();
		public static var TILE_MAP5:FlxTilemap = new FlxTilemap();
		
		public static var allParticles:FlxGroup = new FlxGroup;
		public static var colideParticles:FlxGroup = new FlxGroup;
		public static var dummy1:dummy_1 = new dummy_1(91, 305);
		public static var dummy2:dummy_1 = new dummy_1(300, 100);
		public static var dummy3:dummy_1 = new dummy_1(57, 50);
		public static var mainPlayer:player_V4 = new player_V4(300, 100);
		
		public static var health:Number = 50;
		
	}

}