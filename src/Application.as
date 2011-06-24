package{
	
	/**
	 * @author colorhook
	 * @version 1.0
	 * @copyright http://www.colorhook.com
	 * @description document class of MP3 Player
	 */


	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import com.colorhook.app.mp3player.mediator.*;
	import com.colorhook.media.audioPlayer.PlayerFacade;
	import com.colorhook.media.audioPlayer.model.PlayerModel;
	
	
	
	public class Application extends Sprite{
		
		protected var playModule:MovieClip;
		protected var listModule:MovieClip;
		protected var lyricModule:MovieClip;
		protected var mediatorMap:Dictionary;
		
		
		/**
		 * Mp3 data configuration file.
		 */
		private var path:String="player_config.xml";
		
		/**
		 * Constructor
		 */
		public function Application() {
			trace("MP3 PLAYER APPLICATION START");
			init();
			loadData();
		}
		
		private function init():void{
			stage.scaleMode="noScale";
			Security.allowDomain("*");
			playModule=getChildByName("play_module") as MovieClip;
			listModule=getChildByName("list_module") as MovieClip;
			lyricModule=getChildByName("lyric_module") as MovieClip;
			playModule.visible=false;
			listModule.visible=false;
			lyricModule.visible=false;
		}

		/**
		 * Load XML file and initialize the Data-Model.
		 */
		private function loadData():void{
			var playerFacade:PlayerFacade=PlayerFacade.getInstance();
			var model:PlayerModel=playerFacade.retrieveModel();
			model.addEventListener("modelInit",dataCompleteHandler,false,0,true);
			playerFacade.loadData(new URLRequest(path));
		}
		
		private function dataCompleteHandler(e:Event){
			initApp();
			playModule.visible=true;
			listModule.visible=true;
			lyricModule.visible=true;
		}
		
		
		/**
		 * Register mediators to initlialize View.
		 * PlayModule		mp3 control view
		 * ListModule		mp3 list view
		 * LyricModule		mp3 lyric view
		 */
		private function initApp():void{
			mediatorMap=new Dictionary(true);
			registerMediator("PlayModule",new PlayModuleMediator(playModule));
			registerMediator("ListModule",new ListModuleMediator(listModule));
			registerMediator("LyricModule",new LyricModuleMediator(lyricModule));
		}
		
		/**
		 * register a mediator by name.
		 * @param	name 		the name in of a mediator in the mediator map
		 * @param	mediator 	indicate a meditor which implements IMediator interface.
		 */
		public function registerMediator(name:String,mediator:IMediator):void{
			mediatorMap[name]=mediator;
			mediator.onRegister();
		}
		
		/**
		 * remove a mediator by name.
		 * @param	name
		 */
		public function removeMediator(name:String):void{
			var mediator=retrieveMediator(name);
			mediator.onRemove();
			delete mediatorMap[name];
		}
		
		/**
		 * get a mediator by name.
		 * @param	name
		 * @return
		 */
		public function retrieveMediator(name:String):IMediator{
			return mediatorMap[name] as IMediator;
		}
	}
	
}