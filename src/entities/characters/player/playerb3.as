package entities.characters.player 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author makeshiftRADIO
	 */
	public class player extends FlxSprite
	{
		
		//ADDING CHARACTER FILES AND VARS
		[Embed(source = "../../../assets/images/spritesheet_1.png")] public static var player_ss:Class;
		public var WALK_SPEED:Number = 100;
		public var STUNED_WALK_SPEED:Number = 50;
		
		public var max_walk_speed:Number = 100;
		private var cha_acceleration:Number = 10;
		private var cur_character_speed:Number = 0;
		
		private var can_walk:Boolean = true;
		private var walk:Boolean = false;
		private var calm:Boolean = true;
		private var running:Boolean = false;
		private var grounded:Boolean = false;
		private var sucking:Boolean = false;
		private var transition:Boolean = false;
		private var jump:Boolean = false;
		private var full:Boolean = true;
		
		private var max_jump_force:Number = 250;
		private var jump_force:Number = 100;
		private var jump_drag:Number = 10;
		private var timer:Number = 0;
		
		private var action:String = "";
		private var animation:String = "";
		
		private const JUMP_KEY:String = "X";
		private var jumpN:int = 0;
		private var jumpTimer:Number = 0;
		
		public var cha_camera_tracker:FlxPoint = new FlxPoint(0, 0);
		

		
		public function player(x:Number = 0, y:Number = 0) 
		{
		
			//Spawning character to position
			super(x, y);
			loadGraphic(player_ss, true, true,11,18);
			
			addAnimation("idle", [0], 8, false);
			addAnimation("run", [2, 3, 3, 4, 4, 5, 5, 6, 7, 7, 8, 8, 9, 9, 9], 20, true);
			addAnimation("tranA", [1], 10, false);
			addAnimation("tranB", [10, 11], 10, false);
			addAnimation("jumpDOWN", [15, 16], 10, false);
			addAnimation("jumpUP", [12, 13, 14], 10, false);
			addAnimation("fallSTILL", [17,18,18], 10, false);
			addAnimation("fallRUN", [17, 18, 19, 19], 10, false);
			
			addAnimation("suckGROUND", [25, 26, 27], 10, false);
			addAnimation("suckingGROUND", [26, 27], 10, false);
			addAnimation("suckingStopEmptyGROUND", [28, 12, 18], 10, false);
			addAnimation("suckingStopFULLGROUND", [28, 36, 37], 10, false);
			addAnimation("suckAIR", [30, 31], 10, true);
			addAnimation("suckingStopEmptyAIR", [29, 14], 10, false);
			addAnimation("suckingStopFullAIR", [38, 39], 10, false);
			
			addAnimation("idleFULL", [48], 10, true);
			addAnimation("tranAFULL", [49], 10, false);
			addAnimation("runFULL", [50, 51, 52, 53, 54, 55, 56, 57], 10, true);
			addAnimation("tranBFULL", [58, 59], 10, false);
			addAnimation("jumpUPFULL", [36, 60, 61], 10, false);
			addAnimation("jumpDOWNFULL", [62, 63], 10, false);
			addAnimation("fallSTILLFULL", [36, 37], 10, false);
			addAnimation("fallRUNFULL", [36, 64], 10, false);
			
			addAnimation("spitGROUND", [65, 66, 18], 10, false);
			addAnimation("spitAIR", [67, 68, 14], 10, false);
			
			
			
			this.play("idle");
			animation = "idle";
			
		}
		override public function update():void
		{
			
			characterControl();
			characterAnimate();
			
			cha_camera_tracker.x = this.x;
			cha_camera_tracker.y = this.y;
			
			if (FlxG.keys.SPACE)
			{
				sucking = true;
			}else if(FlxG.keys.justReleased("SPACE"))
			{
				sucking = false;
			}
			
			this.acceleration.y = 600;
			
			super.update();
			
		}
		
		//CONTROLS
		private function characterControl():void
		{
			if (sucking)
			{
				can_walk = false;
			}else
			{
				can_walk = true;
				characterJump();
			}
			
			characterWalk();
		}
		private function characterMove(current_speed:Number = 0, goal_speed:Number = 0, acceleration:Number = 0):Number
		{
			if (current_speed < goal_speed)
				current_speed = current_speed + acceleration;
			else if (current_speed > goal_speed)
				current_speed = current_speed - acceleration;
			else
				current_speed = goal_speed;
			
			cur_character_speed = current_speed;
			return current_speed;
		}
		private function characterAnimate():void
		{
			
			//ROTATING SPRITE HORIZONTLY
			if (this.velocity.x > 15)
				facing = LEFT;
			else if (this.velocity.x < -15)
				facing = RIGHT;
				
			if (sucking)
			{
				
			}
			else
			{
				
			if (grounded) {
				if ((currentAnimation() != "fallSTILL") && (currentAnimation() != "fallRUN"))
					{
					
					if(this.velocity.x == 0)
						animation = "fallSTILL";
					else
						animation = "fallRUN";
					
					timer = 0.3;
					}
					
				if (timer < 0){
					grounded = false;
					can_walk = true;
					max_walk_speed = WALK_SPEED;
				}
					
				}else {
			if(isTouching(FLOOR) && jumpN == 0) {
				if (Math.abs(this.velocity.x) != 0 && !transition && !running && walk) {
					if(calm){
					if (currentAnimation() != "tranA"){
						animation = "tranA";
						timer = 0.1;
						}
						
					if (timer <= 0) {
						running = true;
						calm = false;
					}
					}else
						{
							running = true;
							calm = false;
						}
				}
				else if (Math.abs(this.velocity.x) != 0 && !walk && transition) {
					animation = "tranB";
					can_walk = false;
					running = false;
				}else if (Math.abs(this.velocity.x) != 0 && walk && running)
				{
					if (currentAnimation() != "run")
							animation = "run";
							
					calm = false;
							
					if (Math.abs(this.velocity.x) >= max_walk_speed && this._curFrame >3)
						transition = true;
				}
				else if(!walk)
				{
					if (currentAnimation() != "idle")
						{
						animation = "idle";
						timer = 0.3;
						}
					
					timer = timer - FlxG.elapsed;
					
					if (timer <= 0)
						calm = true;
					
					running = false;
					transition = false;
					can_walk = true;
					
				}
			}else if(jumpN!=0){
						
					if (this.velocity.y > 0)
					{
						if(currentAnimation()!="jumpDOWN")
							animation = "jumpDOWN";
					}
					else {
					if(currentAnimation()!="jumpUP")
						animation = "jumpUP";
					}
						
			}else{
				if (this.velocity.y < 0)
					animation = "jumpDOWN";
			}
			
			}
			}
			
			if (currentAnimation() != animation)
			{
				if (full)
					this.play(animation+"FULL");
				else
					this.play(animation);
			}
			
			trace(currentAnimation());
			timer = timer - FlxG.elapsed;
				
		}
		
		private function characterWalk():void {
			
			if (FlxG.keys.LEFT && FlxG.keys.RIGHT)
			{
				//STOP IF BOTH ARROWS ARE PRESSED
				this.velocity.x = characterMove(cur_character_speed, 0, cha_acceleration);
			}
			else
			{
				//MOVE ONLY WHEN ONE ARROW IS PRESSED
				if (FlxG.keys.LEFT && can_walk) {
					
					walk = true;
					this.velocity.x = characterMove(cur_character_speed, -max_walk_speed, cha_acceleration);
				}else if (FlxG.keys.RIGHT && can_walk) {	
					walk = true;
					this.velocity.x = characterMove(cur_character_speed, max_walk_speed, cha_acceleration);
				}
				else
				{
					this.velocity.x = characterMove(cur_character_speed, 0, cha_acceleration);
					walk = false;
				}
				
			}
			
		}
		
		private function characterJump():void {
			
			if (FlxG.keys.justPressed(JUMP_KEY) && isTouching(FLOOR) && can_walk) {
				jumpN = 1;
			}
			if (jumpN != 0) {
				
				
				if (this._curFrame > 0 && currentAnimation()=="jumpUP") {
					
					if (jump == false) {
						if (!FlxG.keys.pressed(JUMP_KEY))
							this.velocity.y = -(max_jump_force/3);
						else
							this.velocity.y = -max_jump_force;
						jump = true;
					}
				}
				
				if (FlxG.keys.pressed(JUMP_KEY) && this.velocity.y < 0)
					jumpTimer += FlxG.elapsed;
				if (FlxG.keys.justReleased(JUMP_KEY) && this.velocity.y < 0)
					this.velocity.y /= 3.0 - jumpTimer;
			}
			if (justTouched(FLOOR)) {
				jumpN = 0;
				jumpTimer = 0;
				jump = false;
				grounded = true;
				
				if (this.velocity.x == 0)
				{
					max_walk_speed = (STUNED_WALK_SPEED/2);
				}
				else
					max_walk_speed = (STUNED_WALK_SPEED*1.2);
			}
			
		}
		
		private function currentAnimation():String {
			var anim:String = _curAnim['name'];
			if (full)
				return anim.slice(0, -4);
			else
				return anim;
		}
		
	}

}