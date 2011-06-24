package com.colorhook.app.mp3player.view{
	
	/**
	 * @author colorhook
	 * 
	 * @version	 1.0
	 * 
	 * @description  used to create a digital number.
	 * 	this class binds to a movie clip which has 7 childs named
	 * 	top', 'topRight', 'topLeft', 'center', 'bottomRight', 'bottomLeft', 'bottom' .
	 *               
	 */
	
	 
	import flash.display.MovieClip;
	
	public class NumberSprite extends MovieClip{
		
		private var _value:int = 0;
		
		public function NumberSprite(){
			setup();
		}
		
		protected function setup():void{
			var temp:Array;
			switch(_value){
				case 0:temp=[1,1,1,0,1,1,1];break;
				case 1:temp=[0,0,1,0,0,1,0];break;
				case 2:temp=[1,0,1,1,1,0,1];break;
				case 3:temp=[1,0,1,1,0,1,1];break;
				case 4:temp=[0,1,1,1,0,1,0];break;
				case 5:temp=[1,1,0,1,0,1,1];break;
				case 6:temp=[1,1,0,1,1,1,1];break;
				case 7:temp=[1,0,1,0,0,1,0];break;
				case 8:temp=[1,1,1,1,1,1,1];break;
				case 9:temp=[1,1,1,1,0,1,1];break;
				default:break;
			}
			var spriteArr:Array=[top,topLeft,topRight,center,bottomLeft,bottomRight,bottom];

			for(var i:int=0;i<spriteArr.length;i++){
				var item:MovieClip=spriteArr[i] as MovieClip;
				item.visible=Boolean(temp[i]);
			}
			
			
		}
		
		/**
		 * @setter 
		 * set the value
		 */
		
		public function set value(n:int):void{
			if(n<0||n>9){
				return;
			}
			_value=n;
			setup();
		}
		
		/**
		 * @getter 
		 * get the value.
		 */
		public function get value():int{
			return _value;
		}
	}
}