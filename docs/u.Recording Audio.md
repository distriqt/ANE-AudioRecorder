
## Recording Audio


### Start

To start recording audio you create an instance of the `AudioRecorderOptions` and call `start`.

The options allow you to specify the output file along with audio formats and other recording 
settings.

```as3
var file:File = File.applicationStorageDirectory.resolvePath( "recording.m4a" );

var options:AudioRecorderOptions = new AudioRecorderOptions();
options.filename = file.nativePath;
options.audioEncoding = AudioEncoder.AAC;

AudioRecorder.service.start( options );
```

### Stop

Once you have finished recording you call the `stop` function to complete the recording.

```as3
AudioRecorder.service.stop();
```


### Events

There are several events that are dispatched at various points through the recording
defined by the `AudioRecorderEvent` class.

- `AudioRecorderEvent.START` : Dispatched when recording starts
- `AudioRecorderEvent.COMPLETE` : Dispatched when recording completes
- `AudioRecorderEvent.PROGRESS` : Dispatched at periodic intervals while recording


You listen for these events as below:

```as3
AudioRecorder.service.addEventListener( AudioRecorderEvent.START, audioRecorderEventHandler );
AudioRecorder.service.addEventListener( AudioRecorderEvent.COMPLETE, audioRecorderEventHandler );
AudioRecorder.service.addEventListener( AudioRecorderEvent.PROGRESS, audioRecorderEventHandler );
```

Example event handler:

```as3
private function audioRecorderEventHandler( event:AudioRecorderEvent ):void
{
	trace( event.type );
}
```




