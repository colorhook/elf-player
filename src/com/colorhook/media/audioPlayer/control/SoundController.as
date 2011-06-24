package com.colorhook.media.audioPlayer.control{

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	import com.colorhook.media.audioPlayer.model.PlayerModel;
	import com.colorhook.media.audioPlayer.model.PlayerModeType;
	import com.colorhook.media.audioPlayer.model.PlayerSortType;
	import com.colorhook.media.audioPlayer.events.PlayerEvent;

	public class SoundController {

		protected var sound:Sound;
		protected var _model:PlayerModel;
		private var _channel:SoundChannel;
		private var _playing:Boolean;
		private var _hasSound:Boolean;
		private var _autoHandleError:Boolean;
		private var _autoHandleFunction:Function;
		
		public function SoundController() {
			_model=PlayerModel.getInstance();
			init()
		}
		
		private function init():void{
			_playing=false;
			_hasSound=false;
			_autoHandleError=true;
			_autoHandleFunction=null;
			createNewSound();
		}
		private function createNewSound():void{
			if(sound!=null&&sound.hasEventListener("complete")){
				sound.removeEventListener("complete",soundLoadCompleteHandler);
				sound.removeEventListener("ioError",soundIOErrorHandler);
				sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,soundSecurityErrorHandler);
				sound.removeEventListener("progress",soundLoadProgressHandler);
			} 
			sound=new Sound();
			sound.addEventListener("complete",soundLoadCompleteHandler,false,0,true);
			sound.addEventListener("ioError",soundIOErrorHandler,false,0,true);
			sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR,soundSecurityErrorHandler,false,0,true);
			sound.addEventListener("progress",soundLoadProgressHandler,false,0,true);
		}
		
		private function soundLoadCompleteHandler(e:Event):void{
			_model.dispatchEvent(new PlayerEvent(PlayerEvent.SOUND_LOAD_COMPLETE));
		}
		
		private function soundSecurityErrorHandler(e:IOErrorEvent):void{
			if(_autoHandleError){
				handleSoundLoadError();
			}else{
				_model.dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
			}
		}
		
		private function soundIOErrorHandler(e:IOErrorEvent):void{
			if(_autoHandleError){
				handleSoundLoadError();
			}else{
				_model.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
			}
		}
		
		private function soundLoadProgressHandler(e:ProgressEvent):void{
			_model.dispatchEvent(new PlayerEvent(PlayerEvent.SOUND_LOAD_PROGRESS));
		}
		
		
		/**
		 *	Play current sound
		 */
		public function playSound(noEvent:Boolean=false):void{
			if(_playing||_model.itemLength<=0){
				return;
			}
			if(!_hasSound){
				try{
					createNewSound();
					var soundURL:String=getCurrentPath();
					if(soundURL==null||soundURL==""){
						handleSoundLoadError();
						return;
					}
					sound.load(new URLRequest(getCurrentPath()));
					_hasSound=true;
				}catch(error:Error){
					handleSoundLoadError();
				}finally{
					_model.dispatchEvent(new PlayerEvent(PlayerEvent.SOUND_CHANGE));
				}
			}
			
			if(_channel!==null&&_channel.hasEventListener("soundComplete")){
				_channel.removeEventListener("soundComplete",onSoundPlayComplete)
			}
			_channel=sound.play(_model.position);
			_channel.addEventListener("soundComplete",onSoundPlayComplete,false,0,true)
			_channel.soundTransform=_model.soundTransform;
			_hasSound=true;
			_playing=true;
			if(!noEvent){
				_model.dispatchEvent(new PlayerEvent(PlayerEvent.SOUND_PLAY));
			}

		}
		
		
		/**
		 *	Get the sound file path.
		 */
		private function getCurrentPath():String{
			var item:Array=_model.data[_model.groupIndex].data as Array;
			return encodeURI(item[_model.itemIndex].path);
		}
		
		private function onSoundPlayComplete(e:Event):void{
			autoPlayNextSound();
		}
		
		protected function autoPlayNextSound():void{
			stopSound();
			_model.dispatchEvent(new PlayerEvent(PlayerEvent.SOUND_PLAY_COMPLETE));
			switch(_model.modeType){
				
				case PlayerModeType.RANDOM:
				nextSound();
				break;
				
				case PlayerModeType.SINGLE:
				break;
				
				case PlayerModeType.INVERSE:
				playSound();
				break;
				
				case PlayerModeType.CYCLE:
				autoAddIndex();
				playSound();
				_model.dispatchEvent(new PlayerEvent(PlayerEvent.SOUND_NEXT));
				break;
				
				case PlayerModeType.NORMAL:
				if(autoAddIndex()){
					playSound();
				}
				break;
				
				default:
				break;
			}
		}
		private function autoAddIndex():Boolean{
			if(_model.itemIndex>=_model.itemLength-1){
				_model.itemIndex=0;
				return false;
			}else{
				_model.itemIndex++;
				return true;
			}
		}
		
		
		/**
		 *	Pause current sound
		 */
		public function pauseSound():void{
			if(_playing){
				_model.position=_channel.position;
				_channel.stop();
				_playing=false;
				_hasSound=true;
				_model.dispatchEvent(new PlayerEvent(PlayerEvent.SOUND_PAUSE));
			}
		}
		
		
		/**
		 *	stop current sound
		 */
		public function stopSound():void{
			if(_hasSound){
				_channel.stop();
				_playing=false;
				_hasSound=false;
				_model.position=0;
				_model.dispatchEvent(new PlayerEvent(PlayerEvent.SOUND_STOP));
			}
		}
		
		
		/**
		 *	Play next sound
		 */
		public function nextSound():void{
			stopSound();
			var nextIndex:int=_model.itemIndex;
			if(_model.modeType==PlayerModeType.RANDOM){
				nextIndex=getRandomIndex();
			}else{
				nextIndex=(nextIndex>=_model.itemLength-1)?0:_model.itemIndex+1;
			}
			_model.itemIndex=nextIndex;
			playSound();
			_model.dispatchEvent(new PlayerEvent(PlayerEvent.SOUND_NEXT));
		}
		
		/**
		 *	Play prevous sound
		 */
		public function prevSound():void{
			stopSound();
			var prevIndex:int=_model.itemIndex;
			if(_model.modeType==PlayerModeType.RANDOM){
				prevIndex=getRandomIndex();
			}else{
				prevIndex=(prevIndex<=0)?(_model.itemLength-1):prevIndex-1;
			}
			_model.itemIndex=prevIndex;
			playSound();
			_model.dispatchEvent(new PlayerEvent(PlayerEvent.SOUND_PREV));
		}
		
		/**
		 *	return a interger between 0 to soundCount-1.
		 */
		private function getRandomIndex():int{
			return Math.floor(Math.random()*_model.itemLength);
		}
		
		/**
		 *	Play the sound by index in sound list.
		 */
		public function playSoundAt(index:Number):void{
			stopSound();
			var length:Number=_model.itemLength;
			if(index>length||index<0){
				return;
			}
			_model.itemIndex=index;
			playSound();
		}
		
		/**
		 *	Change the sound transform. you can adjust volume and span ect.
		 */
		public function changeSoundTransform(transform:SoundTransform):void{
			_model.soundTransform=transform;
			if(_playing){
				_channel.soundTransform=transform;
			}
			_model.dispatchEvent(new PlayerEvent(PlayerEvent.POSITION_CHANGE));
		}
		
		public function changeModeType(type:String):void{
			if(type==_model.modeType){
				return;
			}
			_model.modeType=type;
			_model.dispatchEvent(new PlayerEvent(PlayerEvent.MODE_TYPE_CHANGE));
		}
		
		/**
		 *	Sort the sound list
		 */
		public function changeSortType(type:String):void{
			if(type==_model.sortType){
				return;
			}
			_model.sortType=type;
			var data:Array=_model.currentListData;
			var currentItem:*=data[_model.itemIndex];
			switch(type){
				case PlayerSortType.NORMAL:
				data=_model.cacheData.concat();
				break;
				case PlayerSortType.TITLE:
				data.sortOn("name");
				_model.itemIndex=data.indexOf(currentItem);
				break;
			}
			_model.dispatchEvent(new PlayerEvent(PlayerEvent.SORT_TYPE_CHANGE));
		}
		
		/**
		 *	switch to another sound group defined by XML congfigration file.
		 */
		public function changeListType(type:Number):void{
			if(type<0||type>_model.data.length){
				return;
			}
			stopSound();
			_model.groupIndex=type;
			_model.itemIndex=0;
			playSound();
			_model.dispatchEvent(new PlayerEvent(PlayerEvent.LIST_TYPE_CHANGE));
		}
		
		/**
		 *	A useful method to change the current playing position.
		 * call this method if you want to drag a play-head to change the progress.
		 */
		public function changePosition(position:Number):void{
			if(_playing){
				_channel.stop();
				_playing=false;
				_hasSound=true;
				_model.position=position;
				playSound(true);
			}else{
				_model.position=position;
			}
			_model.dispatchEvent(new PlayerEvent(PlayerEvent.POSITION_CHANGE));
		}
		
		
		/**
		 *	Get the current Sound instance, return null if the sound is not initialized by this class.
		 */
		public function retrieveSound():Sound{
			return sound;
		}
		
		/**
		 *	Get the current SoundChannel instance, return null if the sound is not initialized by this class.
		 */
		public function retrieveSoundChannel():SoundChannel{
			return _channel;
		}
		
		/**
		 *	Get the current sound position, return 0 if the sound is not initialized by this class.
		 */
		public function get position():Number{
			if(_channel==null){
				return 0;
			}else if(_playing){
				return _channel.position;
			}else{
				return _model.position;
			}
		}
		
		/**
		 *	return a boolean specify the player status.
		 */
		public function get playing():Boolean{
			return _playing;
		}
		
		/**
		 *	Indicate if the player handler the IO error spontaneously.
		 */
		public function get autoHandleError():Boolean{
			return _autoHandleError;
		}
		
		public function set autoHandleError(value:Boolean):void{
			_autoHandleError=value;
		}
		
		/**
		 *	custom a function to handle the IO error
		 */
		public function set autoHandleFunction(value:Function):void{
			_autoHandleFunction=value;
		}
		
		/*
		 * This method be called while a error occur  such as file is not found.
		 */
		protected function handleSoundLoadError():void{
			if(_autoHandleFunction==null){
				nextSound();
			}else{
				_autoHandleFunction();
			}
		}
		
	}
}




