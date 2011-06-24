package com.colorhook.media.audioPlayer{

	/**
	 * @version 1.0
	 * @author colorhook
	 * @description	PlayerFacade is a facade class of the AudioPlayer library. 
	 *	It's a SingleTon. You could use it in different View.
	 */

	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;


	import com.colorhook.media.audioPlayer.model.PlayerModel;
	import com.colorhook.media.audioPlayer.model.ModelProxy;
	import com.colorhook.media.audioPlayer.model.PlayerModeType;
	import com.colorhook.media.audioPlayer.model.PlayerSortType;
	import com.colorhook.media.audioPlayer.events.UIEvent;
	import com.colorhook.media.audioPlayer.events.PlayerEvent;
	import com.colorhook.media.audioPlayer.events.UIEventDispatcher;
	import com.colorhook.media.audioPlayer.control.SoundController;

	public class PlayerFacade {

		protected var _viewDispatcher:UIEventDispatcher=UIEventDispatcher.getInstance();
		protected var _model:PlayerModel=PlayerModel.getInstance();
		protected var _soundController:SoundController;
		protected static var instance:PlayerFacade;
		private var hasUIListener:Boolean=false;

		public function PlayerFacade() {
			if(instance!=null){
				throw new Error("PlayerFacade Singleston Error");
			}
			_soundController=new SoundController;
		}
		
		
		
		public static function getInstance():PlayerFacade{
			if(instance==null){
				instance=new PlayerFacade;
			}
			return instance;
		}
		
		
		/**
		 * load a XML configration file to initialize the application.
		 */
		public function loadData(path:URLRequest):void {
			trace("PlayerFacade Info:XML Configuration Data in loading...");
			var proxy:ModelProxy=new ModelProxy;
			proxy.addEventListener(Event.COMPLETE,onProxyDataComplete,false,0,true);
			proxy.addEventListener(IOErrorEvent.IO_ERROR,onDataIOError,false,0,true);
			_model.addEventListener(PlayerEvent.MODEL_INIT,onModelInit,false,0,true);
			if (hasUIListener) {
				removeUIListener();
			}
			proxy.load(path);
		}
		
		
		private function onDataIOError(e:IOErrorEvent):void {
			trace("PlayerFacade Info:XML Configuration Data Path Error");
			var proxy:ModelProxy=e.currentTarget  as  ModelProxy;
			proxy.removeEventListener(Event.COMPLETE,onProxyDataComplete);
			proxy.removeEventListener(IOErrorEvent.IO_ERROR,onDataIOError);
			proxy=null;
			_model.dispatchEvent(new IOErrorEvent("ioError"));
		}
		
		
		private function onProxyDataComplete(e:Event):void {
			trace("PlayerFacade Info:XML Configuration Data Loaded");
			var proxy:ModelProxy=e.currentTarget  as  ModelProxy;
			proxy.removeEventListener(Event.COMPLETE,onProxyDataComplete);
			proxy.removeEventListener(IOErrorEvent.IO_ERROR,onDataIOError);
			_model.initialize(proxy.data);
			proxy=null;
		}
		private function onModelInit(e:PlayerEvent):void {
			_model.removeEventListener(PlayerEvent.MODEL_INIT,onModelInit);
			if (! hasUIListener) {
				addUIListener();
			}
		}
		
		protected function addUIListener():void {
			_viewDispatcher.addEventListener(UIEvent.PLAY_SOUND,onUIEvent_PlaySound,false,0,true);
			_viewDispatcher.addEventListener(UIEvent.PAUSE_SOUND,onUIEvent_PauseSound,false,0,true);
			_viewDispatcher.addEventListener(UIEvent.STOP_SOUND,onUIEvent_stopSound,false,0,true);
			_viewDispatcher.addEventListener(UIEvent.NEXT_SOUND,onUIEvent_nextSound,false,0,true);
			_viewDispatcher.addEventListener(UIEvent.PREV_SOUND,onUIEvent_prevSound,false,0,true);
			_viewDispatcher.addEventListener(UIEvent.CHANGE_SOUND,onUIEvent_changeSound,false,0,true);
			_viewDispatcher.addEventListener(UIEvent.CHANGE_SOUND_TRANSFORM,onUIEvent_changeSoundTransform,false,0,true);
			_viewDispatcher.addEventListener(UIEvent.CHANGE_SORT_TYPE,onUIEvent_changeSortType,false,0,true);
			_viewDispatcher.addEventListener(UIEvent.CHANGE_LIST_TYPE,onUIEvent_changeListType,false,0,true);
			_viewDispatcher.addEventListener(UIEvent.CHANGE_POSITION,onUIEvent_changePosition,false,0,true);
		}
		
		protected function removeUIListener():void {
			_viewDispatcher.removeEventListener(UIEvent.PLAY_SOUND,onUIEvent_PlaySound);
			_viewDispatcher.removeEventListener(UIEvent.PAUSE_SOUND,onUIEvent_PauseSound);
			_viewDispatcher.removeEventListener(UIEvent.STOP_SOUND,onUIEvent_stopSound);
			_viewDispatcher.removeEventListener(UIEvent.NEXT_SOUND,onUIEvent_nextSound);
			_viewDispatcher.removeEventListener(UIEvent.PREV_SOUND,onUIEvent_prevSound);
			_viewDispatcher.removeEventListener(UIEvent.CHANGE_SOUND,onUIEvent_changeSound);
			_viewDispatcher.removeEventListener(UIEvent.CHANGE_SOUND_TRANSFORM,onUIEvent_changeSoundTransform);
			_viewDispatcher.removeEventListener(UIEvent.CHANGE_SORT_TYPE,onUIEvent_changeSortType);
			_viewDispatcher.removeEventListener(UIEvent.CHANGE_LIST_TYPE,onUIEvent_changeListType);
			_viewDispatcher.removeEventListener(UIEvent.CHANGE_POSITION,onUIEvent_changePosition);
		}
		
		
		private function onUIEvent_PlaySound(e:UIEvent):void {
			_soundController.playSound();
		}
		
		private function onUIEvent_PauseSound(e:UIEvent):void {
			_soundController.pauseSound();
		}
		
		private function onUIEvent_stopSound(e:UIEvent):void {
			_soundController.stopSound();
		}
		
		private function onUIEvent_nextSound(e:UIEvent):void {
			_soundController.nextSound();
		}
		
		private function onUIEvent_prevSound(e:UIEvent):void {
			_soundController.prevSound();
		}
		
		private function onUIEvent_changeSound(e:UIEvent):void {
			_soundController.playSoundAt(e.currentTarget.itemIndex);
		}
		
		private function onUIEvent_changeSoundTransform(e:UIEvent):void {
			_soundController.changeSoundTransform(e.currentTarget.soundTransform);
		}
		
		private function onUIEvent_changeSortType(e:UIEvent):void {
			_soundController.changeSortType(e.currentTarget.sortType);
		}
		
		private function onUIEvent_changeListType(e:UIEvent):void {
			_soundController.changeListType(e.currentTarget.groupIndex);
		}
		
		private function onUIEvent_changePosition(e:UIEvent):void {
			_soundController.changePosition(e.currentTarget.position);
		}
		
		
		/**
		*	The useful interfaces
		*/
		
		
		
		public function playSound():void{
			_soundController.playSound();
		}
		public function playSoundAt(index:Number):void{
			_soundController.playSoundAt(index);
		}
		public function pauseSound():void{
			_soundController.pauseSound();
		}
		public function stopSound():void{
			_soundController.stopSound();
		}
		public function nextSound():void{
			_soundController.nextSound();;
		}
		public function prevSound():void{
			_soundController.prevSound();
		}
		public function changePosition(position:Number):void{
			_soundController.changePosition(position);
		}
		
		public function changeSoundTransform(transform:SoundTransform):void{
			_soundController.changeSoundTransform(transform)
		}
		public function changeModeType(type:String):void{
			_soundController.changeModeType(type);
		}
		
		public function changeSortType(type:String):void{
			_soundController.changeSortType(type);
		}
		public function changeListType(index:Number):void{
			_soundController.changeListType(index);
		}
		
		public function retrieveModel():PlayerModel{
			return _model;
		}
		
		public function retrieveController():SoundController{
			return _soundController;
		}
		public function retrieveUIEventDispatcher():UIEventDispatcher{
			return _viewDispatcher;
		}

		public function retrieveSound():Sound{
			return _soundController.retrieveSound();
		}

		public function retrieveSoundChannel():SoundChannel{
			return _soundController.retrieveSoundChannel();
		}

		public function get playing():Boolean{
			return _soundController.playing;
		}

		public function get position():Number{
			return _soundController.position;
		}
		
		public function get positionPercent():Number{
			var sound:Sound=retrieveSound();
			if(sound==null||isNaN(sound.length)||sound.bytesLoaded==0){
				return 0;
			}
			var soundLen:Number=sound.length*sound.bytesTotal/sound.bytesLoaded;
			return position/soundLen;
		}
		
		public function get loadedPercent():Number{
			var sound:Sound=retrieveSound();
			if(sound.bytesTotal){
				return sound.bytesLoaded/sound.bytesTotal;
			}
			return 0;
		}


	}
}