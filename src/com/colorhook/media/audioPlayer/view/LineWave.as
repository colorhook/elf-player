package com.colorhook.media.audioPlayer.view{
	
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class LineWave extends AbstractWave implements ISoundWave{
		

		private var _themeColor:uint;
		private var _volumn:Number;
		private var _waveWidth:Number;
		private var _waveHeight:Number;
		
		protected var tickness:Number=1;
		
		public function LineWave(waveW:Number=320,waveH:Number=100,color:uint=0xF2F2F2,volumn:Number=200,duration:Number=50):void{
			this._waveWidth=waveW;
			this._waveHeight=waveH;
			this._themeColor=color;
			this._volumn=volumn;
			super(duration);
			
		}
		
		
		
		override protected function drawWave():void{
			var offset=256/_volumn;
			var j:Number=0;
			canvas.graphics.clear();
			canvas.graphics.moveTo(0,_waveHeight*0.5)
			canvas.graphics.lineStyle(tickness,_themeColor);
			for(var i:int=0;i<256;i+=offset){
				var dataY:Number=soundData.readFloat()*20+_waveHeight*0.5;
				var dataX:Number=_waveWidth*i/256;
				canvas.graphics.lineTo(dataX,dataY);
				canvas.graphics.moveTo(dataX,dataY);
			}
		}
		

		
		override public function stop():void{
			super.stop();
			canvas.graphics.clear();
		}
		
		public function get waveWidth():Number{
			return _waveWidth;
		}
		
		public function set waveWidth(value:Number):void{
			if(value<=0){
				return;
			}
			_waveWidth=value;
		}
		public  function get waveHeight():Number{
			return _waveHeight;
		}
		public function set waveHeight(value:Number):void{
			if(value<=0){
				return;
			}
			_waveHeight=value;
		}
		
		public function get themeColor():uint{
			return _themeColor;
		}
		public function set themeColor(value:uint):void{
			_themeColor=value;
		}
	}
}