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
 * This is a test application for the distriqt extension
 * 
 * @author Michael Archbold & Shane Korin
 * 	
 */
package
{
	import com.distriqt.extension.audiorecorder.AudioEncoder;
	import com.distriqt.extension.audiorecorder.AudioRecorder;
	import com.distriqt.extension.audiorecorder.AudioRecorderOptions;
	import com.distriqt.extension.audiorecorder.AuthorisationStatus;
	import com.distriqt.extension.audiorecorder.events.AudioRecorderEvent;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	
	/**	
	 * Sample application for using the AudioRecorder Native Extension
	 */
	public class TestAudioRecorder extends Sprite
	{
		
		/**
		 * Class constructor 
		 */	
		public function TestAudioRecorder()
		{
			super();
			create();
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		
		private var _text		: TextField;
		
		
		//
		//	INITIALISATION
		//	
		
		private function create( ):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			

			var tf:TextFormat = new TextFormat();
			tf.size = 24;
			_text = new TextField();
			_text.defaultTextFormat = tf;
			addChild( _text );

			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
		}
		
		
		private function init( ):void
		{
			try
			{
				message( "AudioRecorder Supported: " + AudioRecorder.isSupported );
				message( "AudioRecorder Version:   " + AudioRecorder.service.version );
				
				//
				//	Add test inits here
				//
				
				AudioRecorder.service.addEventListener( AudioRecorderEvent.COMPLETE, audioRecorder_completeHandler );
			}
			catch (e:Error)
			{
				message( "ERROR::"+e.message );
			}
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
		}
		
		
		//
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			//
			//	Start / stop recording when user clicks screen?
			//
			if (!AudioRecorder.service.hasAuthorisation())
			{
				switch (AudioRecorder.service.authorisationStatus())
				{
					case AuthorisationStatus.AUTHORISED:
						message( "authorised" );
						break;
					
					case AuthorisationStatus.SHOULD_EXPLAIN:
					case AuthorisationStatus.NOT_DETERMINED:
						AudioRecorder.service.requestAuthorisation();
						break;
					
					case AuthorisationStatus.DENIED:
					case AuthorisationStatus.RESTRICTED:
					case AuthorisationStatus.UNKNOWN:
						message( "denied or restricted" );
				}
			}
			else if (!AudioRecorder.service.isRecording())
			{
				var file:File = File.applicationStorageDirectory.resolvePath("recording.m4a");
				
				var options:AudioRecorderOptions = new AudioRecorderOptions();
				options.filename = file.nativePath;
				options.audioEncoding = AudioEncoder.VORBIS;
				
				AudioRecorder.service.start( options );
			}
			else
			{
				AudioRecorder.service.stop();
			}
		}
		
		
		private var _nc:NetConnection = null;
		private var _ns:NetStream = null;
		
		private function audioRecorder_completeHandler( event:AudioRecorderEvent ):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath("recording.m4a");
			
			if (_nc == null)
			{
				_nc = new NetConnection();
				_nc.connect(null);
			}
			_ns = new NetStream( _nc );
			_ns.client = new Object();
			_ns.play( "file://"+file.nativePath );
		}
		
		
	}
}

