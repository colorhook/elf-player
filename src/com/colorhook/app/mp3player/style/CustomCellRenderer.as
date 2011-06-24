package com.colorhook.app.mp3player.style {
	
	
	
	/**
	 * @author colorhook
	 * 
	 * @version	 1.0
	 * 
	 * @description  used to create a list which label is html text format.
	 */
	
	import fl.controls.listClasses.CellRenderer;
	import flash.text.TextFormat;
	
	public class CustomCellRenderer extends CellRenderer{
		
		
		public function CustomCellRenderer(){
			super();
			var format:TextFormat=new TextFormat();
			format.font="Verdana";
			format.size=12;
			format.color=0xEEEEEE;
			this.setStyle("textFormat",format);
		}
		
		/**
		 * set the label by html text.
		 */
		override protected function drawLayout():void {
			super.drawLayout();
			textField.htmlText=textField.text;
		}
		
	}
}