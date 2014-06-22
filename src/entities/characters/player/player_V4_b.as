package entities.characters.player 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author bottlecap
	 */
	
	 
	public class player_V4 extends FlxSprite 
	{
		[Embed(source = "../../../assets/images/spritesheet_1.png")] public static var SHEET:Class;
		
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
		
		//TIMERS
		public var timer:Number = 0;
		public var jumpTimer:Number = 0;
		public var timerGoal:Number = 0;
		public var suckEndTimer:Number = 0;
		
		public function player_V4(X:Number = 0, Y:Number = 0 ) 
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
			addAnimation("fallRUN", [17, 18, 19], 10, false);
			
			addAnimation("suckGROUND", [24, 25, 26, 27], 10, false);
			addAnimation("suckingGROUND", [26, 27], 10, true);
			addAnimation("suckingStopEmptyGROUND", [28, 12, 18], 10, false);
			addAnimation("suckingStopFULLGROUND", [28, 36, 37], 10, false);
			addAnimation("suckAIR", [29, 30, 31, 30], 10, true);
			addAnimation("suckingAIR", [31, 30], 10, true);
			addAnimation("suckingStopEmptyAIR", [29, 14, 0], 10, false);
			addAnimation("suckingStopFullAIR", [38, 39, 0], 10, false);
			
		}
		
		override public function update():void {
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
						if (isTouching(FLOOR)) {
							anim_ACTION = "RUN";
						}
						movement();
					}
					if (!LR) {
						this.acceleration.x = 0;
						if (isTouching(FLOOR) && MOV)
							anim_ACTION = "IDLE";
					}
					if (FlxG.keys.justPressed(JUMP_KEY) && isTouching(FLOOR))
						jump();
					if (jumpN != 0) {
						jumping();
					}
					if (FlxG.keys.justPressed(SUCK_KEY)) {
						SUCKING = true;
						MOV = false;
						LOCK = true;
						timer = 0;
					}
					
				}
				else if (LOCK) {
					
					if (isTouching(FLOOR))
						this.acceleration.x = 0;
					
					if (SUCKING) {
						if (FlxG.keys.pressed(SUCK_KEY)) {
							_SUCKING();
							//trace(anim);
							if (FlxG.keys.justReleased(SUCK_KEY)) {
								trace(timer);
								timer = 0;
							}
						}
						else {
							if (anim == "suckGROUND" || anim == "suckAIR") {
								SUCKING = false;
								LOCK = false;
								MOV = true;
								timer = 0;
							}
							else {
								suckEndTimer += FlxG.elapsed;
								anim_ACTION = "SUCKSTOP";
								if (suckEndTimer >= 0.3) {
									SUCKING = false;
									MOV = true;
									LOCK = false;
									suckEndTimer = 0;
								}
							}
						}
					}
					
				}
				
				if(!SUCKING){
					if (this.velocity.y > 0) {
						UFF = 0;
						anim_ACTION = "JUMP";
					}
				}
				
				if (justTouched(FLOOR))
					floorTOUCH();
				
				if (UFF != 0) {
					_UFF(UFF)
				}
			}
			else if (DEAD) {
				
			}
			//trace(SUCKING);
			
			//trace(anim);
			animate();
			super.update();
		}
		
		private function movement():void {
			if (facing == LEFT)
				this.acceleration.x = RUN_SPEED * 10;
			if (facing == RIGHT)
				this.acceleration.x = RUN_SPEED * -10;
		}
		
		private function _UFF(x:int):void {
			MOV = false;
			if (x == 1) {
				timer += FlxG.elapsed;
				anim_ACTION = "UFFR";
				if (timer >= 0.3 || JLR) {
					trace("DONE");
					MOV = true;
					timer = 0;
					UFF = 0;
				}
			}
			else if (x == 2) {
				timer += FlxG.elapsed;
				anim_ACTION = "UFFS";
				if (timer >= 0.2 || JLR) {
					trace("DONE");
					MOV = true;
					timer = 0;
					UFF = 0;
				}
			}
		}
		
		private function floorTOUCH():void {
			jumpN = 0;
			jumpTimer = 0;
			timer = 0;
			if(!SUCKING){
				if (this.velocity.x != 0)
					UFF = 1;
				if (this.velocity.x == 0)
					UFF = 2;
			}
		}
		
		private function jump():void {
			jumpN = 1;
			MOV = false;
			UFF = 0;
			this.velocity.y = -JUMP_SPEED;
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
			
			if (timer < 0.4) {
				timer += FlxG.elapsed;
				anim_ACTION = "SUCK";
			}
			if (timer >= 0.4) {
				anim_ACTION = "SUCKING";
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
					if (Math.abs(this.velocity.x) == RUN_SPEED)
						anim = "run";
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
					if(this.isTouching(FLOOR))
						anim = "suckGROUND";
					else
						anim = "suckAIR";
						
					this.play(anim_SUFIX(anim));
				}
					break;
				case "SUCKING": {
					if(this.isTouching(FLOOR))
						anim = "suckingGROUND";
					else
						anim = "suckingAIR";
					
					this.play(anim_SUFIX(anim));
				}
					break;
				case "SUCKSTOP": {
					if(this.isTouching(FLOOR))
						anim = "suckingStopEmptyGROUND";
					else
						anim = "suckingStopEmptyAIR";
						
					this.play(anim_SUFIX(anim));
				}
					break;
			}
			
			//trace(anim);
			
		}
		public function currentAnimation():String {
			if(this._curAnim){
			var anim:String = _curAnim['name'];
			
			return anim_SUFIX(anim);
			}
			
			return "";
		}
		
	}

}