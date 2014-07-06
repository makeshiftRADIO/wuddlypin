package entities.particles 
{
	import org.flixel.*;
	/**
	 * ...
	 * @author MakeShift Radio
	 */
	public class emitterUNI extends FlxEmitter
	{
		public var poolVAR:int;
		public var particleVAR:Class;
		
		public function emitterUNI(X:Number, Y:Number, particle:Class, pool:int, gravity:int, XvMn:int, XvMx:int, YvMn:int, YvMx:int, MinRot:int, MaxRot:int)//, explode:Boolean, lifeSP:Number, fHz:Number, quant:Number = 0) 
		{
			super(X, Y);
			this.gravity = gravity;
			this.setRotation(MinRot, MaxRot);
			this.setXSpeed(XvMn, XvMx);
			this.setYSpeed(YvMn, YvMx);
			
			poolVAR = pool;
			particleVAR = particle;
			
			for (var i:int = 0; i < pool; i++)
				this.add(new particle);
			 
			//this.start(explode, lifeSP, fHz, quant);
		}
				
	}

}