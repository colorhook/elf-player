package com.colorhook.app.mp3player.mediator{
	

	
	/**
	 * @author colorhook
	 * 
	 * @version 1.0
	 * 
	 * @description  the play module of Mp3 Player, It used to manager play, pause, stop actions. And display sound wave also.
	 */
	 
	 
	 
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.display.DisplayObject;
	
	import com.colorhook.media.audioPlayer.PlayerFacade;
	import com.colorhook.media.audioPlayer.model.PlayerModel;
	import com.colorhook.media.audioPlayer.events.PlayerEvent;
	import com.colorhook.media.audioPlayer.view.*;
	import com.colorhook.app.mp3player.mediator.IMediator;
	
	public class PlayModuleMediator implements IMediator{
		
		protected var playerFacade:PlayerFacade=PlayerFacade.getInstance();
		protected var model:PlayerModel=PlayerModel.getInstance();
		protected var viewComponent:*;
		
		private var playButton:SimpleButton;
		private var pauseButton:SimpleButton;
		private var stopButton:SimpleButton;
		private var nextButton:SimpleButton;
		private var prevButton:SimpleButton;
		
		private var volumeHitArea:MovieClip;
		private var volumeBar:MovieClip;
		private var progressHitArea:MovieClip;
		private var progressBar:MovieClip;
		private var loadIndicatorBar:MovieClip;
		private var soundWave:ISoundWave;
		private var waveCanvas:MovieClip;
		
		 public function PlayModuleMediator(viewComponent:*=null):void{
			this.viewComponent=viewComponent;
			setupUI();
		}
		
		private function setupUI():void{
			setupControlButton();
			setupAdjustBar();
			setupWave();
			model.addEventListener(PlayerEvent.SOUND_LOAD_PROGRESS,soundLoadProgressHandler,false,0,true);
			model.addEventListener(PlayerEvent.SOUND_LOAD_COMPLETE,soundLoadCompleteHandler,false,0,true);
			model.addEventListener(PlayerEvent.SOUND_PLAY,soundPlayHandler,false,0,true);
			model.addEventListener(PlayerEvent.SOUND_PAUSE,soundPauseHandler,false,0,true);
			model.addEventListener(PlayerEvent.SOUND_STOP,soundStopHandler,false,0,true);
		}
		
		private function setupControlButton():void{
			playButton=view.console_mc.playButton as SimpleButton;
			playButton.addEventListener(MouseEvent.CLICK,onButtonClicked,false,0,true);
			stopButton=view.console_mc.stopButton as SimpleButton;
			stopButton.addEventListener(MouseEvent.CLICK,onButtonClicked,false,0,true);
			pauseButton=view.console_mc.pauseButton as SimpleButton;
			pauseButton.addEventListener(MouseEvent.CLICK,onButtonClicked,false,0,true);
			prevButton=view.console_mc.prevButton as SimpleButton;
			prevButton.addEventListener(MouseEvent.CLICK,onButtonClicked,false,0,true);
			nextButton=view.console_mc.nextButton as SimpleButton;
			nextButton.addEventListener(MouseEvent.CLICK,onButtonClicked,false,0,true);
			pauseButton.visible=false;
		}
		
		private function setupWave():void{
			waveCanvas=view.waveCanvas;
			waveCanvas.waveArea.addEventListener("click",changeWaveHandler,false,0,true);
			waveCanvas.waveArea.alpha=0;
			soundWave=new ColumnWave(184,60,0x666666);
			waveCanvas.addChild(soundWave as DisplayObject);
		}
		
		private function soundPlayHandler(e:PlayerEvent):void{
			soundWave.play();
			playButton.visible=false;
			pauseButton.visible=true;
			view.status_txt.text="状态：播放";
			view.sound_txt.text=model.soundName;
			if(!view.hasEventListener(Event.ENTER_FRAME))
			view.addEventListener(Event.ENTER_FRAME,renderSelf,false,0,true);
			
		}
		private function soundPauseHandler(e:PlayerEvent):void{
			soundWave.stop();
			playButton.visible=true;
			pauseButton.visible=false;
			view.status_txt.text="状态：暂停";
		}
		private function soundStopHandler(e:PlayerEvent):void{
			soundWave.stop();
			playButton.visible=true;
			pauseButton.visible=false;
			progressBar.scaleX=0;
			view.status_txt.text="状态：停止";
			view.timeSprite.value=0;
			if(view.hasEventListener(Event.ENTER_FRAME))
			view.removeEventListener(Event.ENTER_FRAME,renderSelf);
		}
		private function soundLoadProgressHandler(e:PlayerEvent):void{
			loadIndicatorBar.scaleX=playerFacade.loadedPercent;
		}
		private function soundLoadCompleteHandler(e:PlayerEvent):void{
			progressBar.scaleX=1;
		}
		/**
		 * update the position of the sound progress bar.
		 */
		private function renderSelf(e:Event):void{
			progressBar.scaleX=playerFacade.positionPercent;
			view.timeSprite.value=playerFacade.position/1000;
		}
		
		
		private function onButtonClicked(e:MouseEvent):void{
			switch(e.currentTarget as SimpleButton){
				
				case playButton:		playerFacade.playSound();break;
													
				case pauseButton:	playerFacade.pauseSound();break;
													
				case stopButton:		playerFacade.stopSound();break;
													
				case nextButton:		playerFacade.nextSound();break;
				
				case prevButton:		playerFacade.prevSound();break;
			}
		}
		
		private function setupAdjustBar():void{
			volumeHitArea=view.volume_mc.volumeHitArea as MovieClip;
			volumeHitArea.buttonMode=true;
			volumeBar=view.volume_mc.volumeBar as MovieClip;
			progressHitArea=view.progress_mc as MovieClip;
			progressHitArea.buttonMode=true;
			progressBar=view.progress_mc.progressBar as MovieClip;
			loadIndicatorBar=view.progress_mc.loadIndicatorBar as MovieClip;
			volumeHitArea.addEventListener(MouseEvent.CLICK,volumeHitAreaClicked,false,0,true);
			progressHitArea.addEventListener(MouseEvent.CLICK,progressHitAreaClicked,false,0,true);
			progressBar.scaleX=0;
			loadIndicatorBar.scaleX=0;
			trace("loadIndicatorBar:",loadIndicatorBar);

		}
		
		private function volumeHitAreaClicked(e:MouseEvent):void{
			var percent:Number=volumeHitArea.mouseX/volumeHitArea.width;
			if(percent<0.1){
				percent=0;
			}else if(percent>0.9){
				percent=1;
			}
			volumeBar.scaleX=percent;
			var transform:SoundTransform=model.soundTransform as SoundTransform;
			transform.volume=percent;
			playerFacade.changeSoundTransform(transform);
		}
		
		private function progressHitAreaClicked(e:MouseEvent):void{		
			var sound:Sound=playerFacade.retrieveSound() as Sound;
			if(sound==null||isNaN(sound.length)){
				return;
			}
			var percent:Number=progressHitArea.mouseX/progressHitArea.width;
			progressBar.scaleX=percent;
			var position:Number=sound.length*percent;
			playerFacade.changePosition(position);
		}


		private function changeWaveHandler(e:MouseEvent):void{
			soundWave.stop();
			waveCanvas.removeChild(soundWave as DisplayObject);
			if(soundWave is LineWave){
				soundWave=new ColumnWave(184,60,0x666666);
			}else{
				soundWave=new LineWave(184,60,0x666666);
			}
			waveCanvas.addChild(soundWave as DisplayObject);
			soundWave.play();
		}
		/**
		 * @getter 
		 * return the movie clip relative.
		 */
		public function get view():MovieClip{
			return viewComponent as MovieClip;
		}
		
		public function onRegister():void{
		}
		public function onRemove():void{
		}
	}
	
}