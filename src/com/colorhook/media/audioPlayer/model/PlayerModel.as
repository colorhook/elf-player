package com.colorhook.media.audioPlayer.model{

	import flash.events.EventDispatcher;
	import flash.media.SoundTransform;
	import flash.events.Event;
	import com.colorhook.media.audioPlayer.events.PlayerEvent;
	import com.colorhook.media.audioPlayer.model.PlayerModeType;
	import com.colorhook.media.audioPlayer.model.PlayerSortType;
	
	
	
	[Event(name="modelInit",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="dataComplete",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="modeTypeChange",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="sortTypeChange",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="listTypeChange",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="soundPlay",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="soundPause",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="soundStop",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="positionChange",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="soundLoadComplete",type="colorsprite.media.audioPlayer.events.PlayerEvent")];
	
	[Event(name="soundLoadProgress",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="soundPlayComplete",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="soundNext",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="soundPrev",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="soundChange",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="soundTranformChange",type="colorsprite.media.audioPlayer.events.PlayerEvent")];

	[Event(name="IoError",type="flash.events.IOErrorEvent")];

	[Event(name="securityError",type="flash.events.SecurityErrorEvent")];

	[Bindable]
	public class PlayerModel extends EventDispatcher {

		public function PlayerModel() {
			if (instance != null) {
				throw new Error("Singleton Error");
			}
		}
		protected static  var instance:PlayerModel;

		public static  function getInstance():PlayerModel {
			if (instance == null) {
				instance=new PlayerModel  ;
			}
			return instance;
		}
		public var itemIndex:int=0;

		public var groupIndex:int=0;

		public var data:Array;
		public var cacheData:Array;
		public var modeType:String=PlayerModeType.CYCLE;
		public var sortType:String=PlayerSortType.TITLE;
		public var position:Number=0;
		
		public var soundTransform:SoundTransform;
		
		
		public function initialize(data:Array):void{
			//trace("MODEL_INITIALIZE");
			this.dispatchEvent(new Event(Event.COMPLETE));
			this.data=data;
			this.cacheData=data.concat();
			itemIndex=0;
			groupIndex=0;
			soundTransform=new SoundTransform();
			this.dispatchEvent(new PlayerEvent(PlayerEvent.MODEL_INIT));
		}
		
		public function get currentListData():Array{
			if(data==null||data.length==0){
				return null;
			}
			return this.data[groupIndex].data  as Array;
		}
		
		public function get groupLength():int{
			return data.length;
		}
		public function get itemLength():int{
			return this.data[groupIndex].data.length;
		}
		public function get soundName():String{
			return this.data[groupIndex].data[itemIndex].name;
		}
		public function get groupName():String{
			return this.data[groupIndex].type;
		}
		public function get soundLyric():String{
			return this.data[groupIndex].data[itemIndex].lyric;
		}
		public function get soundPath():String{
			return this.data[groupIndex].data[itemIndex].path;
		}
	}
}