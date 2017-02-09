package com.space {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.space.BackEvent;

	public class LearnSection extends MovieClip {
		// Graphical objects
		private var Background;
		private var CornerSwoosh;
		private var goBackButton;
		private var section;

		// Facilities objects
		private var facilitiesList:Array = new Array(); 
		private var activeBoxes = new Array();		
		
		// Scroller objects
		private var scrollerPrevious, scrollerNext, scrollerBackgroundBox;
		private var scrollerList = new Array();
		private var scrollerIndex = 0;
		private var activeScrollerItem = new Array();
		
		// General
		private var xmlLoader:URLLoader;		
		private var tweenHolder = new Array();
		
		//-------------------------------------------
		// Constructor
		//-------------------------------------------
		public function LearnSection() {}

	
		//-------------------------------------------------------
		// Loads all of the objects and data
		//--------------------------------------------------------
		public function load() {
			trace("Loading Learn About NASA section ...");

			// Instantiate graphic objects from library
			Background = new learnBackground();
			CornerSwoosh = new cornerSwoosh();
			goBackButton = new BackButton();
			section = new Sprite();
			
			// Position the back button
			goBackButton.x = 100;
			goBackButton.y = 880;
			goBackButton.addEventListener(MouseEvent.CLICK, goBack);

			// Load NASA facilities XML data
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener( Event.COMPLETE, loadFacilitiesXML );
			xmlLoader.load( new URLRequest("xml/nasa-facilities.xml") );
			
			// Scroller data from XML file
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener( Event.COMPLETE, loadScrollerXML );
			xmlLoader.load( new URLRequest("xml/scroller-items.xml") );			
		
			// Set up WHAT IS NASA corner ======================================================================
			// What is NASA header
			var whatHeader = new TextField();
			whatHeader.x = 285;
			whatHeader.y = 100;
			whatHeader.alpha = .8;
			whatHeader.width = 450;
			whatHeader.height = 50;
			whatHeader.textColor = 0xFFFFFF;
			whatHeader.selectable = false;
			
			var hv = new Helvetica();
			
			var tf = new TextFormat();
			tf.size = 36;
			tf.font = hv.fontName;
			
			whatHeader.defaultTextFormat = tf;
			whatHeader.text = "What is NASA?";
			
			// Divider line
			var line = new Sprite();
			line.graphics.lineStyle(1, 0xFFFFFF, .5);
			line.graphics.moveTo(whatHeader.x - 10, whatHeader.y + 50);
			line.graphics.lineTo(whatHeader.x + 510, whatHeader.y + 50);
			
			// What is NASA text
			var whatText = new TextField();
			whatText.x = 285;
			whatText.y = 160;
			whatText.textColor = 0xFFFFFF;
			whatText.alpha = .5;
			whatText.width = 500;
			whatText.height = 300;
			whatText.wordWrap = true;
			whatText.embedFonts = true;
			whatText.selectable = false;

			var tf2 = new TextFormat();
			tf2.size = 14;
			var ver = new Verdana();
			tf2.font = ver.fontName;
			
			whatText.defaultTextFormat = tf2;
			whatText.text = "NASA stands for National Aeronautics and Space Administration. NASA was started in 1958 as a part of the United States government. NASA is in charge of U.S. science and technology that has to do with airplanes or space. From its start, NASA began to plan for human spaceflight. The Mercury, Gemini and Apollo programs helped NASA learn about flying in space. This led to the first human landing on the moon in 1969. Right now, NASA is working to finish the International Space Station. Space probes have visited every planet in the solar system. Scientists have looked far into space using telescopes. NASA satellites help people better understand weather patterns on Earth. NASA also helps develop and test new aircraft. Some of the airplanes have set new records. NASA works to make air travel faster and safer. ";


			// Set up scroller corner =======================================================
			scrollerPrevious = new scrollerPreviousButton();
			scrollerPrevious.x = 1018;
			scrollerPrevious.y = 186;
			scrollerPrevious.name = "prev";
			scrollerPrevious.addEventListener( MouseEvent.CLICK, scrollerAction);
			
			scrollerBackgroundBox = new scrollerBackground();
			scrollerBackgroundBox.x = 1100;
			scrollerBackgroundBox.y = 87;
			
			scrollerNext = new scrollerNextButton();
			scrollerNext.x = 1770;
			scrollerNext.y = 186;
			scrollerNext.name = "next";
			scrollerNext.addEventListener( MouseEvent.CLICK, scrollerAction);
			
			// Add objects to stage
			section.addChild(Background);
			section.addChild(CornerSwoosh);
			section.addChild(whatHeader);
			section.addChild(line);
			section.addChild(whatText);
			section.addChild(scrollerPrevious);
			section.addChild(scrollerBackgroundBox);
			section.addChild(scrollerNext);
			section.addChild(goBackButton);
			
			addChild(section);
		}


		//------------------------------------------------------
		// Unloads everything from this section from the stage
		//-------------------------------------------------------
		public function unload() {
			trace("Unloading Learn About NASA section ...");

			// Remove objects from stage
			removeChild(section);
		}


			//------------------------------------------------------------
			// Parses an external XML file containing info about all 
			// facilities into an array, and populates screen with
			// markers
			//-------------------------------------------------------------
			private function loadFacilitiesXML( e:Event ) {
				
				// Load the XML data from file
				var facilitiesXML:XML = new XML( e.target.data );
				var id = 0;
			
				// Add each thumbnail to the screen
				for each(var facility:XML in facilitiesXML.*) {
					// Push each sound node onto external stack for easy looking-up later
					facilitiesList.push(facility);

					// Put a marker on the map for this facility
					var marker = new mapMarker();
					marker.name = id;
					
					// Interpret the coordinates from the field
					var coordinates = facility.coordinates.split(",");
					marker.x = coordinates[0];
					marker.y = coordinates[1];
					
					// Listen for mouse clicks
					marker.addEventListener( MouseEvent.CLICK, markerClicked );

					// Add marker to stage
					section.addChild(marker);

					id++;
				}
			}
			
			
			//--------------------------------------------------------------------
			// Parses XML data for the scroller
			//--------------------------------------------------------------------
			private function loadScrollerXML( e:Event ) {
				
				// Load the XML data from file
				var scrollerXML:XML = new XML( e.target.data );
			
				// Add each thumbnail to the screen
				for each(var item:XML in scrollerXML.*) {
					// Push each sound node onto external stack for easy looking-up later
					scrollerList.push(item);			
				}
				
				loadScrollerItem( scrollerIndex, "left" );
			}
			
				//------------------------------------------------------------
				// Handles the "next" or "previous" buttons for the scroller
				//------------------------------------------------------------
				private function scrollerAction( e:MouseEvent ) {
					switch( e.target.name ) {
						case "prev":
							trace("- Loading previous scroller item");
							if(scrollerIndex == 0)
								scrollerIndex = scrollerList.length-1;
							else
								scrollerIndex--;
							
							loadScrollerItem( scrollerIndex, "left" );
							
							break;
						case "next":
							trace("- Loading next scroller item");
							if(scrollerIndex == scrollerList.length-1)
								scrollerIndex = 0;
							else
								scrollerIndex++;
								
							loadScrollerItem( scrollerIndex, "right" );
								
							break;
					}
				}
				
		
				//----------------------------------------------------------
				// Load a scroller item at a specific index
				//----------------------------------------------------------
				private function loadScrollerItem( index, direction ) {
					// Remove any scroller item that are already up
					if(activeScrollerItem.length > 0) {
						removeChild(activeScrollerItem[0]);
						activeScrollerItem.splice(0,1);	
					}
					
					// Obtain scroller item
					var item = scrollerList[index];
					
					// Load the image
					var imgLoader:Loader = new Loader();
					var fileRequest = new URLRequest("images/learn-about-nasa/scroller-items/" + item.picture);
					imgLoader.load( fileRequest );
	
					// Create a container sprite
					var container:Sprite = new Sprite();
					container.x = scrollerBackgroundBox.x + 30;
					container.y = scrollerBackgroundBox.y + 24;
					container.addChild(imgLoader);

					// Set up header typography
					var headerStyle = new TextFormat();
					headerStyle.size = 30;
					var ver = new Helvetica_Narrow();
					headerStyle.font = ver.fontName;
					
					// Body copy style
					var locStyle = new TextFormat();
					locStyle.size = 14;
					var v = new Verdana();
					locStyle.font = v.fontName;

					// Create header field
					var nameField = new TextField();
					nameField.x = 165;
					nameField.y = -10;
					nameField.textColor = 0xFFFFFF;
					nameField.alpha = .6;
					nameField.width = 320;
					nameField.height = 62;
					nameField.embedFonts = true;
					nameField.defaultTextFormat = headerStyle;
					nameField.selectable = false;
					nameField.text = item.name;
					
					// Divider line
					var line = new Sprite();
					line.graphics.lineStyle(1, 0xFFFFFF, .3);
					line.graphics.moveTo(nameField.x, nameField.y + 42);
					line.graphics.lineTo(nameField.x + 330, nameField.y + 42);
					
					// Create body copy field
					var desField = new TextField();
					desField.x = nameField.x;
					desField.y = nameField.y + 50;
					desField.textColor = 0xFFFFFF;
					desField.alpha = .4;
					desField.width = 330;
					desField.height = 200;
					desField.wordWrap = true;
					desField.defaultTextFormat = locStyle;
					desField.selectable = false;
					desField.text = item.description;
					
					// Populate the container
					container.addChild(nameField);
					container.addChild(line);
					container.addChild(desField);
					
					if(direction=="left")
						tweenHolder.push( new Tween(container, "x", Strong.easeOut, container.x + 80, container.x, 10) );
					else
						tweenHolder.push( new Tween(container, "x", Strong.easeOut, container.x - 80, container.x, 10) );					
					
					// Add container to stage and globally accessible array
					addChild(container);					
					activeScrollerItem.push(container);
					
				}
						
				
				//------------------------------------------------------------
				// Mouse listener for when a map marker is clicked
				//------------------------------------------------------------
				private function markerClicked( e:MouseEvent ) {
					// Use the unique ID to select the correct facility
					var id = e.target.name;
					var facility = facilitiesList[id];
					var coord = facility.coordinates.split(",");
					
					// Remove any boxes that are already up
					if(activeBoxes.length > 0) {
						removeChild(activeBoxes[0]);
						activeBoxes.splice(0,1);	
					}
					
					// Create a container sprite
					var container = new Sprite();
					container.x = coord[0];
					container.y = coord[1] - 55;

					// Create the pop up box
					var box = new descriptionBox();
					box.x = -box.width/2 + 24;
					box.y = -box.height + 15;

					// Set up typography
					var headerStyle = new TextFormat();
					headerStyle.size = 30;
					var ver = new Helvetica_Narrow();
					headerStyle.font = ver.fontName;
					
					var locStyle = new TextFormat();
					locStyle.size = 14;
					var v = new Verdana();
					locStyle.font = v.fontName;
					
					// Name of facility
					var nameField = new TextField();
					nameField.x = -box.width/2 + 60;
					nameField.y = -box.height + 45;
					nameField.textColor = 0x000000;
					nameField.alpha = .8;
					nameField.width = 320;
					nameField.height = 62;
					nameField.wordWrap = true;
					nameField.defaultTextFormat = headerStyle;
					nameField.embedFonts = true;
					nameField.selectable = false;
					nameField.text = facility.name;
					
					// Location of facility
					var locField = new TextField();
					locField.x = nameField.x;
					locField.y = nameField.y + 40;
					locField.alpha = .5;
					locField.width = 276;
					locField.height = 30;
					locField.defaultTextFormat = locStyle;
					locField.selectable = false;
					locField.text = facility.location;
					
					// Description of facility
					var desField = new TextField();
					desField.x = locField.x;
					desField.y = locField.y + 30;
					desField.alpha = .6;
					desField.width = 320;
					desField.height = 200;
					desField.wordWrap = true;
					desField.defaultTextFormat = locStyle;
					desField.selectable = false;
					desField.text = facility.description;
		
					// Populate the container sprite
					container.addChild(box);
					container.addChild(nameField);
					container.addChild(locField);
					container.addChild(desField);
					
					// Add container to stage
					addChild(container);
					
					// Animate the container
					tweenHolder.push( new Tween(container, "alpha", None.easeIn, 0, 1, 10) );
					tweenHolder.push( new Tween(container, "y", Strong.easeOut, container.y+40, container.y, 12) );
					
					// Add container to globally accessible array
					activeBoxes.push(container);

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