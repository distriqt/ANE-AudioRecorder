
## Playback Recorded Audio

Once recorded you should be able to playback the recording using the standard AIR `NetStream` class:


```as3
var file:File = ...; // The file reference for the recording

var _nc:NetConnection = null;
var _ns:NetStream = null;
		
function play( file:File ):void
{
	if (file.exists)
	{
		if (_nc == null)
		{
			_nc = new NetConnection();
			_nc.connect(null);
		}
		_ns = new NetStream( _nc );
		_ns.client = new Object();
		_ns.play( "file://"+ file.nativePath );
	}
	else
	{
		trace( "ERROR: file doesn't exist" );
	}
}
```


