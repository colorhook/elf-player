package com.colorhook.media.audioPlayer.events{

	import flash.events.Event;
	import flash.media.SoundTransform;
	
	public class UIEvent extends Event {



		public static  const CHANGE_SORT_TYPE:String="changeSortType";
		public static  const CHANGE_LIST_TYPE:String="changeListType";
		public static  const PLAY_SOUND:String="playSound";
		public static  const PAUSE_SOUND:String="pauseSound";
		public static  const STOP_SOUND:String="stopSound";
		
		public static  const CHANGE_POSITION:String="changePosition";


		public static  const NEXT_SOUND:String="nextSound";
		public static  const PREV_SOUND:String="prevSound";
		public static  const CHANGE_SOUND:String="changeSound";
		public static  const CHANGE_SOUND_TRANSFORM:String="changeSoundTransform";
		
		
		
		
		public var itemIndex:int=0;
		public var groupIndex:int=0;
		public var position:Number=0;
		public var transform:SoundTransform;
		public var modeType:String;
		public var sortType:String;

		public function UIEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type,bubbles,cancelable);
		}


		override public  function clone():Event {
			return new UIEvent(type,bubbles,cancelable);
		}
	}
}