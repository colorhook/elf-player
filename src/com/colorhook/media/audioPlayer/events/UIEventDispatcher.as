package com.colorhook.media.audioPlayer.events{

	import flash.events.EventDispatcher;
	
	
	[Event(name="changeSortType",type="colorsprite.media.audioPlayer.events.UIEvent")];

	[Event(name="changeListType",type="colorsprite.media.audioPlayer.events.UIEvent")];

	[Event(name="playSound",type="colorsprite.media.audioPlayer.events.UIEvent")];

	[Event(name="pauseSound",type="colorsprite.media.audioPlayer.events.UIEvent")];

	[Event(name="stopSound",type="colorsprite.media.audioPlayer.events.UIEvent")];

	[Event(name="changePosition",type="colorsprite.media.audioPlayer.events.UIEvent")];

	[Event(name="nextSound",type="colorsprite.media.audioPlayer.events.UIEvent")];

	[Event(name="prevSound",type="colorsprite.media.audioPlayer.events.UIEvent")];

	[Event(name="changeSound",type="colorsprite.media.audioPlayer.events.UIEvent")];

	[Event(name="changeSoundTransform",type="colorsprite.media.audioPlayer.events.UIEvent")];




	public class UIEventDispatcher extends EventDispatcher {

		public function UIEventDispatcher() {
			if (instance != null) {
				throw new Error("Singleton Error");
			}
		}
		protected static  var instance:UIEventDispatcher;

		public static  function getInstance():UIEventDispatcher {
			if (instance == null) {
				instance=new UIEventDispatcher  ;
			}
			return instance;
		}

	}
}