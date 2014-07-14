package entities.characters.player 
{
	
	import org.flixel.*;
	import entities.particles.*;
	import worlds.TestStage;
	
	public class spit_chunk extends FlxSprite
	{
		
		[Embed(source = "../../../assets/images/spit_chunk.png")] public static var SHEET:Class;
		public var bloodTRAIL:emitterUNI;
		
		public var spit_force = 400;
		public var in_air_drag = 400;
		public var floor_drag = 600;
		public var particle_active:Boolean = false;
		public var active_timer:Number = 0;
		public var is_flicker:Boolean = false;
		public var flicker_timer:Number = 0;
		
		public function spit_chunk(X:Number = 0, Y:Number = 0, facing:Number = 0):void
		{
			super(X, Y);
			loadGraphic(SHEET);
			if(facing == 16)
				this.velocity.x = (spit_force *-1);
			else
				this.velocity.x = spit_force;
				
			this.drag.x = in_air_drag;
			
			bloodTRAIL = new emitterUNI(this.x, this.y, dummyChunk_particles, 50, 100);
			TestStage.GROOP.add(bloodTRAIL);
		}
		override public function update():void 
		{
			trace(bloodTRAIL.active);
			this.acceleration.y = 500;
		
			bloodTRAIL.at(this);
			if (FlxG.keys.justPressed("G"))
				this.velocity.x = facing == LEFT ? -50 : 50;
			if (this.isTouching(FlxObject.ANY)) {
					this.drag.x = floor_drag;
				if (this.velocity.x != 0) {
					
						if(!particle_active) {
							bloodTRAIL.setXSpeed( -10, 10);
							bloodTRAIL.setYSpeed( -15, -30);
							bloodTRAIL.setRotation(0, 0);
							bloodTRAIL.width = this.width;
							bloodTRAIL.start(false, 3, 0.1, 0);
							particle_active = true;
						}
					}
				else
					bloodTRAIL.kill();
			}
			else
				this.drag.x = in_air_drag;
				
			if (active_timer <= 3) {
				active_timer = active_timer + FlxG.elapsed;
			}
			else
			{
				if (!is_flicker){
					this.flicker(1);
					is_flicker = true;
				}
				
				flicker_timer = flicker_timer + FlxG.elapsed;
				if (flicker_timer >= 1){
					this.kill();
					this.destroy();
				}
				
			}
			
			super.update();
		}
		
	}

}