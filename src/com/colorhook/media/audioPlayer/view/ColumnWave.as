package com.colorhook.media.audioPlayer.view{
	
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class ColumnWave extends AbstractWave implements ISoundWave{
		
		
		private var _volumn:Number;
		private var _themeColor:uint;
		private var _columnWidth:Number;
		private var _distance:Number;
		private var _squareMap:Array;
		private var _columnMap:Array;
		private var _cacheMap:Array;
		private var _speedMap:Array;
		private var _waveWidth:Number;
		private var _waveHeight:Number;
		
		public function ColumnWave(waveW:Number=320,waveH:Number=100,color:uint=0xF2F2F2,volumn:Number=50,duration:Number=50):void{
			this._waveWidth=waveW;
			this._waveHeight=waveH;
			this._themeColor=color;
			this._volumn=volumn;
			super(duration);
			init();
		}
		
		private function init():void{
			FFTMode=true;
			var cellWidth:Number=waveWidth/_volumn;
			_columnWidth=cellWidth*0.8;
			_distance=cellWidth-_columnWidth;
			setUI();
		}
		
		private function setUI():void{
			_squareMap=new Array;
			_columnMap=new Array;
			_cacheMap=new Array;
			_speedMap=new Array;
			for(var i:int=0;i<_volumn;i++){
				var topSquare:Sprite=drawRect(_themeColor,_columnWidth,_columnWidth*0.6);
				var column:Sprite=drawRect(_themeColor,_columnWidth,10-_waveHeight);
				topSquare.x=column.x=i*(_columnWidth+_distance);
				topSquare.y=waveHeight-1;
				column.y=waveHeight;
				column.scaleY=0;
				canvas.addChild(topSquare);
				canvas.addChild(column);
				_squareMap.push(topSquare);
				_columnMap.push(column);
				_cacheMap[i]=0;
				_speedMap[i]=0.5;
			}
		}
		private function drawRect(color:uint,w:Number,h:Number):Sprite{
			var rect:Sprite=new Sprite;
			rect.graphics.beginFill(color);
			rect.graphics.drawRect(0,0,w,h);
			return rect;
		}
		
		override protected function drawWave():void{
			var offset=256/_volumn;
			var j:Number=0;
			for(var i:int=0;i<256;i+=offset){
				var data:Number=soundData.readFloat()/1.414;
				render(j++,data);
			}
		}
		
		private function render(index:Number,num:Number):void{
			if(index>=_columnMap.length){
				return;
			}
			var column:Sprite=_columnMap[index] as Sprite;
			var squareTop:Sprite=_squareMap[index] as Sprite;
			column.scaleY+=(num-column.scaleY)*0.4;
			if(waveHeight-column.height<squareTop.y){
				_cacheMap[index]=0;
				_speedMap[index]=1;
				squareTop.y=_waveHeight-column.height-2;
			}else{
				if(_cacheMap[index]>3){
					_speedMap[index]*=1.2;
					var speed:Number=_speedMap[index];
					if(squareTop.y+speed>=_waveHeight-column.height-2){
						speed=waveHeight-column.height-2-squareTop.y;
					}
					squareTop.y+=speed;
				}else{
					_cacheMap[index]++;
				}
				
			}
			
		}
		
		override public function stop():void{
			super.stop();
			for(var i:int=0;i<_volumn;i++){
				_squareMap[i].y=waveHeight;
				_columnMap[i].scaleY=0;
			}
		}
		
		public function get themeColor():uint{
			return _themeColor;
		}
		public function set themeColor(value:uint):void{
			if(_themeColor==value){
				return;
			}
			_themeColor=value;
			while(canvas.numChildren>0){
				canvas.removeChildAt(0);
			}
			setUI();
		}
		public function get waveWidth():Number{
			return _waveWidth;
		}
		public function set waveWidth(value:Number):void{
			if(value<=0){
				return;
			}
			_waveWidth=value;
			while(canvas.numChildren>0){
				canvas.removeChildAt(0);
			}
			init()
		}
		public function set waveHeight(value:Number):void{
			if(value<=0){
				return;
			}
			_waveHeight=value;
			while(canvas.numChildren>0){
				canvas.removeChildAt(0);
			}
			init()
		}
		public function get waveHeight():Number{
			return _waveHeight;
		}
	}
}