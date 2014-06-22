package entities.characters.player 
{
	/**
	 * ...
	 * @author makeshiftRADIO
	 */
	 
	 import org.flixel.*;
	 import assets._nuke;
	 
	public class player_V2 extends FlxSprite
	{	
		
		[Embed(source = "../../../assets/images/spritesheet_1.png")] public static var SHEET:Class;
		
		public var RUN_SPEED:int = 60;
		public var JUMP_SPEED:int = 230;
		public var g:Number = 500; //gravity
		public var anim:String = "";
		public var jumpN:int = 0; //if is in jump
		public var jumpTimer:Number = 0; //jump buffering
		public var MOV:Boolean = true; //movement anims
		public var UFF:int = 0; //fall recoil
		public var timer:Number = 0; //misc
		
		public var suck:Boolean = false;
		public var suckState:int = 0;
		
		public var canWalk:Boolean = true;
		
		public const JUMP_KEY:String = "X";
		public const SUCK_KEY:String = "C";
		
		public function player_V2(X:Number = 0, Y:Number = 0) {
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
			
			addAnimation("fallSTILL", [17,18], 10, false);
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
			width = 7;
			height = 9;
			offset.x = 2;
			offset.y = 9;
			
			this.acceleration.y = g;
			this.maxVelocity.x = RUN_SPEED;
			this.drag.x = RUN_SPEED * 5;
			if (this.velocity.x < 0)
				facing = RIGHT;
			else if (this.velocity.x > 0)
				facing = LEFT;
		     
			//MOVEMENT
				
			if ((FlxG.keys.LEFT || FlxG.keys.RIGHT) && !(FlxG.keys.LEFT && FlxG.keys.RIGHT) && canWalk) {
				if (FlxG.keys.LEFT)
					this.acceleration.x = -RUN_SPEED * 10;
				if (FlxG.keys.RIGHT)
					this.acceleration.x = RUN_SPEED * 10;
				if (MOV){
					if (Math.abs(this.velocity.x) < RUN_SPEED)
							anim = "tranA";
					if (Math.abs(this.velocity.x) == RUN_SPEED)
						anim = "run";
					if (this.acceleration.x / this.velocity.x < 0)
						anim = "tranB";
					this.play(anim);
				}
			}
			else
				this.acceleration.x = 0;
			 
			if (!(FlxG.keys.LEFT || FlxG.keys.RIGHT) && MOV) {
				if (Math.abs(this.velocity.x) < RUN_SPEED) {
					anim = "tranB";
					this.play(anim);
				}
			}
			 
			if (this.velocity.x == 0 && MOV) {
				anim = "idle";
				this.play(anim);
			}
			//MOVEMENT END
			
			//JUMPING
			if (isTouching(FLOOR) && FlxG.keys.justPressed(JUMP_KEY) && canWalk) {
				MOV = false;
				UFF = 0;
				jumpN = 1;
				anim = "jumpUP";
				this.play(anim);
				this.velocity.y = -JUMP_SPEED;
			}
			if (jumpN == 1) {
				if (FlxG.keys.pressed(JUMP_KEY) && this.velocity.y < 0) 
					jumpTimer += FlxG.elapsed;
				if (FlxG.keys.justReleased(JUMP_KEY) && this.velocity.y < 0) 
					this.velocity.y /= 2.0 - jumpTimer;
				
			}
			
			if (!isTouching(FLOOR) && this.velocity.y >= 0) {
				MOV = false;
				UFF = 0;
				if (!suck) {
					anim = "jumpDOWN";
					if (_curIndex == 16)
						anim = "DOWN";
					/*if (this.velocity.y < 20)
						this.play(anim);*/
				}
				this.play(anim);
			}
			
			if (justTouched(FLOOR) && !suck) {
				jumpTimer = 0;
				jumpN = 0;
				timer = 0;
				canWalk = true;
				if (this.velocity.x == 0)
					UFF = 1;
				else
					UFF = 2;
			}
			
			if (UFF == 1) {
				MOV = false;
				timer += FlxG.elapsed;
				anim = "fallSTILL";
				this.play(anim);
				if (FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("LEFT")) {
					MOV = true;
					UFF = 0;
					timer = 0;
				}
				if (timer >= 0.2) {
					MOV = true;
					UFF = 0;
					timer = 0;
				}
			}
			if (UFF == 2) {
				MOV = false;
				timer += FlxG.elapsed;
				anim = "fallRUN";
				this.play(anim);
				if (FlxG.keys.justReleased("RIGHT") || FlxG.keys.justReleased("LEFT")) {
					MOV = true;
					UFF = 0;
					timer = 0;
				}
				if (timer >= 0.3) {
					MOV = true;
					UFF = 0;
					timer = 0;
				}
			}
			//JUMPING END
			
			if (FlxG.keys.pressed(SUCK_KEY))
			{
				suck = true;
				canWalk = false;
				MOV = false;
			}
			
			if (suck)
			{
				if (FlxG.keys.justReleased(SUCK_KEY)) {
					timer = 0;
					suckState = 2;
				}
				if (suckState == 0)
				{
					if (isTouching(FLOOR))
						anim = "suckGROUND";
					else 
						anim = "suckAIR";
					timer += FlxG.elapsed;
					if (isTouching(FLOOR)){
						if (timer >= 0.4) {
							suckState = 1;
							timer = 0;
						}
					}
					else {
						if (timer >= 0.3) {
							suckState = 1;
							timer = 0;
						}
					}
				}
				if (suckState == 1)
				{
					if (isTouching(FLOOR))
						anim = "suckingGROUND";
					else
						anim = "suckingAIR";
				}
				if (suckState == 2) {
					if (isTouching(FLOOR))
						anim = "suckingStopEmptyGROUND";
					else 
						anim = "suckingStopEmptyAIR";
					timer += FlxG.elapsed;
					if (isTouching(FLOOR)){
						if (timer >= 0.3 || (FlxG.keys.RIGHT || FlxG.keys.LEFT)) {
							suck = false;
							suckState = 0;
							timer = 0;
							MOV = true;
							canWalk = true;
						}
					}
					else {
						if (timer >= 0.2 || (FlxG.keys.RIGHT || FlxG.keys.LEFT)) {
							suck = false;
							suckState = 0;
							timer = 0;
							canWalk = true;
							anim = "jumpDOWN";
							this.play(anim);
						}
					}
					if (isTouching(FLOOR) && FlxG.keys.justPressed(JUMP_KEY) && this.velocity.y == 0) {
						MOV = false;
						canWalk = true;
						UFF = 0;
						jumpN = 1;
						anim = "jumpUP";
						this.play(anim);
						suck = false;
						suckState = 0;
						timer = 0;
						this.velocity.y = -JUMP_SPEED;
					}
				}
				
				if (justTouched(FLOOR)) {
					trace("BOOM");
					if (suckState == 0)
						suckState = 1;
					else if (suckState == 2) {
						MOV = true;
						canWalk = true;
						timer = 0;
						suck = false;
						suckState = 0;
						UFF = 1;
					}
				}		
				
				if (suck) this.play(anim);
			}
			
			//trace(suckState, anim, _curIndex);
			trace(this.velocity.x);
			super.update();
		}
		
	}

}