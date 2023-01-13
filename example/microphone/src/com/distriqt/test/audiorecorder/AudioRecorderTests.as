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
 * @author 		Michael Archbold (https://github.com/marchbold)
 * @created		08/01/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.audiorecorder
{
	import com.distriqt.extension.audiorecorder.AudioEncoder;
	import com.distriqt.extension.audiorecorder.AudioRecorder;
	import com.distriqt.extension.audiorecorder.AudioRecorderOptions;
	import com.distriqt.extension.audiorecorder.AuthorisationStatus;
	import com.distriqt.extension.audiorecorder.OutputFormat;
	import com.distriqt.extension.audiorecorder.events.AudioRecorderEvent;
	import com.distriqt.extension.audiorecorder.events.AuthorisationEvent;
	import com.distriqt.extension.mediaplayer.MediaPlayer;
	import com.distriqt.extension.mediaplayer.events.MediaPlayerEvent;
	import com.distriqt.extension.mediaplayer.sound.SoundChannel;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.events.SampleDataEvent;
	import flash.events.StatusEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.media.AudioDecoder;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	import flash.utils.setTimeout;
	
	import starling.core.Starling;
	
	import starling.display.Image;
	import starling.display.Sprite;
	
	/**	
	 */
	public class AudioRecorderTests extends Sprite
	{
		public static const TAG:String = "";
		
		private var _l:ILogger;
		
		
		private function log( log:String ):void
		{
			_l.log( TAG, log );
		}
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function AudioRecorderTests( logger:ILogger )
		{
			_l = logger;
			try
			{
				
				log( "AudioRecorder Supported: " + AudioRecorder.isSupported );
				if (AudioRecorder.isSupported)
				{
					log( "AudioRecorder Version:   " + AudioRecorder.service.version );
					
					AudioRecorder.service.addEventListener( AudioRecorderEvent.START, audioRecorderEventHandler );
					AudioRecorder.service.addEventListener( AudioRecorderEvent.COMPLETE, audioRecorderEventHandler );
					AudioRecorder.service.addEventListener( AudioRecorderEvent.PROGRESS, audioRecorderEventHandler );
					
				}
				
			}
			catch (e:Error)
			{
				trace( e );
			}
		}
		
		
		////////////////////////////////////////////////////////
		//  AUTHORISATION
		//
		
		public function authStatus():void
		{
			log( AudioRecorder.service.authorisationStatus() );
		}
		
		
		public function authRequest():void
		{
			switch (AudioRecorder.service.authorisationStatus())
			{
				case AuthorisationStatus.AUTHORISED:
					log( "authorised" );
					break;
				
				case AuthorisationStatus.SHOULD_EXPLAIN:
				case AuthorisationStatus.NOT_DETERMINED:
					AudioRecorder.service.addEventListener( AuthorisationEvent.CHANGED, authChangedHandler );
					AudioRecorder.service.requestAuthorisation();
					break;
				
				case AuthorisationStatus.DENIED:
				case AuthorisationStatus.RESTRICTED:
				case AuthorisationStatus.UNKNOWN:
					log( "denied or restricted" );
			}
		}
		
		
		private function authChangedHandler( event:AuthorisationEvent ):void
		{
			log( "authChangedHandler( " + event.status + " )" );
		}
		
		
		////////////////////////////////////////////////////////
		//  RECORDING
		//
		
		private var _file:File = File.applicationStorageDirectory.resolvePath( "recording.m4a" );
		
		
		public function start():void
		{
			if (AudioRecorder.service.hasAuthorisation())
			{
				var options:AudioRecorderOptions = new AudioRecorderOptions();
				options.filename = _file.nativePath;
				
				var success:Boolean = AudioRecorder.service.start( options );
				
				log( "start(): " + success );
			}
			else
			{
				log( "Not authorised" );
			}
		}
		
		
		public function stop():void
		{
			if (AudioRecorder.service.hasAuthorisation())
			{
				var success:Boolean = AudioRecorder.service.stop();
				log( "stop(): " + success );

//				AudioRecorder.service.removeEventListener( AudioRecorderEvent.START, audioRecorderEventHandler );
//				AudioRecorder.service.removeEventListener( AudioRecorderEvent.COMPLETE, audioRecorderEventHandler );
//				AudioRecorder.service.removeEventListener( AudioRecorderEvent.PROGRESS, audioRecorderEventHandler );
			}
			else
			{
				log( "Not authorised" );
			}
		}
		
		
		private function audioRecorderEventHandler( event:AudioRecorderEvent ):void
		{
			log( event.type );
		}
		
		
		////////////////////////////////////////////////////////
		//  PLAYBACK
		//
		
		private var _nc:NetConnection = null;
		private var _ns:NetStream = null;
		
		
		public function play():void
		{
			log( "play()" );
			
			if (_file.exists)
			{
				log( "\tnativePath: " + _file.nativePath );
				log( "\turl:  " + _file.url );
				log( "\tsize: " + _file.size );
				
				if (_nc == null)
				{
					_nc = new NetConnection();
					_nc.connect( null );
				}
				_ns = new NetStream( _nc );
				_ns.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
				_ns.client = new Object();
				_ns.play( "file://" + _file.nativePath );
//				_ns.play( _file.url );
			}
			else
			{
				log( "ERROR: file doesn't exist" );
			}
			
		}
		
		
		private function netStatusHandler( event:NetStatusEvent ):void
		{
			log( "netStatusHandler( " + event.info.code + " )" );
		}
		
		
		////////////////////////////////////////////////////////
		//	MEDIA PLAYER
		//
		
		public function mediaPlayer_init():void
		{
			log( "mediaPlayer_init()" );
		}
		
		
		public function mediaPlayer_play():void
		{
			log( "mediaPlayer_play()" );
			if (_file.exists)
			{
				log( "\tnativePath: " + _file.nativePath );
				log( "\turl:  " + _file.url );
				log( "\tsize: " + _file.size );
				
				MediaPlayer.service.createPlayer( _file.nativePath, 0, 0, 320, 100, true );
				MediaPlayer.service.addEventListener( MediaPlayerEvent.COMPLETE, mediaPlayer_completeHandler );
			}
			else
			{
				log( "ERROR: file doesn't exist" );
			}
		}
		
		
		private function mediaPlayer_completeHandler( event:MediaPlayerEvent ):void
		{
			MediaPlayer.service.removePlayer();
		}
		
		
		////////////////////////////////////////////////////////
		//	FLASH MICROPHONE
		//
		
		private var _soundBytes:ByteArray;
		private var _microphone:Microphone;
		
		
		public function startMicrophoneRecording():void
		{
			if (_soundBytes != null) _soundBytes.clear();
			_soundBytes = new ByteArray();
			
			_microphone = Microphone.getMicrophone();
			_microphone.setSilenceLevel( 0 );
			_microphone.gain = 50;
			_microphone.rate = 44;
//			_microphone.setUseEchoSuppression(true);
			
			_microphone.addEventListener( StatusEvent.STATUS, onMicStatus );
			_microphone.addEventListener( SampleDataEvent.SAMPLE_DATA, micSampleDataHandler );
		}
		
		
		public function stopMicrophoneRecording():void
		{
			if (_microphone != null)
			{
				_microphone.removeEventListener( StatusEvent.STATUS, onMicStatus );
				_microphone.removeEventListener( SampleDataEvent.SAMPLE_DATA, micSampleDataHandler );
				_microphone = null;
			}
		}
		
		
		private function onMicStatus( event:StatusEvent ):void
		{
			log( "MicrophoneStatus: " + event.code );
		}
		
		
		private function micSampleDataHandler( event:SampleDataEvent ):void
		{
			while (event.data.bytesAvailable)
			{
				var sample:Number = event.data.readFloat();
				_soundBytes.writeFloat( sample );
			}
		}
		
		
		private var _sound:flash.media.Sound;
		private var _channel:flash.media.SoundChannel;
		
		
		public function playMicrophoneRecording():void
		{
			_soundBytes.position = 0;
			
			_sound = new Sound();
			_sound.addEventListener( SampleDataEvent.SAMPLE_DATA, playbackSampleHandler );
			_channel = _sound.play();
			_channel.addEventListener( Event.SOUND_COMPLETE, playbackComplete );
		}
		
		
		private function playbackSampleHandler( event:SampleDataEvent ):void
		{
			for (var i:int = 0; i < 8192 && _soundBytes.bytesAvailable > 0; i++)
			{
				var sample:Number = _soundBytes.readFloat();
				event.data.writeFloat( sample );
				event.data.writeFloat( sample );
			}
		}
		
		
		private function playbackComplete( event:Event ):void
		{
			log( "Playback finished." );
			_sound.removeEventListener( SampleDataEvent.SAMPLE_DATA, playbackSampleHandler );
			_channel.removeEventListener( Event.SOUND_COMPLETE, playbackComplete );
			_channel.stop();
		}
		
		
		
		
		
		public function nativeTests():void
		{
			AudioRecorder.service.performAudioTests();
		}
		
		
	}
	
	
}
