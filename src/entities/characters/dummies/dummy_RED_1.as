package entities.characters.dummies 
{
	import entities.characters.player.floor_sensor;
	import org.flixel.*;
	import assets._nuke;
	import worlds.TestStage;
	import entities.particles.*;
	/**
	 * ...
	 * @author Sortpherich
	 */
	public class dummy_RED_1 extends FlxSprite
	{
		[Embed(source = "../../../assets/images/spritesheet_dummy_RED.png")] public var SHEET:Class;
		/** GENERAL VARs **/
		public var g:Number = 500;
		public var WALK_SPEED:int = 30;
		public var anim:String = "";
		protected var damageToPlayer:int = 3;
		protected var healing:int = 4;
		protected var JUMP_SPEED:int = 150;
		
		/** STATE VARs **/
		public var anim_STATE:String = "";
		protected var _facing_sing:int = 0;
		protected var current_V:Number = 0;
		protected var GONNA_GO:Boolean = false;
		protected var ACC_SET:Boolean = false;
		protected var ACC_DIR:int = 0;
		protected var DEAD:Boolean = false;
		protected var LOCK:Boolean = false;
		protected var WALK_MnMx:Array = new Array(3, 15);
		protected var WAIT_MnMx:Array = new Array(0.5, 3);
		protected var onPLATFORM:Boolean = true;
		protected var SUCKED:Boolean = false;
		protected var x_POS:int = 0;
		protected var y_POS:int = 0;
		protected var inRANGE:Boolean = false;
		protected var YR:Number = 0;
		protected var XR:Boolean = false;
		protected var inPURSUIT:Boolean = false;
		protected var YP:Number = 0;
		protected var XP:Number = 0;
		protected var P_s:int = 0;
		
		protected var sensor:floor_sensor = new floor_sensor(false);
		protected var sensor_up:floor_sensor = new floor_sensor(false);
		protected var sensor_down:floor_sensor = new floor_sensor(false);
		
		/** TIMER VARs **/
		protected var waiting:Number = 0;
		protected var WAIT:Number = 0;
		protected var walking:Number = 0;
		protected var WALK:Number = 0;
		
		public function dummy_RED_1(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			loadGraphic(SHEET, true, true, 11, 10);
			addAnimation("idle", [0], 10, true);
			addAnimation("walk", [1, 0], 10, true);
			addAnimation("jump", [1], 10, false);
			WAIT = (Math.random() * (WAIT_MnMx[1] - WAIT_MnMx[0]) + WAIT_MnMx[0]);
		}
		override public function update():void {
			
			/** INITIAL SETTINGS **/
			//sensor.x = x - width;
			//sensor.y = y + height - 1;
			FlxG.state.add(sensor);
			FlxG.state.add(sensor_up);
			FlxG.state.add(sensor_down);
			YR = Math.abs((this.y + height / 2) - (_nuke.mainPlayer.y + _nuke.mainPlayer.height / 2));
			XR = this.onScreen() && _nuke.mainPlayer.onScreen();
			YP = Math.abs((this.y + height / 2) - (_nuke.mainPlayer.y + _nuke.mainPlayer.height / 2));
			XP = Math.abs((this.x + width / 2) - (_nuke.mainPlayer.x + _nuke.mainPlayer.width / 2));
			if (YR <= 10 && XR)
				inRANGE = true;
			else
				inRANGE = false;
			inPURSUIT = (YP <= 20 && XP <= 75 && !_nuke.mainPlayer.DEAD) ? true : false;
			this.acceleration.y = g;
			this.maxVelocity.x = WALK_SPEED;
			this.drag.x = WALK_SPEED * 3;
			x_POS = (_nuke.mainPlayer.x - this.x) / Math.abs(_nuke.mainPlayer.x - this.x);
			y_POS = (_nuke.mainPlayer.y - this.y) / Math.abs(_nuke.mainPlayer.y - this.y);
			if (this.velocity.x != 0)
				current_V = this.velocity.x;
			if (inPURSUIT)
				current_V = 0;
				
			/** LOOP **/	
			if (!DEAD) {
				if (_nuke.mainPlayer._suckIND[0]) {
					if (inRANGE){
						if (_nuke.mainPlayer._suckIND[1]) {// && _POS < 0) {
							if (x_POS < 0){
								LOCK = true;
								SUCKED = true;
							} else {
								LOCK = false;
								SUCKED = false;
							}
						}
						if (!_nuke.mainPlayer._suckIND[1]) {// && _POS > 0) {
							if (x_POS > 0 ){
								LOCK = true;
								SUCKED = true;
							} else {
								LOCK = false;
								SUCKED = false;
							}
						}
					}
				} else {
					LOCK = false;
					SUCKED = false;
				}
				if (!LOCK) {
					if (this.velocity.x < 0)
						facing = LEFT;
					if (this.velocity.x > 0)
						facing = RIGHT;
					if (facing == LEFT) {
						sensor.x = x - 10;
						sensor.y = y + height / 2;
						sensor_up.x = x - 10;
						sensor_up.y = y - 10;
						sensor_down.x = x - 10;
						sensor_down.y = y + height + 10;
					}
					if (facing == RIGHT) {
						sensor.x = x + width - 1 + 10;
						sensor.y = y + height / 2;
						sensor_up.x = x + width - 1 + 10;
						sensor_up.y = y - 10;
						sensor_down.x = x + width - 1 + 10;
						sensor_down.y = y + height + 10;
					}
					if (inPURSUIT) {
						waiting = 0;
						walking = 0;
						GONNA_GO = true;
					}
					if (!GONNA_GO && isTouching(FLOOR)) {
						waiting += FlxG.elapsed;
						if (waiting >= WAIT) {
							GONNA_GO = true;
							if (!ACC_SET)
								ACC_SET = true;
								waiting = 0;
							WALK = (Math.random() * (WALK_MnMx[1] - WALK_MnMx[0]) + WALK_MnMx[0]);
						}
						anim_STATE = "IDLE";
					} 
					if (GONNA_GO) {
						
						if (!inPURSUIT && isTouching(FLOOR)) {
							if (justTouched(LEFT) || isTouching(LEFT)) {
								if (!(sensor_up.overlaps(_nuke.TILE_MAP)))
									jump()
								else
									setFacing(RIGHT, current_V);
							} else if (justTouched(RIGHT) || isTouching(RIGHT)) {
								if (!(sensor_up.overlaps(_nuke.TILE_MAP)))
									jump()
								else
									setFacing(LEFT, current_V);
							} 
							if (onPLATFORM) {
								if (facing == LEFT) {
									if (!(overlapsAt(this.x - width, this.y + 1, _nuke.TILE_MAP) || overlapsAt(this.x - width, this.y + 1, _nuke.TILE_MAP4)) && !(sensor_down.overlaps(_nuke.TILE_MAP))) {
										
										FlxG.log("turn mffcker");
										setFacing(RIGHT, current_V);
										
									}
								} else if (facing == RIGHT) {
									if (!(overlapsAt(this.x + width , this.y + 1, _nuke.TILE_MAP) || overlapsAt(this.x + width, this.y + 1, _nuke.TILE_MAP4)) && !(sensor_down.overlaps(_nuke.TILE_MAP))) {
										
										FlxG.log("turn mffcker");
										setFacing(LEFT, current_V);
									}
								}
							}
							if (ACC_SET) {
								ACC_DIR = (Math.random() < 0.5 ? -1 : 1);
								this.acceleration.x = ACC_DIR * WALK_SPEED * 3;
								ACC_SET = false;
							}
							walking += FlxG.elapsed;
							if (walking >= WALK) {
								GONNA_GO = false;
								this.acceleration.x = 0;
								walking = 0;
								WAIT = (Math.random() * (WAIT_MnMx[1] - WAIT_MnMx[0]) + WAIT_MnMx[0]);
							}
						} else if (inPURSUIT) {
							if (facing == LEFT && isTouching(FLOOR)) {
								if(sensor.overlaps(_nuke.TILE_MAP) && !sensor_up.overlaps(_nuke.TILE_MAP)){
									jump();
								}
								if (!(overlapsAt(this.x - width, this.y + 1, _nuke.TILE_MAP) || overlapsAt(this.x - width, this.y + 1, _nuke.TILE_MAP4)) && !(sensor_down.overlaps(_nuke.TILE_MAP))) {
									jump();
								}
							}
							if (facing == RIGHT && isTouching(FLOOR)) {
								if(sensor.overlaps(_nuke.TILE_MAP) && !sensor_up.overlaps(_nuke.TILE_MAP)){
									jump();
								}
								if (!(overlapsAt(this.x + width , this.y + 1, _nuke.TILE_MAP) || overlapsAt(this.x + width, this.y + 1, _nuke.TILE_MAP4)) && !(sensor_down.overlaps(_nuke.TILE_MAP))) {
									jump();
								}
							}
							if (((sensor.overlaps(_nuke.TILE_MAP4) && !sensor_up.overlaps(_nuke.TILE_MAP4)) || sensor_up.overlaps(_nuke.TILE_MAP4)) && y_POS < 0)
								if (isTouching(FLOOR))
									jump();
							this.acceleration.x = x_POS * WALK_SPEED * 9;
							this.maxVelocity.x = WALK_SPEED * 3;
						}
						anim_STATE = "WALK";
					}
					
					if (overlaps(_nuke.mainPlayer) && !_nuke.mainPlayer.IMUNE && !_nuke.mainPlayer.DEAD) {
						_nuke.mainPlayer.damagePlayer(damageToPlayer);
					}
					
					if (!isTouching(FLOOR)) {
						anim_STATE = "JUMP";
					}
				}
			else {
				if (SUCKED) {
					this.acceleration.x = x_POS * 500;
					this.maxVelocity.x = 500;
					if (overlaps(_nuke.mainPlayer))//if (overlapsAt(this.x + width / 2, this.y + height / 2, _nuke.mainPlayer))
						_FILL();
					anim_STATE = "IDLE";
				}
			}
			
		} else {
				
		}
		 
			animate(anim_STATE);
			super.update();
		}
		private function setFacing(newFacing:int, speed:int):void {
			facing = newFacing;
			_facing_sing = (facing == LEFT ? -1 : 1);
			this.acceleration.x = WALK_SPEED * _facing_sing * 3;
			this.velocity.x = speed * -1;
		}
		private function jump():void {
			this.velocity.y = -JUMP_SPEED;
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
					break;
				case "JUMP": {
					anim = (this.velocity.y < 0) ? "jump" : "idle";
					this.play(anim);
				}
					break;
			}
		}
		private function _FILL():void {
			_nuke.mainPlayer.FULL = true;
			_nuke.mainPlayer._TO_HEAL = healing;
			_nuke.mainPlayer.timer = 0;
			this.kill();
		}
	}

}