package com.colorhook.media.audioPlayer.events{

	import flash.events.Event;


	public class PlayerEvent extends Event {

		public static  const MODEL_INIT:String="modelInit";
		public static  const DATA_COMPELTE:String="dataComplete";
		
		public static  const MODE_TYPE_CHANGE:String="modeTypeChange";
		public static  const SORT_TYPE_CHANGE:String="sortTypeChange";
		public static  const LIST_TYPE_CHANGE:String="listTypeChange";
		
		public static  const SOUND_PLAY:String="soundPlay";
		public static  const SOUND_PAUSE:String="soundPause";
		public static  const SOUND_STOP:String="soundStop";
		public static  const POSITION_CHANGE:String="positionChange";
		
		public static  const SOUND_LOAD_COMPLETE:String="soundLoadComplete";
		public static const SOUND_LOAD_PROGRESS:String="soundLoadProgress";
		public static  const SOUND_PLAY_COMPLETE:String="soundPlayComplete";
		public static  const SOUND_NEXT:String="soundNext";
		public static  const SOUND_PREV:String="soundPrev";
		public static  const SOUND_CHANGE:String="soundChange";
		
		
		
		public function PlayerEvent(type:String,bubbles:Boolean=false,cancelable:Boolean=false) {
			super(type,bubbles,cancelable);
		}


		override public  function clone():Event {
			return new PlayerEvent(type,bubbles,cancelable);
		}
	}
}