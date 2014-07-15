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
		[Embed(source = "../../../assets/images/Spritesheet_4.png")] public static var SHEET:Class;
		
		public var g:Number = 500;
		public var RUN_SPEED:int = 70;
		public var JUMP_SPEED:int = 230;
		public var anim:String = "";
		public var jumpN:int = 0;
		public var FALL:int = 0;
		
		//CONTROLS
		public var JUMP_KEY:String = "X";
		public var SUCK_KEY:String = "C";
		public var CHEW_KEY:String = "V";
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
		public var SPIT:Boolean = false;
		public var SPIT_thrust:Boolean = false;
		public var CHEW:Boolean = false;
		public var CHEW_splat:int = 0;
		public var IMUNE:Boolean = false;
		
		
		//TIMERS
		public var timer:Number = 0;
		public var jumpTimer:Number = 0;
		public var fallTimer:Number = 0;
		
		//PARTICLES
		public var dust_emtr:emitterUNI;
		public var chunk_emtr:emitterUNI;
		
		//SENSOR
		public var sensors_on:Boolean = false;
		public var floor_sensor_var:floor_sensor = new floor_sensor;
		//CURRENT STAGE
		public var _CURRENT_STAGE:Class = TestStage;

		
		public function player_V4(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			loadGraphic(SHEET, true, true, 11, 18);
			
			addAnimation("idle", [0], 8, false);
			addAnimation("run", [2, 3, 3, 4, 4, 5, 5, 6, 7, 7, 8, 8, 9, 9], 20, true);
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
			addAnimation("suckingStopGROUND", [28, 12, 18], 10, false);
			addAnimation("suckingStopGROUND_FULL", [28, 36, 37], 10, false);
			addAnimation("spit_FULL", [65, 66, 66, 66, 18, 18], 20, false);
			addAnimation("chew_FULL", [72, 73, 74, 75, 75, 76, 77, 78, 79, 78, 77, 80, 81, 82, 82, 18], 10, false);
			
			addAnimation("idle_FULL", [48], 8, false);
			addAnimation("run_FULL", [50, 51, 51, 52, 52, 53, 53, 54, 55, 55, 56, 56, 57, 57], 20, true);
			addAnimation("tranA_FULL", [49], 10, false);
			addAnimation("tranB_FULL", [58, 59], 10, false);
			addAnimation("jumpDOWN_FULL", [62, 63], 10, false);
			addAnimation("jumpUP_FULL", [60, 61], 10, false);
			addAnimation("fallSTILL_FULL", [36, 37], 10, false);
			addAnimation("fallRUN_FULL", [36, 64], 10, false);
			addAnimation("break_FULL", [83], 10, false);
			
			addAnimation("death", [24, 84, 84, 85, 85, 86, 86, 87, 88, 88, 89, 90, 90, 91, 90, 91, 90, 91, 92, 93, 93], 10, false);
			
			dust_emtr = new emitterUNI(this.x, this.y, dust_particle, 100, 500);// , -30, 30, -50, -200, 0, 0);
			chunk_emtr = new emitterUNI(this.x, this.y, dummyChunk_particles, 100, 500);
			
			
			TestStage.GROOP.add(dust_emtr);
			TestStage.GROOP.add(chunk_emtr);
			
			//gui.updateGUI("HEALTH");
		}
		
		override public function update():void {
					
			if(!sensors_on){
				FlxG.state.add(floor_sensor_var);
				sensors_on = true;
			}
			
			update_sensors();
			
			/* * INITIAL CONDITIONS * */
			IMUNE = flickering ? true : false;
			if (FlxG.keys.justPressed("U")) {
				trace("C");
				FULL = true;
			}
			if (FlxG.keys.justPressed("W")) {
				gui.updateGUI("HEALTH");
			}
			if (FlxG.keys.justPressed("E")){
				if (FlxG.keys.SHIFT) {
					_nuke._PLAYER_MAX_HEALTH--;
					if (_nuke._PLAYER_MAX_HEALTH * 10 < _nuke._PLAYER_HEALTH) {
						_nuke._PLAYER_HEALTH = _nuke._PLAYER_MAX_HEALTH * 10;//_MAX_HEALTH * 10;;
					}
				}
				else {
					_nuke._PLAYER_MAX_HEALTH++;
					_nuke._PLAYER_HEALTH = _nuke._PLAYER_MAX_HEALTH * 10;
				}
				//_nuke._PLAYER_HEALTH = _MAX_HEALTH * 10;
				gui.updateGUI("HEALTH");
			}
			if (FlxG.keys.justPressed("Q") && !IMUNE) {
				if (FlxG.keys.SHIFT)
					healPlayer(1);
				else
					damagePlayer(1);
			}
			dust_emtr.at(this);
			chunk_emtr.at(this);
			this.acceleration.y = g;
			this.drag.x = RUN_SPEED * 5;
			this.maxVelocity.x = RUN_SPEED
			width = 7;
			height = 9;
			offset.x = 2;
			offset.y = 9;
			
			/* * GAME LOOP * */
			
			if (!DEAD) {
				if (FlxG.keys.RIGHT)
					facing = LEFT;
				if (FlxG.keys.LEFT)
					facing = RIGHT;
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
					if (FlxG.keys.justPressed(SUCK_KEY) && !FULL) {
						SUCKING = true;
						MOV = false;
						LOCK = true;
						timer = 0;
					} else if (FlxG.keys.justPressed(SUCK_KEY) && FULL) {
						SPIT = true;
						_nuke.colideParticles.add(new spit_chunk(this.x, this.y, this.facing));
						SPIT_thrust = true;
						MOV = false;
						LOCK = true;
						timer = 0;
					}
					if (FULL && FlxG.keys.justPressed(CHEW_KEY)) {
						CHEW = true;
						MOV = false;
						LOCK = true;
						CHEW_splat = 2;
						timer = 0;
					}
					
					
				}
				else if (LOCK) {
					stop();
					if (SUCKING) {
						if (!FULL){
							if (FlxG.keys.justReleased(SUCK_KEY) && !FULL)
								timer = 0;
							if (FlxG.keys.pressed(SUCK_KEY)) {
								_SUCKING();
							}
							else {
								_suckIND[0] = false;
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
						} 
						if (FULL) {
							timer += FlxG.elapsed;
							anim_ACTION = "SUCKSTOP";
							if (timer >= 0.3) {
								SUCKING = false;
								MOV = true;
								LOCK = false;
								timer = 0;
							}
						}
					}
					if (SPIT) {
						timer += FlxG.elapsed;
						anim_ACTION = "SPIT";
						if (_curIndex == 66 && anim_ACTION == "SPIT") {
							if (SPIT_thrust) {
								this.velocity.x = facing == LEFT ? -100 : 100;
								SPIT_thrust = false;
							}
						}
						if (timer >= 0.30) {
							SPIT = false;
							MOV = true;
							LOCK = false;
							FULL = false;
							timer = 0;
						}
					} else if (CHEW) {
						timer += FlxG.elapsed;
						anim_ACTION = "CHEW";
						if (timer >= 1.6) {
							CHEW = false;
							MOV = true;
							LOCK = false;
							FULL = false;
							healPlayer(2);
							timer = 0;
						}
						if (_curIndex == 75) {
							if (CHEW_splat == 2) {
								emitterMNG(chunk_emtr, true, 5, 0.01, "CHEW");
								--CHEW_splat;
							}
						} else if (_curIndex == 82) {
							if (CHEW_splat == 1) {
								emitterMNG(chunk_emtr, true, 5, 0.01, "CHEW");
								--CHEW_splat;
							}
						}
					}
				}
				if (this.velocity.y > 0) {
					UFF = 0;
					MOV = false;
					if (!LOCK)
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
				if (UFF != 0 && !LOCK) {
					_UFF(UFF)
				}
				if (fallTHR) {
					
					if (floor_sensor_var.overlaps(_nuke.TILE_MAP4) && !LR )
						_nuke.mainPlayer.solid = false;
						
					
					fallTimer += FlxG.elapsed;
					if (fallTimer >= 0.1281) {
						_nuke.mainPlayer.solid = true;
						fallTimer = 0;
						_nuke.TILE_MAP4 .setTileProperties(12, FlxObject.UP, null, null, 63);
						fallTHR = false;
					}
				}
				if (_nuke._PLAYER_HEALTH <= 0) {
					DEAD = true;
				}
				
			}
			else if (DEAD) {
				stop();
				anim_ACTION = "DEATH";
				if (FlxG.keys.justPressed("R")) {
					DEAD = false;
					_nuke._PLAYER_HEALTH = _nuke._PLAYER_MAX_HEALTH * 10;
					gui.updateHealth(_nuke._PLAYER_HEALTH, _nuke._PLAYER_MAX_HEALTH);
				}
			}
			animate();
			_suckIND[0] = anim_ACTION == "SUCKING";
			//trace(_suckIND[0]);
			super.update();
		}
		
		public function damagePlayer(damage:int):void {
			_nuke._PLAYER_HEALTH -= damage * 5;
			if (_nuke._PLAYER_HEALTH < 0)
				_nuke._PLAYER_HEALTH = 0;
			this.flicker(1);
			gui.updateHealth(_nuke._PLAYER_HEALTH, _nuke._PLAYER_MAX_HEALTH);
		}
		public function healPlayer(amount:int):void {
			_nuke._PLAYER_HEALTH += amount * 5;
			if (_nuke._PLAYER_HEALTH > _nuke._PLAYER_MAX_HEALTH * 10)
				_nuke._PLAYER_HEALTH = _nuke._PLAYER_MAX_HEALTH * 10;
			gui.updateHealth(_nuke._PLAYER_HEALTH, _nuke._PLAYER_MAX_HEALTH);
		}
		
		private function emitterMNG(EMTR:FlxEmitter, explode:Boolean, life:int, Hz:Number, MODE:String = "DEFAULT"):void {
			var QW:int = 0;
			switch(MODE) {
				case "JUMP": {
					EMTR.setXSpeed( -30, 30);
					EMTR.setYSpeed( -30, -200);
					EMTR.setRotation(0, 0);
					QW = 5;
				}
					break;
				case "FALL": {
					EMTR.setXSpeed( -50, 50);
					EMTR.setYSpeed( -50, -150);
					EMTR.setRotation(0, 0);
					EMTR.y = this.y + 9;
					QW = 7;
				}
					break;
				case "CHEW": {
					EMTR.setXSpeed( -50, 50);
					EMTR.setYSpeed( -30, -100);
					EMTR.setRotation(0, 0);
					EMTR.y = this.y + 7;
					QW = 7;
				}
					break;
				case "DEFAULT": {
					EMTR.setXSpeed( -50, 50);
					EMTR.setYSpeed( -50, -500);
					QW = 3;
				}
					break;
			}
			EMTR.start(explode, life, Hz, QW);
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
			if (!LOCK) {
				timer = 0;
				if (LR)
					UFF = 1;
				if (!LR)
					UFF = 2;
			}
			if (FALL_V > 200) {
				emitterMNG(dust_emtr, true, 5, 0.01, "FALL");
				if (FALL_V >= 350)
					damagePlayer(2);
				FALL_V = 0;
			}
		}
		
		private function jump():void {
			jumpN = 1;
			MOV = false;
			UFF = 0;
			this.velocity.y = -JUMP_SPEED;
			emitterMNG(dust_emtr, true, 5, 0.01, "JUMP");
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
				//_suckIND[0] = SUCKING;
				_suckIND[1] = facing == LEFT;
			}
		}
		
		private function anim_SUFIX(x:String):String {
			var F:String = "";
			F = x;
			if (FULL)
				F = F + "_FULL";
			if (DEAD)
				F = x;
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
					anim = "suckingStopGROUND";
					this.play(anim_SUFIX(anim));
				}
					break;
				case "SPIT": {
					anim = "spit";
					this.play(anim_SUFIX(anim));
				}
					break;
				case "CHEW": {
					anim = "chew";
					this.play(anim_SUFIX(anim));
				}
					break;
				case "DEATH": {
					if (anim != "death") {
						anim = "death";
						this.play(anim_SUFIX(anim));
					}
				}
					break;
			}
		}
		
		private function update_sensors():void {
				
			floor_sensor_var.x = this.x;
		
		}
		
	}

}