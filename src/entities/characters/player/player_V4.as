package entities.characters.player 
{
	import org.flixel.*;
	import assets._nuke;
	import entities.particles.*;
	import worlds.TestStage;
	/**
	 * ...
	 * @author bottlecap
	 */
	
	 
	public class player_V4 extends FlxSprite 
	{
		[Embed(source = "../../../assets/images/Spritesheet_2.png")] public static var SHEET:Class;
		
		public var g:Number = 500;
		public var RUN_SPEED:int = 70;
		public var JUMP_SPEED:int = 230;
		public var anim:String = "";
		public var jumpN:int = 0;
		public var FALL:int = 0;
		
		//CONTROLS
		public var JUMP_KEY:String = "X";
		public var SUCK_KEY:String = "C";
		public var action:Array;
		
		//STATES
		public var LOCK:Boolean = false;
		public var MOV:Boolean = true;
		public var SUCKING:Boolean = false;
		public var FULL:Boolean = false;
		public var DEAD:Boolean = false;
		public var ACTION_ID:int = 0;
		public var LR:Boolean = false;
		public var JLR:Boolean = false;
		public var B:Boolean = false;
		public var anim_ACTION:String = "";
		public var UFF:int = 0;
		public var fallTHR:Boolean = false;
		public var _suckIND:Array = new Array(false, null);
		public var FALL_V:Number = 0;
		
		
		//TIMERS
		public var timer:Number = 0;
		public var jumpTimer:Number = 0;
		public var fallTimer:Number = 0;
		
		//PARTICLES
		public var dust_emtr:emitterUNI;
		public var GROOP:FlxGroup = new FlxGroup();
		
		public function player_V4(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			loadGraphic(SHEET, true, true, 11, 18);
			
			addAnimation("idle", [0], 8, false);
			addAnimation("run", [2, 3, 3, 4, 4, 5, 5, 6, 7, 7, 8, 8, 9, 9, 9], 20, true);
			addAnimation("tranA", [1], 10, false);
			addAnimation("tranB", [10, 11], 10, false);
			addAnimation("jumpDOWN", [15, 16], 10, false);
			addAnimation("DOWN", [16], 10, true);
			addAnimation("jumpUP", [13, 14], 10, false);
			addAnimation("jumpTR", [12], 10, true);
			addAnimation("fallSTILL", [17, 18], 10, false);
			addAnimation("fallRUN", [17, 19], 10, false);
			addAnimation("break", [20], 10, false);
			
			addAnimation("suckGROUND", [24, 25, 25], 20, false);
			addAnimation("suckingGROUND", [26, 27], 10, true);
			addAnimation("suckingStopEmptyGROUND", [28, 12, 18], 10, false);
			addAnimation("suckingStopFULLGROUND", [28, 36, 37], 10, false);
			addAnimation("suckAIR", [29, 30, 31], 10, true);
			addAnimation("suckingAIR", [30, 31], 10, true);
			addAnimation("suckingStopEmptyAIR", [29, 14], 10, false);
			addAnimation("suckingStopFullAIR", [38, 39], 10, false);
			
			dust_emtr = new emitterUNI(this.x, this.y, dust_particle, 100, 500, -30, 30, -50, -200, 0, 0);
			TestStage.GROOP.add(dust_emtr);
		}
		
		override public function update():void {
			/* * INITIAL CONDITIONS * */
			dust_emtr.at(this);
			this.acceleration.y = g;
			this.drag.x = RUN_SPEED * 5;
			this.maxVelocity.x = RUN_SPEED
			width = 7;
			height = 9;
			offset.x = 2;
			offset.y = 9;
			if (FlxG.keys.RIGHT)
				facing = LEFT;
			if (FlxG.keys.LEFT)
				facing = RIGHT;
			
			/* * GAME LOOP * */
			
			if (!DEAD) {
				if (FlxG.keys.LEFT || FlxG.keys.RIGHT)
					LR = true;
				else
					LR = false;
				if (FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("RIGHT") || FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT"))
					JLR = true;
				else
					JLR = false;
					
				if (!LOCK) {
					if (LR) {
						MOV = true;
						if (isTouching(FLOOR) && MOV) 
							anim_ACTION = "RUN";
						movement();
					}
					if (!LR) {
						this.acceleration.x = 0;
						if (isTouching(FLOOR) && MOV)
							anim_ACTION = "IDLE";
					}
					if (FlxG.keys.justPressed(SUCK_KEY)) {
						SUCKING = true;
						MOV = false;
						LOCK = true;
						timer = 0;
					}
					
				}
				else if (LOCK) {
					if (SUCKING) {
						stop();
						if (FlxG.keys.justReleased(SUCK_KEY))
							timer = 0;
						if (FlxG.keys.pressed(SUCK_KEY)) {
							_SUCKING();
						}
						else {
							if (anim == "suckGROUND") {
								SUCKING = false;
								LOCK = false;
								MOV = true;
								timer = 0;
							}
							else {
								timer += FlxG.elapsed;
								anim_ACTION = "SUCKSTOP";
								if (timer >= 0.3 || JLR || LR || (FlxG.keys.justPressed(JUMP_KEY) && isTouching(FLOOR))) {
									SUCKING = false;
									MOV = true;
									LOCK = false;
									timer = 0;
									UFF = 0;
									if (FlxG.keys.justPressed(JUMP_KEY))
										jump();
								}
							}
						}
						/*_suckIND[0] = FlxG.keys.pressed(SUCK_KEY);
						if (facing == LEFT)
							_suckIND[1] = true;
						else
							_suckIND[1] = false;*/
						//trace(_suckIND[0], _suckIND[1]);
					}
					
				}
				if (this.velocity.y > 0) {
					UFF = 0;
					MOV = false;
					if (!SUCKING)
						anim_ACTION = "JUMP";
					FALL_V = this.velocity.y;
				}
				if (justTouched(FLOOR)) {
					floorTOUCH();
				}
				if (FlxG.keys.justPressed(JUMP_KEY) && isTouching(FLOOR)) {
					if (!LOCK) {
						if (!FlxG.keys.DOWN)
							jump();
						else
							fallTHR = true;
					}
				}
				if (jumpN != 0 && !LOCK) {
					jumping();
				}
				if (UFF != 0 && !SUCKING) {
					_UFF(UFF)
				}
				if (fallTHR) {
					_nuke.TILE_MAP4 .setTileProperties(12, FlxObject.NONE, null, null, 63);
					fallTimer += FlxG.elapsed;
					if (fallTimer >= 0.25) {
						fallTimer = 0;
						_nuke.TILE_MAP4 .setTileProperties(12, FlxObject.UP, null, null, 63);
						fallTHR = false;
					}
				}
				
			}
			else if (DEAD) {
				
			}
			//trace(x, y);
			animate();
			super.update();
		}
		
		private function dustEM_ST(explode:Boolean, life:int, Hz:Number, MODE:String = "DEFAULT"):void {
			var QW:int = 0;
			switch(MODE) {
				case "JUMP": {
					dust_emtr.setXSpeed( -30, 30);
					dust_emtr.setYSpeed( -30, -200);
					QW = 5;
				}
					break;
				case "FALL": {
					dust_emtr.setXSpeed( -50, 50);
					dust_emtr.setYSpeed( -50, -150);
					dust_emtr.y = this.y + 9;
					QW = 7;
				}
					break;
				case "DEFAULT": {
					dust_emtr.setXSpeed( -50, 50);
					dust_emtr.setYSpeed( -50, -500);
					QW = 3;
				}
			}
			dust_emtr.start(explode, life, Hz, QW);
		}
		
		private function stop():void {
			this.acceleration.x = 0;
		}
		
		private function movement():void {
			if (facing == LEFT)
				this.acceleration.x = RUN_SPEED * 10;
			if (facing == RIGHT)
				this.acceleration.x = RUN_SPEED * -10;
		}
		
		private function _UFF(x:int):void {
			MOV = false;
			timer += FlxG.elapsed;
			if (x == 1)
				anim_ACTION = "UFFR";
			else if (x == 2)
				anim_ACTION = "UFFS";
			if (timer >= 0.2 || JLR) {
				MOV = true;
				timer = 0;
				UFF = 0;
			}
		}
		
		private function floorTOUCH():void {
			jumpN = 0;
			jumpTimer = 0;
			MOV = false;
			if (!SUCKING) {
				timer = 0;
				if (LR)
					UFF = 1;
				if (!LR)
					UFF = 2;
			}
			if (FALL_V > 200) {
				dustEM_ST(true, 5, 0.01, "FALL");
				FALL_V = 0;
			}
		}
		
		private function jump():void {
			jumpN = 1;
			MOV = false;
			UFF = 0;
			this.velocity.y = -JUMP_SPEED;
			dustEM_ST(true, 5, 0.01, "JUMP");
		}
		
		private function jumping():void {
			anim_ACTION = "JUMP";
			if (FlxG.keys.pressed(JUMP_KEY)) {
				jumpTimer += FlxG.elapsed;
			}
			if (FlxG.keys.justReleased(JUMP_KEY)) {
				if (this.velocity.y < 0)
					this.velocity.y /= 2.0 - jumpTimer;
			}
		}
		
		private function _SUCKING():void {
			if (timer < 0.15) {
				timer += FlxG.elapsed;
				anim_ACTION = "SUCK";
			}
			if (timer >= 0.15) {
				anim_ACTION = "SUCKING";
				_suckIND[0] = SUCKING;
				_suckIND[1] = facing == LEFT;
			}
		}
		
		private function anim_SUFIX(x:String):String {
			var F:String = "";
			if (FULL)
				anim = anim + "_FULL";
			F = anim;
			return F;
		}
		
		private function animate():void {
			
			switch (anim_ACTION) {
				case "IDLE": {
					if (Math.abs(this.velocity.x) < RUN_SPEED)
						anim = "tranB";
					if (this.velocity.x == 0)
						anim = "idle";
					this.play(anim_SUFIX(anim));
				}
					break;
				case "RUN": {
					if (Math.abs(this.velocity.x) < RUN_SPEED)
						anim = "tranA";
					if (Math.abs(this.velocity.x) == RUN_SPEED) {
						var t:int = 0;
						if (facing == RIGHT)
							t = 1;
						else 
							t = -1;
						anim = "run";
					}
					if (this.velocity.x == 0)
						anim = "idle";
					if (this.velocity.x / this.acceleration.x < 0) {
						
						anim = "break";
					}
					this.play(anim_SUFIX(anim));
				}
					break;
				case "JUMP": {
					if (this.velocity.y < 0)
						if (anim != "jumpUP") {
							anim = "jumpUP";
							this.play(anim_SUFIX(anim));
						}
					if (this.velocity.y >= 0)
						if (anim != "jumpDOWN") {
							anim = "jumpDOWN";
							this.play(anim_SUFIX(anim));
						}
				}
					break;
				case "UFFR": {
					anim = "fallRUN";
					this.play(anim_SUFIX(anim));
				}
					break;
				case "UFFS": {
					anim = "fallSTILL";
					this.play(anim_SUFIX(anim));
				}
					break;
				case "SUCK": {
					anim = "suckGROUND";
					this.play(anim_SUFIX(anim));
				}
					break;
				case "SUCKING": {
					anim = "suckingGROUND";
					this.play(anim_SUFIX(anim));
				}
					break;
				case "SUCKSTOP": {
					anim = "suckingStopEmptyGROUND";
					this.play(anim_SUFIX(anim));
				}
					break;
			}
		}
		
	}

}