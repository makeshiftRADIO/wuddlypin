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
		[Embed(source = "../../../assets/images/spritesheet_dummy.png")] public var SHEET:Class;
		/** GENERAL VARs **/
		public var g:Number = 500;
		public var WALK_SPEED:int = 40;
		public var anim:String = "";
		
		/** STATE VARs **/
		public var anim_STATE:String = "";
		protected var _facing_sing:int = 0;
		protected var current_V:Number = 0;
		protected var GONNA_GO:Boolean = false;
		protected var ACC_SET:Boolean = false;
		protected var ACC_DIR:int = 0;
		protected var DEAD:Boolean = false;
		protected var LOCK:Boolean = false;
		protected var WALK_MnMx:Array = new Array(3, 30);
		protected var WAIT_MnMx:Array = new Array(0.5, 5);
		
		/** TIMER VARs **/
		protected var waiting:Number = 0;
		protected var walking:Number = 0;
		
		public function dummy_1(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			loadGraphic(SHEET, true, true, 9, 8);
			addAnimation("idle", [0], 1, true);
			addAnimation("walk", [1, 0], 10, true);
		}
		
		override public function update():void {
			/** INITIAL SETTINGS **/
			this.acceleration.y = g;
			this.maxVelocity.x = WALK_SPEED;
			this.drag.x = WALK_SPEED * 3;
			if (this.velocity.x != 0)
				current_V = this.velocity.x;
				
			/** LOOP **/	
			if (!DEAD) {
				if (!LOCK) {
					if (this.velocity.x < 0)
						facing = LEFT;
					if (this.velocity.x > 0)
						facing = RIGHT;
					if (!GONNA_GO) {
						waiting += FlxG.elapsed;
						if (waiting >= (Math.random() * (WAIT_MnMx[1] - WAIT_MnMx[0]) + WAIT_MnMx[0])) {
							GONNA_GO = true;
							if (!ACC_SET)
								ACC_SET = true;
								waiting = 0;
						}
						anim_STATE = "IDLE";
					} else if (GONNA_GO) {
						
						if (justTouched(LEFT)) {
							setFacing(RIGHT, current_V);
						} else if (justTouched(RIGHT)) {
							setFacing(LEFT, current_V);
						}
						
						if (ACC_SET) {
							ACC_DIR = (Math.random() < 0.5 ? -1 : 1);
							this.acceleration.x = ACC_DIR * WALK_SPEED * 3;
							ACC_SET = false;
						}
						walking += FlxG.elapsed;
						if (walking >= (Math.random() * (WALK_MnMx[1] - WALK_MnMx[0]) + WALK_MnMx[0])) {
							GONNA_GO = false;
							this.acceleration.x = 0;
							walking = 0;
						}
						anim_STATE = "WALK";
					}
					
				}
			else {
				
			}
		} else {
				
		}
			
			animate(anim_STATE);
			super.update();
		}
		
		public function setFacing(newFacing:int, speed:int):void {
			facing = newFacing;
			_facing_sing = (facing == LEFT ? -1 : 1);
			this.acceleration.x = WALK_SPEED * _facing_sing * 3;
			this.velocity.x = speed * -1;
		}
		
		private function animate(STATE:String):void {
			switch(STATE) {
				case "IDLE": {
					anim = "idle";
					this.play(anim);
				}
					break;
				case "WALK": {
					anim = "walk";
					this.play(anim);
				}
			}
		}
		
	}

}