package com.colorhook.app.mp3player.mediator{

	
	
	/**
	 * @author colorhook
	 * @version 1.0
	 * 
	 * @description  the lyric module of Mp3 Player, drag the lyric and drop, the player can play sound at a new position.
	 */
	 

	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.IOErrorEvent;
	import flash.display.MovieClip;
	import flash.media.Sound;
	
	import com.colorhook.app.mp3player.mediator.IMediator;
	import com.colorhook.app.mp3player.style.CustomCellRenderer;
	import com.colorhook.media.audioPlayer.model.PlayerModel;
	import com.colorhook.media.audioPlayer.events.PlayerEvent;
	import com.colorhook.media.audioPlayer.view.VerticalLRC;
	import com.colorhook.media.audioPlayer.PlayerFacade;
	import com.colorhook.media.audioPlayer.utils.LRCLoader;
	
	public class LyricModuleMediator implements IMediator {


		protected var viewComponent:*;
		private var model:PlayerModel;
		private var playerFacade:PlayerFacade;
		private var vsprite:VerticalLRC;
		private var inDrag:Boolean=false;
		private var startY:Number;
		private var loader:LRCLoader;


		public function LyricModuleMediator(viewComponent:*=null):void {
			this.viewComponent=viewComponent;
			model=PlayerModel.getInstance();
			playerFacade=PlayerFacade.getInstance();
			setupUI();
			setAction();
			
		}
		
		private function setAction():void{
			loader=new LRCLoader;
			loader.addEventListener("complete",onLrcComplete,false,0,true);
			loader.addEventListener("ioError",onLyricIOError,false,0,true);
			model.addEventListener(PlayerEvent.SOUND_PLAY,soundPlayHandler,false,0,true);
			model.addEventListener(PlayerEvent.SOUND_STOP,soundStopHandler,false,0,true);
			model.addEventListener(PlayerEvent.SOUND_CHANGE,soundChangeHandler,false,0,true);
		}
		
		private function onLyricIOError(e:IOErrorEvent):void{
			vsprite.dataProvider=null;
		}
		
		private function soundPlayHandler(e:PlayerEvent):void{
			if(!view.hasEventListener(Event.ENTER_FRAME))
			view.addEventListener(Event.ENTER_FRAME,renderIt,false,0,true);
		}
		
		
		private function soundStopHandler(e:PlayerEvent):void{
			vsprite.position=0;
			if(view.hasEventListener(Event.ENTER_FRAME))
			view.removeEventListener(Event.ENTER_FRAME,renderIt);
		}
		
		
		private function soundChangeHandler(e:PlayerEvent):void{
			var lrcPath:String=model.soundLyric;
			vsprite.dataProvider=null;
			if(lrcPath==null||lrcPath==""){
				loader.close();
				return;
			}
			try{
				loader.load(lrcPath);
			}catch(e:Error){
				
			}
		}
		private function onLrcComplete(e:Event):void{
			vsprite.lrcOffset=loader.offset;
			vsprite.dataProvider=loader.lrcData;
		}
		
		/**
		 * create a verticalLRC to display lyric.
		 */
		private function setupUI():void {
			vsprite=new VerticalLRC;
			vsprite.highlightColor=0x00CCFF;
			vsprite.y=view.content.canvas.height/2;
			view.content.canvas.addChild(vsprite);
			view.content.addEventListener(MouseEvent.MOUSE_DOWN,startDragLyric);
			view.content.buttonMode=true;
			view.content.mouseChildren=false;
			view.content.baseline.visible=false;
		}


		private function startDragLyric(e:MouseEvent) {
			if(vsprite.dataProvider==null){
				return;
			}
			inDrag=true;
			startY=view.mouseY;
			view.content.baseline.visible=true;
			view.stage.addEventListener(MouseEvent.MOUSE_UP,stopDragLyric);
			view.addEventListener(Event.ENTER_FRAME,adjustLyric);
		}

		private function adjustLyric(e:Event):void {
			var position=(view.mouseY-startY);
			startY=view.mouseY;
			vsprite.move(position);
		}

		private function renderIt(e:Event):void{
			if(!inDrag&&vsprite.dataProvider!=null){
				vsprite.position=playerFacade.position;
			}
		}

		private function stopDragLyric(e) {
			inDrag=false;
			view.content.baseline.visible=false;
			view.stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragLyric);
			view.removeEventListener(Event.ENTER_FRAME,adjustLyric);
			gotoPlayNewPosition();
		}
		
		private function gotoPlayNewPosition() {
			var pos=vsprite.position;
			var sound:Sound=playerFacade.retrieveSound();
			if(sound==null||isNaN(sound.length)){
				return;
			}
			if (pos>sound.length) {
				pos=sound.length;
			}
			playerFacade.changePosition(pos);
		}
		
		/**
		 * @getter 
		 * return the movie clip relative.
		 */
		public function get view():MovieClip {
			return viewComponent  as  MovieClip;
		}
		
		public function onRegister():void {
		}
		public function onRemove():void {
		}
	}
}