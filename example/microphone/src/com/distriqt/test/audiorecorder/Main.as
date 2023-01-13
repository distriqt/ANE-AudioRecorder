/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * @file   		Main.as
 * @brief  		
 * @author 		Michael Archbold (https://github.com/marchbold)
 * @created		08/01/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.audiorecorder
{
	import feathers.controls.Button;
	import feathers.controls.ScrollContainer;
	import feathers.layout.HorizontalAlign;
	import feathers.layout.VerticalAlign;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Color;
	
	/**	
	 * 
	 */
	public class Main extends Sprite implements ILogger
	{
		////////////////////////////////////////////////////////
		//	CONSTANTS
		//
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private var _tests		: AudioRecorderTests;

		private var _text		: TextField;
		private var _container	: ScrollContainer ;
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		
		/**
		 *  Constructor
		 */
		public function Main()
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		
		public function log( tag:String, message:String ):void
		{
			trace( tag+"::"+message );
			if (_text)
				_text.text = tag+"::"+message + "\n" + _text.text ;
		}
		
		
		////////////////////////////////////////////////////////
		//	INTERNALS
		//
		
		
		private function createUI():void
		{
			var tf:TextFormat = new TextFormat( "_typewriter", 12, Color.WHITE, HorizontalAlign.LEFT, VerticalAlign.TOP );
			_text = new TextField( stage.stageWidth, stage.stageHeight, "", tf );
			_text.y = 40;
			_text.touchable = false;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = HorizontalAlign.RIGHT;
			layout.verticalAlign = VerticalAlign.BOTTOM;
			layout.gap = 5;
			
			_container = new ScrollContainer();
			_container.layout = layout;
			_container.y = 50;
			_container.width = stage.stageWidth;
			_container.height = stage.stageHeight-50;
			
			
			_tests = new AudioRecorderTests( this );

			addAction( "Status :Auth", _tests.authStatus );
			addAction( "Request :Auth", _tests.authRequest );
			
			addAction( "Start :Recorder", _tests.start );
			addAction( "Stop :Recorder", _tests.stop );
			
			addAction( "Play :Playback", _tests.play );
			
			addAction( "Init :MediaPlayer", _tests.mediaPlayer_init );
			addAction( "Play :MediaPlayer", _tests.mediaPlayer_play );
			
			addAction( "Start :FlashMic", _tests.startMicrophoneRecording );
			addAction( "Stop :FlashMic", _tests.stopMicrophoneRecording );
			addAction( "Playback :FlashMic", _tests.playMicrophoneRecording );
			
			addAction( "Native Tests", _tests.nativeTests );
			
			addChild( _tests );
			addChild( _text );
			addChild( _container );
		}
		
		
		private function addAction( label:String, listener:Function ):void
		{
			var b:Button = new Button();
			b.label = label;
			b.addEventListener( starling.events.Event.TRIGGERED, listener );
			_container.addChild(b);
		}
		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler );
			new MetalWorksMobileTheme();
			createUI();
		}
		
		
	}
}