package com.colorhook.media.audioPlayer.utils{
	

	
	/**
	 * @version 1.0
	 * @author	 colorhook
	 * @description LRCLoader is a lrc file loader and parser, it convert lyric to Array
	 */
	 
	 
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.EventDispatcher;
	import flash.net.URLStream;
	import flash.net.URLRequest;
	
	
	
	[Event(name="complete",type="flash.events.Event")]
	
	
	public class LRCLoader extends EventDispatcher{
		
		protected var stream:URLStream;
		
		private var _artist:String;
		private var _songName:String;
		private var _album:String;
		private var _offset:Number;
		private var _creater:String;
		private var _lrcData:Array=new Array;
		private var _charset:String;
		
		/**
		 *	Constructor
		 */
		public function LRCLoader():void{
			init();
		}
		
		
		private function init():void{
			configStream();
		}
		
		private function configStream():void{
			stream=new URLStream;
			stream.addEventListener("complete",onLrcComplete);
			stream.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onSecurityError);
			stream.addEventListener(IOErrorEvent.IO_ERROR,onIoErrorEvent);
		}
		
		private function resetInfo():void{
			_songName="";
			_artist="";
			_album="";
			_offset=0;
			_creater="";
			_lrcData=new Array;
		}
		
		private function parseLRCInfo(list:Array):void{
            var item:String;
            var tempArr:Array;
			for(var i:int=0;i<list.length;i++){
				item=StringUtil.trim(list[i]);
				tempArr=item.split(":");
				if(tempArr.length<2){
					list.splice(i--,1);
					continue;
				}
				var paramArr:Array=tempArr[0].split("[");
				var param:String="";
				var paramValue:String=StringUtil.trim(tempArr[1].split("]")[0]);
				if(paramArr.length>1){
					param=StringUtil.trim(paramArr[1]);
				}
					
                switch(param.toLocaleLowerCase()) {
                    case "ar":
                        this._artist = paramValue;
                        list.splice(i--, 1);
                        break;   
                    case "ti":
                        this._songName = paramValue;
                        list.splice(i--, 1);
                        break;
                    case "al":
                        this._album = paramValue;
                        list.splice(i--, 1);
                        break;
                    case "by":
                        this._creater = paramValue;
                        list.splice(i--, 1);
                        break;
                    case "offset":       
                        this._offset = parseInt(paramValue);
                        list.splice(i--, 1);
                        break;
                    default:
                        break;  
                }
            }
        }
		private function trimArray(list:Array):void{
			 for(var i:int=0;i<list.length;i++){
				var item:String=StringUtil.trim(list[i]);
				var tempArr:Array=item.split("]");
				 for (var j:int=0;j<tempArr.length;j++){
					 var subItem:String=StringUtil.trim(tempArr[j]);
					 tempArr[j]=subItem;
				 }
				 item=tempArr.join("]");
				 list[i]=item;
			 }
		}
		
		protected function createLrcList(list:Array):void{
			for(var i:int=0;i<list.length;i++){
				var item:String=list[i];
				var timeArr:Array=item.split("]");
				if(timeArr.length<2){
					continue;
				}
				var lyric:String=timeArr[timeArr.length-1];
				if(lyric==null) lyric="";
				for(var j:int=0;j<timeArr.length-1;j++){
					var timeStr:String=timeArr[j].split("[")[1];
					var time:Number=StringUtil.convertToTime(timeStr);
					if(!isNaN(time))
					_lrcData.push({time:time,lyric:lyric});
				}
				
			}
			_lrcData.sortOn("time", Array.NUMERIC);
		}
		
		
		/**
		 * load a lyric file use this method
		 *	@param 		path			the URI of the lyric file to load
		 *	@param 		charset		the charset used to load the file, default is GB2312.
		 */
		public function load(path:String,charset:String="gb2312"):void{
			this._charset=charset;
			stream.load(new URLRequest(encodeURI(path)));
		}
		
		/**
		 * close the stream;
		 */
		public function close():void{
			if(stream.connected)
			stream.close();
		}
		
		public function get connected():Boolean{
			return stream.connected;
		}
		
		public function parseLRCData(data:String):void{
			resetInfo();
			var dataArr:Array=data.split("\r\n");
			trimArray(dataArr);
			parseLRCInfo(dataArr);
			createLrcList(dataArr);
		}
		
		
		
		private function onLrcComplete(e:Event):void{
			var data:String=stream.readMultiByte(stream.bytesAvailable,_charset);
			parseLRCData(data);
			dispatchEvent(new Event("complete"));
		}
		
		private function onSecurityError(e:Event):void{
			dispatchEvent(new SecurityErrorEvent(SecurityErrorEvent.SECURITY_ERROR));
		}
		
		private function onIoErrorEvent(e:Event):void{
			dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
		}
		
		
		public function get songName():String{
			return _songName;
		}
		public function get artist():String{
			return _artist;
		}
		public function get album():String{
			return  _album;
		}
		public function get creater():String{
			return _creater;
		}
		public function get  offset():Number{
			return _offset;
		}
		public function set offset(value:Number):void{
			_offset=value;
		}
		
		/**
		 *	After loading the lyric file, call this method to get a lyric Array sort by time.
		 */
		public function get lrcData():Array{
			return _lrcData;
		}
		
	}
}


class StringUtil{
	 
	 
	 public static function trim(str:String):String{
        if (str == null) return '';
        
        var startIndex:int = 0;
        while (isWhitespace(str.charAt(startIndex)))
            ++startIndex;

        var endIndex:int = str.length - 1;
        while (isWhitespace(str.charAt(endIndex)))
            --endIndex;

        if (endIndex >= startIndex)
            return str.slice(startIndex, endIndex + 1);
        else
            return "";
    }
	 
	 public static function isWhitespace(character:String):Boolean{
        switch (character)
        {
            case " ":
            case "\t":
            case "\r":
            case "\n":
            case "\f":
                return true;

            default:
                return false;
        }
    }
	 public static function  convertToTime(str:String):int{
		   	var timeArr1:Array;
            var timeArr2:Array;
            var result:int;
            timeArr1 = str.split(":");
            timeArr2 = timeArr1[1].split(".");
            if (timeArr2.length < 2){
                timeArr2.push("00");
            }
            result = parseInt(timeArr1[0]) * 60000;
            result = result + parseInt(timeArr2[0]) * 1000;
            result = result + parseInt(timeArr2[1]) * 10;
            return result;
	 }
}
