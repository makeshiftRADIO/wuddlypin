package entities.characters.dummies 
{
	import assets._nuke;
	import entities.particles.*;
	import org.flixel.*;
	import worlds.TestStage;
	
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
		protected var damageToPlayer:int = 1;
		protected var healing:int = 2;
		
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
		protected var _POS:int = 0;
		protected var inRANGE:Boolean = false;
		protected var YR:Number = 0;
		protected var XR:Boolean = false;
		
		/** TIMER VARs **/
		protected var waiting:Number = 0;
		protected var WAIT:Number = 0;
		protected var walking:Number = 0;
		protected var WALK:Number = 0;
		
		public function dummy_1(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			loadGraphic(SHEET, true, true, 9, 8);
			addAnimation("idle", [0], 1, true);
			addAnimation("walk", [1, 0], 10, true);
			WAIT = (Math.random() * (WAIT_MnMx[1] - WAIT_MnMx[0]) + WAIT_MnMx[0]);
		}
		
		override public function update():void {
			/** INITIAL SETTINGS **/
			YR = Math.abs((this.y + height / 2) - (_nuke.mainPlayer.y + _nuke.mainPlayer.height / 2));
			XR = this.onScreen() && _nuke.mainPlayer.onScreen();
			if (YR <= 10 && XR)
				inRANGE = true;
			else
				inRANGE = false;
			this.acceleration.y = g;
			this.maxVelocity.x = WALK_SPEED;
			this.drag.x = WALK_SPEED * 3;
			_POS = (_nuke.mainPlayer.x - this.x) / Math.abs(_nuke.mainPlayer.x - this.x);
			if (this.velocity.x != 0)
				current_V = this.velocity.x;
				
			/** LOOP **/	
			if (!DEAD) {
				if (_nuke.mainPlayer._suckIND[0]) {
					if (inRANGE){
						if (_nuke.mainPlayer._suckIND[1]) {// && _POS < 0) {
							if (_POS < 0){
								LOCK = true;
								SUCKED = true;
							} else {
								LOCK = false;
								SUCKED = false;
							}
						}
						if (!_nuke.mainPlayer._suckIND[1]) {// && _POS > 0) {
							if (_POS > 0 ){
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
					if (!GONNA_GO) {
						waiting += FlxG.elapsed;
						if (waiting >= WAIT) {
							GONNA_GO = true;
							if (!ACC_SET)
								ACC_SET = true;
								waiting = 0;
							WALK = (Math.random() * (WALK_MnMx[1] - WALK_MnMx[0]) + WALK_MnMx[0]);
						}
						anim_STATE = "IDLE";
					} else if (GONNA_GO) {
						
						if (justTouched(LEFT)) {
							setFacing(RIGHT, current_V);
						} else if (justTouched(RIGHT)) {
							setFacing(LEFT, current_V);
						} else if (onPLATFORM) {
							if (facing == LEFT) {
								if (!(overlapsAt(this.x - width, this.y + height + 1, _nuke.TILE_MAP) || overlapsAt(this.x - width, this.y + height + 1, _nuke.TILE_MAP4))) {
									setFacing(RIGHT, current_V);
								}
							} else if (facing == RIGHT) {
								if (!(overlapsAt(this.x + width , this.y + height + 1, _nuke.TILE_MAP) || overlapsAt(this.x + width, this.y + height + 1, _nuke.TILE_MAP4))) {
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
						anim_STATE = "WALK";
					}
					
					if (overlaps(_nuke.mainPlayer) && !_nuke.mainPlayer.IMUNE && !_nuke.mainPlayer.DEAD) {
						_nuke.mainPlayer.damagePlayer(damageToPlayer);
					}
				}
			else {
				if (SUCKED) {
					this.acceleration.x = _POS * 500;
					this.maxVelocity.x = 1000;
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
		
		private function _FILL():void {
			_nuke.mainPlayer.FULL = true;
			_nuke.mainPlayer._TO_HEAL = healing;
			_nuke.mainPlayer.timer = 0;
			this.kill();
		}
		
	}

}