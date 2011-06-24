package com.colorhook.media.audioPlayer.view{
	
	
	
	import flash.display.Sprite;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.media.SoundMixer;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	public class AbstractWave extends Sprite implements ISoundWave{
		
		
		protected var soundData:ByteArray;
		protected var canvas:Sprite;
		public var  FFTMode:Boolean=false;
		private var _playing:Boolean;
		private var _timer:Timer;

		private var _duration:Number;
		
		public function AbstractWave(duration:Number=100):void{

			_duration=duration;
			
			init();
		}
		
		private function init():void{
			_playing=false;
			soundData=new ByteArray();
			canvas=new Sprite();

			addChild(canvas);
		}
		
		public function play():void{
			if(!_playing){
				_timer=new Timer(_duration);
				_timer.addEventListener(TimerEvent.TIMER,loop,false,0,true);
				_playing=true;
				_timer.start();
			}
		}
		private function loop(e:Event):void{
			renderWave();
		}
		
		protected function renderWave():void{
			try{
				SoundMixer.computeSpectrum(soundData,FFTMode);
				drawWave();
			}catch(e:Error){
				
			}
			
			
		}
		
		protected function drawWave():void{
			
			
		}
		
		public function stop():void{
			if(_playing){
				_timer.removeEventListener(Event.ENTER_FRAME,loop);
				canvas.graphics.clear();
				_timer.stop();
				_timer=null;
				_playing=false;
			}
		}
		
		public  function get duration():Number{
			return _duration;
		}
		public function set duration(value:Number):void{
			if(_duration<10){
				return;
			}
			_duration=value;
			_timer.delay=_duration;
		}
		public function get playing():Boolean{
			return _playing;
		}

	}
}