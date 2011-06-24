package com.colorhook.app.mp3player.mediator{
	
	
	/**
	 * @author colorhook
	 * 
	 * @version 1.0
	 * 
	 * @description  the list module of Mp3 Player, you can switch to play another sound by click the sound list in this module.
	 */
	 
	 
	import fl.controls.List;
	import fl.data.DataProvider;
	import fl.events.ListEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	
	import com.colorhook.app.mp3player.mediator.IMediator;
	import com.colorhook.app.mp3player.style.CustomCellRenderer;
	import com.colorhook.media.audioPlayer.model.PlayerModel;
	import com.colorhook.media.audioPlayer.events.PlayerEvent;
	import com.colorhook.media.audioPlayer.PlayerFacade;
	
	public class ListModuleMediator implements IMediator{
		
		
		protected var viewComponent:*;
		private var model:PlayerModel;

		 public function ListModuleMediator(viewComponent:*=null):void{
			this.viewComponent=viewComponent;
			model=PlayerModel.getInstance();
			setupUI();
		}
		
		
		private function setupUI():void{
			dirList=view.mainList as List;
			soundList = view.list as List;
			divideBar = view.divideBar as SimpleButton;
			dirList.setStyle("cellRenderer",CustomCellRenderer)
			soundList.setStyle("cellRenderer",CustomCellRenderer)
			setupData();
			setupAction();
		}
		
		
		private var startX:Number;
		private var dirList:List;
		private var soundList:List;
		private var focusDirItem:*;
		private var focusSoundItem:*;
		private var divideBar:SimpleButton;
		public var data:*;
		
		private function setupData():void{	
			data = model.data;
			fillDirList();
			fillSoundList();
		}
		
		/**
		 * fill the dirList by sound group information.
		 */
		private function fillDirList():void{
			var dp1:DataProvider=new DataProvider;
			for(var i:int=0;i<data.length;i++){
				dp1.addItem({label:data[i].type,data:data[i].type});
			}
			dirList.dataProvider=dp1;
			dirList.selectedIndex=0;
			if(dp1.length>0)
			setDirHighlight(model.groupIndex);
		}
		
		/**
		 * fill the dirList by sounds information.
		 */
		private function fillSoundList():void{
			var dp2:DataProvider=new DataProvider;
			var currentListData:Array=model.currentListData;
			if(currentListData==null){
				return;
			}
			for(var j:int=0;j<currentListData.length;j++){
				dp2.addItem({label:currentListData[j].name,data:currentListData[j].name});
			}
			soundList.dataProvider=dp2;
		}
		
		private function setupAction():void{
			dirList.addEventListener(Event.CHANGE,dirChangeHandler,false,0,true);
			dirList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,dirChangeHandler,false,0,true);
			soundList.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, listChangeHandler, false, 0, true);
			divideBar.addEventListener(MouseEvent.MOUSE_DOWN,startDragDivideBar,false,0,true);
			model.addEventListener(PlayerEvent.SOUND_CHANGE,soundChangeHandler,false,0,true)
		}
		
		private function dirChangeHandler(e:Event):void{
			var selectedDirIndex:Number=dirList.selectedIndex;
			var tempIndex:Number=model.groupIndex;
			model.groupIndex=selectedDirIndex;
			fillSoundList();
			model.groupIndex=tempIndex;
			setSoundHighlight(model.itemIndex);
			if(e.type==Event.CHANGE){
				//do nothing while click the item.
			}else{
				setDirHighlight(selectedDirIndex);
				var playerFacade:PlayerFacade=PlayerFacade.getInstance();
				playerFacade.changeListType(selectedDirIndex);
			}
			
		}
		

		private function startDragDivideBar(e:MouseEvent):void{
			startX=divideBar.x
			divideBar.addEventListener(MouseEvent.MOUSE_UP,stopDragDivideBar,false,0,true);
			view.stage.addEventListener(MouseEvent.MOUSE_UP,stopDragDivideBar,false,0,true);
			view.addEventListener(Event.ENTER_FRAME,renderListPosition,false,0,true)
		}

		private function stopDragDivideBar(e:MouseEvent):void{
			view.removeEventListener(Event.ENTER_FRAME,renderListPosition)
			divideBar.removeEventListener(MouseEvent.MOUSE_UP,stopDragDivideBar);
			view.stage.removeEventListener(MouseEvent.MOUSE_UP,stopDragDivideBar);
		}

		private function renderListPosition(e:Event):void{
			var stopX:Number;
			if(view.mouseX<6){
				stopX=6;
			}else if(view.mouseX>300){
				stopX=300;
			}else{
				stopX=view.mouseX-divideBar.width/2;
			}
			divideBar.x=stopX;
			dirList.width=stopX-7;
			soundList.x=stopX+6;
			soundList.width=297-stopX;
		}
		
		private function listChangeHandler(e:Event):void{
			if(model.groupIndex!=dirList.selectedIndex){
				model.groupIndex=dirList.selectedIndex;
				setDirHighlight(model.groupIndex);
			}
			var selectedIndex:int=soundList.selectedIndex
			var playerFacade:PlayerFacade=PlayerFacade.getInstance();
			playerFacade.playSoundAt(selectedIndex);
		}
		
		
		private function soundChangeHandler(e:PlayerEvent):void{
			var selectedIndex:int=model.itemIndex;
			setSoundHighlight(selectedIndex);
		}

		private function setDirHighlight(index:int):void{
			if(focusDirItem!=null){
				focusDirItem.label=focusDirItem.data;
			}
			var item:*=dirList.getItemAt(index);
			item.label="<font color='#00CCFF'>"+item.data+"</font>";
			focusDirItem=item;
			dirList.validateNow();
		}
		
		private function setSoundHighlight(index:int):void{
			if(dirList.selectedIndex!=model.groupIndex||model.itemLength==0){
				return;
			}
			if(focusSoundItem!=null){
				focusSoundItem.label=focusSoundItem.data;
			}
			var item:*=soundList.getItemAt(index);
			item.label="<font color='#00CCFF'>"+item.data+"</font>";
			focusSoundItem=item;
			soundList.validateNow();
		}
		
		/**
		 * @getter 
		 * return the movie clip relative.
		 */
		public function get view():MovieClip{
			return viewComponent as MovieClip;
		}
	
		public function onRegister():void{
		}
		public function onRemove():void{
		}
	}
	
}