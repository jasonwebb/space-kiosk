package com.space {
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;	
	import flash.display.Sprite;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.events.NetStatusEvent;
	import flash.media.Video;	
	import com.space.BackEvent;
	
	public class PicsVidsSection extends MovieClip {
		// Graphic elements
		private var Background;
		private var ActiveTitle;
		private var PlayButton;
		private var goBackButton;
		
		// XML helpers
		private var picturesList = new Array();
		private var thumbnailList = new Array();
		private var currentPicture = new Array();
		private var videosList = new Array();
		
		// General
		private var xmlLoader:URLLoader;		
		private var tweenHolder = new Array();
		
		// Video player functionality
		private var ncConnection;
		private var nsStream;
		private var vidDisplay:Video;
		private var sourceFile;
		private var playContainer;
		private var videoIsPlaying = false;
		private var videoWasPaused = false;
		
		//----------------------------------------
		// Empty constructor
		//----------------------------------------
		public function PicsVidsSection() {}
		
		//----------------------------------------------
		// Load all of the elements for this section
		//----------------------------------------------
		public function load() {
			trace("Loading Pictures + Videos section");
			
			// Load objects from library
			Background = new PicsVidsBackground();
			ActiveTitle = new VideoTitleActive();
			PlayButton = new VideoPlayButton();
			goBackButton = new BackButton();
			
			// Position the back button
			goBackButton.x = 1920 - 330;
			goBackButton.y = 70;
			
			// Listen for clicks on Back button
			goBackButton.addEventListener( MouseEvent.CLICK, goBack);
			
			// Position the objects
			ActiveTitle.x = 155;
			ActiveTitle.y = 682;
			
			// Load pictures from XML data
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener( Event.COMPLETE, loadPicturesXML );
			xmlLoader.load( new URLRequest("xml/pictures.xml") );
			
			// Load videos from XML data
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener( Event.COMPLETE, loadVideosXML );
			xmlLoader.load( new URLRequest("xml/videos.xml") );
			
			// Add objects to screen
			addChild(Background);
			addChild(ActiveTitle);
			addChild(PlayButton);
			addChild(goBackButton);
		}
		
		//--------------------------------------------------------
		// Unload all of the elements from this section
		//---------------------------------------------------------
		public function unload() {
			trace("Unloading Pictures + Videos section");
		}
		
			//------------------------------------------------------------
			// Load pictures from XML data
			//------------------------------------------------------------
			private function loadPicturesXML( e ) {
				trace("Loading pictures from XML");
				
				// Load the XML data from file
				var picturesXML:XML = new XML( e.target.data );
				var id = 0;
			
				// Add each thumbnail to the screen
				for each(var picture:XML in picturesXML.*) {
					// Push onto globally accessible array
					picturesList.push(picture);
					
					// Load the image from XML data
					var imgLoader:Loader = new Loader();
					var fileRequest = new URLRequest("images/pictures-and-videos/thumbnails/" + picture.filename);
					imgLoader.load( fileRequest );
					
					// Createa clickable container Sprite
					var container = new Sprite();
					
					// Position the images in rows and columns
					if(id<=2) {
						container.x = 878 + (id*307);
						container.y = 250;
					} else if(id>2 && id<6) {
						container.x = 878 + (id-3)*307;
						container.y = 495;
					} else {
						container.x = 878 + (id-6)*307;
						container.y = 742;
					}
					
					// Set up name of picture
					imgLoader.name = id;
					
					// Listen for clicks
					imgLoader.addEventListener( MouseEvent.CLICK, enlargePicture );
					
					// Add image to container
					container.addChild(imgLoader);
					
					// Add container to globally accessible array
					thumbnailList.push(container);
					
					// Add container to stage
					addChild(container);
					
					id++;
				}
			}
			
				//---------------------------------------------------------------------
				// Load full-resolution image when thumbnail is clicked
				//---------------------------------------------------------------------
				private function enlargePicture( e:MouseEvent ) {			
					// Retrieve cached XML data from array
					var id = e.target.name;
					var picture = picturesList[id];
					
					trace("- Opening image: " + picture.name);
					
					// Pause any video currently playing
					if( videoIsPlaying ) {
						nsStream.pause();
						videoWasPaused = true;
						addChild(playContainer);
					}						
					
					// Load the image from XML data
					var imgLoader:Loader = new Loader();
					var fileRequest = new URLRequest("images/pictures-and-videos/pictures/" + picture.filename);
					imgLoader.load( fileRequest );
					
					// Position the image
					imgLoader.x = stage.stageWidth/2 - picture.width/2;
					imgLoader.y = stage.stageHeight/2 - picture.height/2;
					
					// Create a container sprite
					var container = new Sprite();
					
					// Draw a transparent black background
					container.graphics.beginFill( 0x000000, .5 );
					container.graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);
					container.graphics.endFill();
					
					// Add the image to the container
					container.addChild(imgLoader);
					
					// Listen for mouse clicks anywhere
					container.addEventListener( MouseEvent.CLICK, closeImage );
					
					// Add container to stage
					addChild(container);
					
					currentPicture.push(container);
				}
				
					//-------------------------------------------------------
					// Unload the full resolution image
					//-------------------------------------------------------
					private function closeImage( e:MouseEvent ) {
						trace("-- Closing image");
						
						// Remove image from stage
						removeChild(currentPicture[0]);
						
						// Clean up the array
						currentPicture.splice(0,1);
					}
					
			//---------------------------------------------------------
			// Load video playlist from XML data
			//---------------------------------------------------------
			private function loadVideosXML( e ) {
				trace("Loading videos from XML");
				
				// Load the XML data from file
				var videosXML:XML = new XML( e.target.data );
				var id = 0;
			
				// Add each videeo title to the screen
				for each(var video:XML in videosXML.*) {
					// Push onto globally accessible array
					videosList.push(video);

					// Create a transparent container object
					var container = new Sprite();
					container.graphics.beginFill(0xFFFFFF, 0);
					container.graphics.drawRect(155,656,475,55);
					container.graphics.endFill();
					container.x = 155;
					container.y = 656  + id*65;

					// Create a TextForamt object for Verdana font
					var tf2 = new TextFormat();
					tf2.size = 24;
					var ver = new Verdana();
					tf2.font = ver.fontName;					
					
					// Set up the video's title
					var videoTitle = new TextField();
					videoTitle.x = 15;
					videoTitle.y = 34;
					videoTitle.alpha = .6;
					videoTitle.width = 450;
					videoTitle.height = 50;
					videoTitle.textColor = 0xFFFFFF;
					videoTitle.selectable = false;
					videoTitle.defaultTextFormat = tf2;
					videoTitle.text = video.name;
					videoTitle.name = id;
					
					// Add video title to container
					container.addChild(videoTitle);
					
					// Listen for mouse clicks on the container
					container.addEventListener( MouseEvent.CLICK, playVideo );
					
					// Add container to stage
					addChild(container);
					
					// Incrememtn ID
					id++;
				}
				
				// Grab a reference tot he first video in the array
				sourceFile = "images/pictures-and-videos/videos/" + videosList[0].filename;
				
				// Attach the first first to the screen
				var vidplayer = new Sprite();
				
				// Prepare a NetConnection to use with NetStream
				ncConnection = new NetConnection();
				ncConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				ncConnection.connect(null);
			
				// Create a NetStream object to stream the video
				nsStream = new NetStream(ncConnection);
				nsStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				nsStream.client = new Object();
				nsStream.bufferTime = 8;
			
				// Load the video into a Video object
				vidDisplay = new Video();
				vidDisplay.x = 141;
				vidDisplay.y = 246;
				vidDisplay.width = 515;
				vidDisplay.height = 386;
				vidDisplay.attachNetStream(nsStream);
				vidDisplay.smoothing = true;
				
				// Play the video
				//nsStream.play( sourceFile );
				
				// Add video to stage
				addChild(vidDisplay);
		
				// Create a container sprite to contain Play Button
				playContainer = new Sprite();
				playContainer.x = 141;
				playContainer.y = 246;
				
				// Draw a transparent black rectange to black out video
				playContainer.graphics.beginFill(0x000000,.7);
				playContainer.graphics.drawRect(0,0,515,386);
				playContainer.graphics.endFill();
				
				// Position the Play button
				PlayButton.x = 269;
				PlayButton.y = 179;
				
				// Listen for mouse clicks on play button
				playContainer.addEventListener( MouseEvent.CLICK, startVideo );
				
				// Add Play Button to container
				playContainer.addChild(PlayButton);
				
				// Add container to stage
				addChild(playContainer);
			}
			
				//------------------------------------------------------
				// Play a video when the "Play" button is clicked
				//------------------------------------------------------
				private function startVideo( e:MouseEvent ) {
					trace("-- Starting video");
					
					// Remove the Play button overlay
					removeChild(playContainer);
					
					// Play the currently selected video
					nsStream.play( sourceFile );
					
					// Indicate that the video is currently playing
					videoIsPlaying = true;
				}
				
				//-------------------------------------------------------------
				// Play a video when it's title is clicked in the playlist
				//-------------------------------------------------------------
				private function playVideo( e:MouseEvent ) {
					// Obtain video from ID
					var id = e.target.name;
					var video = videosList[id];
					
					trace("- Playing video: " + video.name);
					
					// Update the actual video
					sourceFile = "images/pictures-and-videos/videos/" + video.filename;
					
					if(videoIsPlaying)
						nsStream.play( sourceFile );
					
				
					// Update the title bar
					tweenHolder.push( new Tween(ActiveTitle, "y", Strong.easeOut, ActiveTitle.y, 682 + id*63, 10) );
				}
			
				//--------------------------------------------------------------
				// Status handler for net connection object
				//--------------------------------------------------------------
				function netStatusHandler(event:NetStatusEvent):void {
					// handles net status events
					switch (event.info.code) {
						case "NetStream.Play.StreamNotFound":
							trace("- Stream not found: " + sourceFile);
							break;
				
						case "NetStream.Play.Stop":
							nsStream.pause();
							nsStream.seek(0);
							break;
					}
				}
				
			//------------------------------------------------
			// Transition back to the home screen
			//------------------------------------------------
			private function goBack( e ) {
				unload();

				// Fire a custom event to go back
				dispatchEvent( new BackEvent("HOME") );	
			}				
	}	
}