package com.colorhook.media.audioPlayer.view{
	
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**
	 * @version	 1.0
	 * @author colrohook
	 * 
	 *	歌词拖曳同步效果
	 * 歌词垂直分布，类似千千静听风格
	 *
	 */
	public class VerticalLRC extends Sprite implements ILRC{
		
		private var _position:Number;
		private var _minPosition:Number;
		private var _maxPosition:Number;
		private var _itemWidth:Number;
		private var _itemHeight:Number;
		private var _lrcOffset:Number;
		private var _index:Number;
		private var _themeColor:uint;
		private var _highlightColor:uint;
		private var _textFormat:TextFormat;
		private var _currentItem:TextField;
		private var _dataProvider:Array;
		protected var itemMap:Array;

		protected var container:Sprite;
		
		public function VerticalLRC(){
			initialize();
		}
		
		private function initialize():void{
			_itemWidth=300;
			_itemHeight=18;
			_themeColor=0xCCCCCC;
			_highlightColor=0x00EE00;
			_textFormat=new TextFormat();
			_textFormat.font="Verdana";
			_textFormat.size=12;
			_textFormat.align="center";
			container=new Sprite;
			addChild(container);
		}
		
		private function dispose():void{
			_position=0;
			_index=0;
			_minPosition=0;
			_maxPosition=0;
			_lrcOffset=0;
			_currentItem=null;
			itemMap=new Array;
			while(container.numChildren>0){
				container.removeChildAt(0);
			}
		}
		
		private function buildData():void{
			dispose();
			for(var i:int=0;i<_dataProvider.length;i++){
				if(_dataProvider[i]["time"]==null||_dataProvider[i]["lyric"]==null){
					continue;
				}
				var tf:TextField=new TextField;
				tf.selectable=false;
				tf.y=_itemHeight*i;
				tf.height=_itemHeight;
				tf.width=_itemWidth;
				tf.textColor=_themeColor;
				tf.text=_dataProvider[i]["lyric"];
				tf.setTextFormat(_textFormat);
				container.addChild(tf);
				itemMap.push({time:_dataProvider[i]["time"]+_lrcOffset,item:tf});
			}
			_minPosition=_dataProvider[0]["time"];
			_maxPosition=_dataProvider[_dataProvider.length-1]["time"];
			
		}
		
		
		/*public function percentMove(value:Number):void{
			
			if(isNaN(value)){
				return;
			}
			value=value<0?0:value;
			value=value>100?100:value;

			var expectPos:Number=value*(itemMap.length-1)/100;
			var nearIndex:int=Math.floor(expectPos);
			
			var currTime:Number=Number(itemMap[nearIndex].time);
			var nextTime:Number;
			if(nearIndex==itemMap.length-1){
				nextTime=currTime;
			}else{
				nextTime=itemMap[nearIndex+1].time;
			}
			
			var offset:Number=(expectPos-nearIndex)*(nextTime-currTime);
			if(isNaN(offset)||offset==Infinity){
				offset=0;
			}
			position=itemMap[nearIndex].time+offset;
		}*/
		
		public function move(offset:Number):void{
			var newPos:Number=container.y+offset;
			var maxY=-(itemMap.length-1)*_itemHeight;
			if(newPos>0){
				newPos=0;
			}else if(newPos<maxY){
				newPos=maxY;
			}
			container.y=newPos;
			renderPosition();
		}
		
		
		public function renderPosition():void{
			var expectPos:Number=-container.y/_itemHeight;
			var nearIndex:int=Math.floor(expectPos);
			
			var currTime:Number=Number(itemMap[nearIndex].time);
			var nextTime:Number;
			if(nearIndex==itemMap.length-1){
				nextTime=currTime;
			}else{
				nextTime=itemMap[nearIndex+1].time;
			}
			
			var offset:Number=(expectPos-nearIndex)*(nextTime-currTime);
			if(isNaN(offset)||offset==Infinity){
				offset=0;
			}
			position=itemMap[nearIndex].time+offset;
		}
		
		protected function update(value:Number):void{
			if(_dataProvider==null){
				return;
			}
			if(!samePositionIndex(value,_index)){
				_index=searchPositionIndex(value);
				if(_currentItem!=null){
					_currentItem.textColor=_themeColor;
				}
			}
			
			if(_index>=0){
				_currentItem=itemMap[_index].item as TextField;
				_currentItem.textColor=_highlightColor;
			}else{
				_index=0;
				_currentItem=itemMap[_index].item;
			}
			_position=value;
			var offset:Number=computeOffset();
			container.y=-(_currentItem.y+offset);
		}

		private function computeOffset():Number{
			var floorPos:Number=itemMap[_index].time;
			var ceilPos:Number;
			if(_index==itemMap.length-1){
				ceilPos=_maxPosition;
			}else{
				ceilPos=itemMap[_index+1].time;
			}
			var diff:Number=_position-floorPos;
			var len:Number=ceilPos-floorPos;
			var result=diff/len*_itemHeight;
			if(isNaN(result)||result==Infinity){
				result=0;
			}
			return result;
		}

		private function samePositionIndex($position,$index):Boolean{
			var floorPos:Number=itemMap[$index].time;
			
			var ceilPos:Number;
			if($index==itemMap.length-1){
				ceilPos=floorPos+10000;
			}else{
				ceilPos=itemMap[$index+1].time;
			}
			var result:Boolean=false;
			if($position>=floorPos&&$position<ceilPos){
				result=true;
			}
			return result;
		}

		private function searchPositionIndex(value:Number):int{
			if(value>=_maxPosition){
				return itemMap.length-1;
				
			}else if(value<_minPosition){
				return -1;
			}
			var middleIndex:int=Math.floor(value/_maxPosition*itemMap.length);
			var offset:Number=1;
			if(itemMap[middleIndex].time>value){
				offset=-1;
			}
			var searching:Boolean=true
			while(searching){
				if(samePositionIndex(value,middleIndex)){
					return middleIndex;
				}
				middleIndex+=offset;
			}
			return 0;		
		}
		/*
		 * getter&setter themeColor
		 */
		public function set themeColor(value:uint):void{
			if(_themeColor==value){
				return;
			}
			_themeColor=value;
			if(itemMap==null){
				return;
			}
			for(var i:int=0;i<itemMap.lenght;i++){
				var tf:TextField=itemMap[i] as TextField;
				tf.textColor=_themeColor;
			}
			_currentItem.textColor=_highlightColor;
		}
		
		public function get themeColor():uint{
			return _themeColor;
		}
		
		/*
		 * getter&setter highlightColor
		 */
		public function set highlightColor(value:uint):void{
			if(_highlightColor==value){
				return;
			}
			_highlightColor=value;
			if(_currentItem==null){
				return;
			}
			_currentItem.textColor=_highlightColor;
		}
		
		public function get highlightColor():uint{
			return _highlightColor;
		}
		
		
		/*
		 * getter&setter dataProvider
		 */
		public function get dataProvider():Array{
			return _dataProvider;
		}
		
		public function set dataProvider(data:Array):void{
			if(data==null){
				dispose();
				_dataProvider=null;
				return;
			}
			var lastItem:*=data[data.length-1];
			_dataProvider=data.concat([{time:lastItem.time+36000,lyric:""}]);
			buildData();
		}
		
		
		/*
		 * Define by interface ILRC
		 * use this method to render the lyric.
		 */
		public function set position(value:Number):void{
			if(value<0){
				value=0;
			}
			update(value);
		}
		
		/*
		 * Define by interface ILRC
		 * use this method to get the position of lyric.
		 */
		public function get position():Number{
			return _position;
		}
		
		public function get lrcOffset():Number{
			return _lrcOffset;
		}
		public function set lrcOffset(value:Number):void{
			 _lrcOffset=value;
			 if(itemMap!=null&&_dataProvider!=null){
				 for(var i:int=0;i<itemMap.length;i++){
					 itemMap[i].time=_dataProvider[i]["time"]+_lrcOffset;
				 }
			 }
		}
		
	}
}