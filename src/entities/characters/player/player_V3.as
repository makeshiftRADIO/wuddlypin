package entities.characters.player 
{
	/**
	 * ...
	 * @author bottlecap
	 */
	 
	 import org.flixel.*;
	 import assets._nuke;
	 
	public class player_V3 extends FlxSprite
	{
		[Embed(source = "../../../assets/images/spritesheet_1.png")] public static var SHEET:Class;
		
		public static var RUN_SPEED:int = 70;
		public var JUMP_SPEED:int = 230;
		public var g:Number = 500;
		public var anim:String = "";
		public var jumpN:int = 0;
		public var FALL:int = 0;
		
		//CONTROLS
		public var JUMP_KEY:String = "X";
		public var SUCK_KEY:String = "C";
		public var action:Array;
		
		//STATES
		public var LOCK:Boolean = false;
		public var MOV:Boolean = false;
		public var SUCKING:Boolean = false;
		public var FULL:Boolean = false;
		public var DEAD:Boolean = false;
		public var ACTION_ID:int = 0;
		public var LR:Boolean = false;
		public var B:Boolean = false;
		
		//TIMERS
		public var timer:Number = 0;
		public var jumpTimer:Number = 0;
		
		
		public function player_V3(X:Number = 0, Y:Number = 0) 
		{
			super(X, Y);
			loadGraphic(SHEET, true, true, 11, 18);
			
			addAnimation("idle", [0], 8, false);
			addAnimation("run", [2, 3, 3, 4, 4, 5, 5, 6, 7, 7, 8, 8, 9, 9, 9], 20, true);
			addAnimation("tranA", [1], 10, false);
			addAnimation("tranB", [10, 11], 10, false);
			addAnimation("jumpDOWN", [15, 16, 16, 16, 16, 16], 10, false);
			addAnimation("DOWN", [16], 10, true);
			addAnimation("jumpUP", [13, 14], 10, false);
			addAnimation("jumpTR", [12], 10, true);
			addAnimation("fallSTILL", [17, 18], 10, false);
			addAnimation("fallRUN", [17, 18, 19], 10, false);
			
			addAnimation("suckGROUND", [24, 25, 26, 27], 10, false);
			addAnimation("suckingGROUND", [26, 27], 10, true);
			addAnimation("suckingStopEmptyGROUND", [28, 12, 18], 10, false);
			addAnimation("suckingStopFULLGROUND", [28, 36, 37], 10, false);
			addAnimation("suckAIR", [29, 30, 31], 10, true);
			addAnimation("suckingAIR", [30, 31], 10, true);
			addAnimation("suckingStopEmptyAIR", [29, 14], 10, false);
			addAnimation("suckingStopFullAIR", [38, 39], 10, false);
			
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
				if (!LOCK) {
					if (LR) {
						this.drag.x = 0;
						movement(this.velocity.x, RUN_SPEED * 14, RUN_SPEED);
					}
					else this.acceleration.x = 0;
					//animate();
					
					if (FlxG.keys.justPressed(JUMP_KEY)) {
						this.velocity.y = -JUMP_SPEED;
						action = [0,1];
					}
				}
				else if (LOCK) {
					
				}
				if (justTouched(FLOOR)) {
					jumpTimer = 0;
					if (this.velocity.x != 0) {
						jumpN = 3;
					}
					else if (this.velocity.x == 0) {
						jumpN = 2;
					}
				}
			 
			}
			else if (DEAD) {
				
			}
			
			animate();
			if(action != null)
				actions(action);
				
			super.update();
		}
		
		private function animSUFIX(x:String):String {
			var F:String = "";
			if (FULL)
				anim = anim + "_FULL";
			F = anim;
			return F;
		}
		
		private function actions(actionList:Array):void {
			
			//trace(actionList.length);
			//controls
			//movement(LOCK);
			
			for (var n:int = 0; n < actionList.length; n++)
			{
				//actions
				switch(actionList[n]) {
					case 0: {
						
						//trace("jumpin jeej");
							
							if (justTouched(FLOOR)) {
								/*jumpTimer = 0;
								if (this.velocity.x != 0) {
									jumpN = 3;
								}
								else if (this.velocity.x == 0) {
									jumpN = 2;
								}*/
								for (var m:int = 0; m < actionList.length; m++){
									if (action[m] == 0) {
										if (m != 0) {
											var t:int = action[m];
											action[m] = action[0];
											action[0] = t;
										}
										action.shift();
									}
								}
								
								break;
							}
							
							jumpN = 1;
							if (FlxG.keys.pressed(JUMP_KEY)) {
								jumpTimer += FlxG.elapsed;
							}
							if (FlxG.keys.justReleased(JUMP_KEY)) {
								if (this.velocity.y < 0) {
									this.velocity.y /= 2.0 - jumpTimer;
								}
							}
							
						}
						break;
					case 1:
						
						break;
					default:
						
						break;
				}
			
			}
			
		}
		
		private function movement(VEL:Number = 0, ACC:Number = 0, MAX:int = 70):void {
			if (facing == LEFT)
				this.acceleration.x = RUN_SPEED * 10;
			if (facing == RIGHT)
				this.acceleration.x = RUN_SPEED * -10;
		}
		
		private function animate():void {
			if (LR && isTouching(FLOOR) && jumpN == 0) {
				if (Math.abs(this.velocity.x) < RUN_SPEED)
					anim = "tranA";
					
				if (Math.abs(this.velocity.x) >= RUN_SPEED)
					anim = "run";
					
				/*if (this.acceleration.x / this.velocity.x < 0)
					anim = "tranB";*/
				if (this.velocity.x == 0)
					anim = "idle";
				this.play(animSUFIX(anim));
			}
			if (!LR && isTouching(FLOOR) && jumpN == 0) {
				if (Math.abs(this.velocity.x) < RUN_SPEED)
					anim = "tranB";
				if (this.velocity.x == 0)
					anim = "idle";
				this.play(animSUFIX(anim));
			}
			
			if (jumpN != 0) {
				if (this.velocity.y < 0)
					anim = "jumpUP"
					
				if (jumpN == 2) {
					anim = "fallSTILL";
					trace("BRUGHA");
					timer += FlxG.elapsed;
					if (timer >= 0.2) {
						jumpN = 0;
						timer = 0;
					}
				}
				else if (jumpN == 3) {
					anim = "fallRUN";
					trace("BRUGH");
					timer += FlxG.elapsed;
					if (timer >= 0.3) {
						jumpN = 0;
						timer = 0;
					}
				}
				if (jumpN > 1) {
					if (FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("RIGHT") || FlxG.keys.justReleased("LEFT") || FlxG.keys.justReleased("RIGHT")) {
						jumpN = 0;
						timer = 0;
					}
				}
				this.play(animSUFIX(anim));
			}
			
			if (this.velocity.y > 0) {
				anim = "jumpDOWN";
				
					this.play(animSUFIX(anim));
			}
		}
		
	}

}