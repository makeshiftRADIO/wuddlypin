package entities.particles 
{
	import org.flixel.*;
	import assets._nuke;
	public class dust extends FlxEmitter
	{
		
		public function dust(x:Number = 0, y:Number = 0,z:Number = 0, e:Number = 0.5) 
		{
		
		super(x, y);
			
		var particles:int = z;
		var dragX:Number = 0;
		
		if (_nuke.mainPlayer.velocity.x > 0)
			dragX = 10;
		else if (_nuke.mainPlayer.velocity.x < 0)
			dragX = - 10;
		
		this.setXSpeed( dragX-5, dragX+5);
        this.setYSpeed( -10, 10);
		this.setRotation(0, 0);
		this.gravity = -4;
		 
		for(var i:int = 0; i < particles; i++)
		{
			var particle:dustParticle = new dustParticle();
			particle.exists = false;
			particle.alpha = e;
			this.add(particle);
		}
		 
		this.start(true,2);
			
		}
		override public function update():void 
		{
			super.update();
		}
		
	}

}