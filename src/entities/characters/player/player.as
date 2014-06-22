package entities.characters.player 
{
	import org.flixel.*;
	import entities.particles.dust;
	import assets._nuke;
	/**
	 * ...
	 * @author makeshiftRADIO
	 */
	public class player extends FlxSprite
	{
		
		//ADDING CHARACTER FILES AND VARS
		[Embed(source = "../../../assets/images/spritesheet_1.png")] public static var player_ss:Class;
		public var WALK_SPEED:Number = 60;
		public var STUNED_WALK_SPEED:Number = 60;
		public var FULL_WALK_SPEED:Number = 60;
		public var FULL_JUMP_FORCE:Number = 180;
		public var MAX_JUMP_FORCE:Number = 230;
		public const JUMP_KEY:String = "X";
		
		public var max_walk_speed:Number = 80;
		private var cha_acceleration:Number = 10;
		private var cur_character_speed:Number = 0;
		
		private var can_walk:Boolean = true;
		private var walk:Boolean = false;
		private var calm:Boolean = true;
		private var running:Boolean = false;
		private var grounded:Boolean = false;
		private var transition:Boolean = false;
		private var jump:Boolean = false;
		private var full:Boolean = false;
		public var fallTrough:Boolean = false;
		
		private var suck:Boolean = false;
		private var sucking:Boolean = false;
		private var spiting:Boolean = false;
		
		private var jump_force:Number = 100;
		private var jump_drag:Number = 10;
		private var jumpN:int = 0;
		private var jumpTimer:Number = 0;
		
		private var timer:Number = 0;
		
		private var action:String = "";
		private var animation:String = "";
		
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
			addAnimation("fallSTILL", [17,18], 10, false);
			addAnimation("fallRUN", [17, 18, 19, 19], 10, false);
			
			addAnimation("suckGROUND", [24, 25, 26,27], 10, false);
			addAnimation("suckingGROUND", [26, 27], 10, true);
			addAnimation("suckingStopEmptyGROUND", [28, 12, 18], 10, false);
			addAnimation("suckingStopFULLGROUND", [28, 36, 37], 10, false);
			addAnimation("suckAIR", [29, 30, 31], 10, true);
			addAnimation("suckingAIR", [30, 31], 10, true);
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
			
			height = 12;
			offset.y = 6;
			width = 6;
			offset.x = 3;
			
			this.play("idle");
			animation = "idle";
			
		}
		override public function update():void
		{
			
			characterAnimate();
			characterControl();
			
			cha_camera_tracker.x = this.x;
			cha_camera_tracker.y = this.y;
			
			this.acceleration.y = 600;
			trace(this.velocity.x);
			super.update();
			
		}
		
		//CONTROLS
		private function characterControl():void
		{
			
			if (FlxG.keys.justPressed("X") && FlxG.keys.DOWN && !fallTrough)
				{
				timer = 0.3;
				fallTrough = true;
				}
			
			if (fallTrough)
			{
				timer = timer - FlxG.elapsed;
				
				if (timer < 0)
					{
					fallTrough = false;
					}
				
				_nuke.TILE_MAP4.setTileProperties(12, FlxObject.NONE, null, null, 63);
			}
			else
			{
				_nuke.TILE_MAP4.setTileProperties(12, FlxObject.UP, null, null, 63);
			}
			
			
			characterSuckSpit();
			characterWalk();
			characterJump();
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
				
			if (suck)
			{
				
				if (currentAnimation() != "suckGROUND" && currentAnimation()!="suckAIR" && sucking == false)
					{
					if(isTouching(FLOOR))
						animation = "suckGROUND";
					else
						animation = "suckAIR";
						
					timer = 0.3;
					}
					
				timer = timer - FlxG.elapsed;
				
				if (timer < 0)
				{
					sucking = true
					
					if(isTouching(FLOOR)){
					if (currentAnimation() != "suckingGROUND")
						animation = "suckingGROUND";
						
					grounded = false;
					can_walk = true;
					max_walk_speed = WALK_SPEED;
					}
					else
					{
					if (currentAnimation() != "suckingAIR")
						animation = "suckingAIR";						
					}
				}
				
				//trace(sucking,timer);
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
					
					timer = 0.2;
					_nuke.allParticles.add(new dust(this.x, this.y+13,10,1));
					}
					
				if (timer < 0){
					grounded = false;
					can_walk = true;
					max_walk_speed = WALK_SPEED;
				}
					
				}else {
			if(isTouching(FLOOR) && jumpN == 0) {
				if (Math.abs(this.velocity.x) != 0 && !running && walk) {
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
				}else if (Math.abs(this.velocity.x) != 0 && walk && running && (isTouching(FLOOR)))
				{
					if (currentAnimation() != "run")
						{
							animation = "run";
						}
							
							
					if (_curFrame == 2 || _curFrame == 7)
						{
						_nuke.allParticles.add(new dust(this.x, this.y + 13, 3));
						}
							
					calm = false;
							
					if (Math.abs(this.velocity.x) >= max_walk_speed && this._curFrame >1)
						transition = true;
				}
				else if(!walk)
				{
					if (currentAnimation() != "idle")
						{
						animation = "idle";
						timer = 0.5;
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
						
			}else if (running && !(isTouching(FLOOR))) {
				
				animation = "jumpDOWN";
				
			}else{
				if (this.velocity.y < 0)
					animation = "jumpDOWN";
			}
			
			}
			}
			
			//trace(isTouching(FLOOR));
			
			if (currentAnimation() != animation)
			{
				if (full)
					this.play(animation+"FULL");
				else
					this.play(animation);
			}
			
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
		private function characterSuckSpit():void {
			if (suck)
			{
				can_walk = false;
			}else
			{
				can_walk = true;
			}
			
			if (full)
			{
					
			}
			else
			{
					
			}
			
			if (full && FlxG.keys.justPressed("SPACE"))
			{
					
			}
			
			if (FlxG.keys.SPACE && !full)
			{
				suck = true;
			}else if(FlxG.keys.justReleased("SPACE"))
			{
				suck = false;
				sucking = false;
			}
			
		}
		
		private function characterJump():void {
			
			if (FlxG.keys.justPressed(JUMP_KEY) && isTouching(FLOOR) && can_walk && !(FlxG.keys.DOWN)) {
				jumpN = 1;
			}
			if (jumpN != 0) { 
				

				
				if ((this._curFrame > 0 || this._frameTimer > 0.03) && currentAnimation() == "jumpUP") {
					
						//_curFrame = 1;
						
						if (jump == false) {
							if (!FlxG.keys.pressed(JUMP_KEY)) {
								_curFrame = 1;
								this.velocity.y = -(MAX_JUMP_FORCE / 3);
							}
							else
								{
								_curFrame = 1;
								this.velocity.y = -MAX_JUMP_FORCE;
								_nuke.allParticles.add(new dust(this.x, this.y+13,10,1));
								}
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
		
		public function currentAnimation():String {
			if(this._curAnim){
			var anim:String = _curAnim['name'];
			if (full)
				return anim.slice(0, -4);
			else
				return anim;
			}else
			{	
				trace(_curAnim);
				return animation;
			}
		}
		
	}

}