package entities.characters.player 
{
	
	import org.flixel.*;
	import assets._nuke;
	import entities.characters.player.HealthUnit;
	
	public class gui extends FlxGroup
	{
		public static var healthBAR_GR:FlxGroup = new FlxGroup();
		public static var healthBAR:Array = new Array();
		public static var UNITx:int = 340;
		public static var UNITy:int = 183;
		
		public function gui()
		{
			this.add(healthBAR_GR);	
		}
		public static function updateGUI(TARGET:String):void {
			switch(TARGET) {
				
				
				case "HEALTH": {
					setHealth(_nuke._PLAYER_MAX_HEALTH);
				}
					break;
			}
		}
		public static function setHealth(MAX:int):void {
			UNITx = 340;
			if (healthBAR.length == 0) {
				for (var i:int = 0; i < MAX; i++) {
					healthBAR.push(new HealthUnit(UNITx, UNITy));
					healthBAR_GR.add(healthBAR[i]);
					UNITx += 9;
				}
			} else if (MAX > healthBAR.length) {
				UNITx = 340 + (healthBAR.length) * 9;
				for (var j:int = healthBAR.length; j < MAX; j++) {
					healthBAR.push(new HealthUnit(UNITx, UNITy));
					healthBAR_GR.add(healthBAR[j]);
					UNITx += 9;
				}				
			} else if (MAX < healthBAR.length) {
				for (var k:int = 0; k < healthBAR.length - MAX; k++) {
					healthBAR[healthBAR.length - 1].kill();
					healthBAR.pop();
				}
			}
			updateHealth(_nuke._PLAYER_HEALTH, MAX);
		}
		public static function updateHealth(HP:int, MAXh:int):void {
			var counter:int = 0;
			for (var i:int = 0; i < healthBAR.length; i++) {
				counter = 0;
				for (var j:int = 0; j < 2; j++) {
					if (HP <= 0) {
						HP = 0;
						if (counter == 0)
							counter = 0;
					}else {
						HP -= 5;
						counter += 5;
					}
					
				}
				healthBAR[i].STATUS = counter;
			}
		}
	}

}