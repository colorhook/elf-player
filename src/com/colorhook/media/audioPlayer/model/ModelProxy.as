package com.colorhook.media.audioPlayer.model{

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.net.URLLoader;

	[Event(name="complete",type="flash.events.Event")];

	[Event(name="ioError",type="flash.events.IOErrorEvent")];

	public class ModelProxy extends EventDispatcher {

		private var _data:Array=new Array  ;

		
		/**
		 *	load XML configration file to get sound info.
		 */
		public function load(request:URLRequest):void {
			var loader:URLLoader=new URLLoader  ;
			loader.addEventListener(Event.COMPLETE,onDataComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError,false,0,true);
			try {
				trace("ModelProxy Info:XML Configuration Data in loading...");
				loader.load(request);
			} catch (e:Error) {
				throw new Error("@@ModelProxy Error");
			}
		}
		
		private function onDataComplete(e:Event):void {
			trace("ModelProxy Info:XML Configuration Data loaded");
			var loader:URLLoader=e.currentTarget  as  URLLoader;
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			loader.removeEventListener("complete",onDataComplete);
			parseData(loader.data);
			loader=null;
			dispatchEvent(new Event(Event.COMPLETE));
		}
		protected function parseData(xmlData:*):void {
			_data=new Array;
			var xml:XML=XML(xmlData);
			var list:XMLList=xml.group;
			for(var i:int=0;i<list.length();i++){
				var soundMap:Array=getSoundMapBy(XMLList(list[i].sound));
				_data.push({type:list[i].@type,data:soundMap});
				trace("ModelProxy Info: SOUND-LIST-TYPE=>"+_data[i].type);
			}
		}
		private function getSoundMapBy(list:XMLList):Array{
			var result:Array=new Array;
			for(var i:int=0;i<list.length();i++){
				result.push({name:list[i].@name,path:list[i].@path,lyric:list[i].@lyric});
				trace("\t\tModelProxy Info: SOUND-ITEM=>:"+result[i].name+"\n\t\t\t\t"+result[i].path+"\n\t\t\t\t"+result[i].lyric);
			}
			return result;
		}
		
		
		private function onIOError(e:IOErrorEvent):void {
			var loader:URLLoader=e.currentTarget  as  URLLoader;
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onIOError);
			loader.removeEventListener("complete",onDataComplete);
			loader=null;
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		public function get data():Array {
			return _data;
		}
	}
}