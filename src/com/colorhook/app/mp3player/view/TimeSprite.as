package com.colorhook.app.mp3player.view{
	
	
	/**
	 * @author colorhook
	 * 
	 * @version	 1.0
	 * 
	 * @description  used to create a digital clock.
	 * 	this class binds to a movie clip which has 4 childs named
	 * 	'ns1', 'ns2', 'ns3', 'ns4'.
	 *               
	 */
	
	 
	import flash.display.MovieClip;
	
	public class TimeSprite extends MovieClip{
		
		private var _value:int=0;
		
		public function TimeSprite(){
			setup();
		}
		
		protected function setup():void{
			var minute:int=Math.floor(_value/60);
			var minute1:int=Math.floor(minute/10);
			var minute2:int=int(minute-minute1*10);
			
			var second:int=int(_value%60);
			var second1:int=Math.floor(second/10);
			var second2:int=int(second-second1*10);
			this.ns1.value=minute1;
			this.ns2.value=minute2;
			this.ns3.value=second1;
			this.ns4.value=second2;
		}
		
		/**
		 * @setter 
		 * set the clock value.
		 */
		public function set value(n:int):void{
			if(n<0||n>=3600){
				return;
			}
			_value=n;
			setup();
		}
		
		/**
		 * @getter 
		 * get the clock value.
		 */
		public function get value():int{
			return _value;
		}
	}
}