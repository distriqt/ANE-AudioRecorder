## Add the Extension

First step is always to add the extension to your development environment. 
To do this use the tutorial located [here](http://airnativeextensions.com/knowledgebase/tutorial/1).


## Required ANEs

### Core ANE

The Core ANE is required by this ANE. You must include and package this extension in your application.

The Core ANE doesn't provide any functionality in itself but provides support libraries and frameworks used by our extensions.
It also includes some centralised code for some common actions that can cause issues if they are implemented in each individual extension.

You can access this extension here: https://github.com/distriqt/ANE-Core.


### Android Support ANE

Due to several of our ANE's using the Android Support library the library has been separated 
into a separate ANE allowing you to avoid conflicts and duplicate definitions.
This means that you need to include the some of the android support native extensions in 
your application along with this extension. 

You will add these extensions as you do with any other ANE, and you need to ensure it is 
packaged with your application. There is no problems including this on all platforms, 
they are just **required** on Android.

This ANE requires the following Android Support extensions:

- [com.distriqt.androidsupport.V4.ane](https://github.com/distriqt/ANE-AndroidSupport/raw/master/lib/com.distriqt.androidsupport.V4.ane)

You can access these extensions here: https://github.com/distriqt/ANE-AndroidSupport.



## Android Manifest Additions

The AudioRecorder ANE requires a few additions to the manifest to be able to 
start certain activities and get access to the users microphone.

You should add the listing below to your manifest, take particular attention to 
the `RECORD_AUDIO` which is required to access to users microphone and the 
`AuthorisationActivity` which is required on recent versions of Android to 
request permissions at runtime.


```xml
<manifest android:installLocation="auto">
	<uses-permission android:name="android.permission.INTERNET"/>
	
	<uses-permission android:name="android.permission.RECORD_AUDIO"/>
	<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>

	<application>

		<activity android:name="com.distriqt.extension.audiorecorder.permissions.AuthorisationActivity" android:theme="@android:style/Theme.Translucent.NoTitleBar" />

	</application>

</manifest>
```