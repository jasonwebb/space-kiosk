package com.space.games {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.events.Event;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import com.space.BackEvent;
	
	public class SpaceShapesGame extends MovieClip {
		// Graphic objects
		private var playBackground;
		private var goBackButton;
		
		// General
		private var xmlLoader:URLLoader;		
		private var tweenHolder = new Array();
		private var shapesList = new Array();
		private var currentShapeName;
		private var currentShape = new Array();
		private var containerList = new Array();		
		
		//------------------------------
		// Constructor
		//------------------------------
		public function SpaceShapesGame() {}
		
		//-------------------------------------------------
		// Load all of the elements for the game
		//-------------------------------------------------
		public function load() {
			trace("Loading Space Shapes game ...");
			
			// Load graphics
			playBackground = new SpaceShapesBackground();
			goBackButton = new BackButton();
			
			// Position the back button
			goBackButton.x = 140;
			goBackButton.y = 765;
			
			// Listen for mouse clicks on the back button
			goBackButton.addEventListener( MouseEvent.CLICK, goBack );
			
			// Load data from external XML
			xmlLoader = new URLLoader();
			xmlLoader.addEventListener( Event.COMPLETE, loadShapesXML );
			xmlLoader.load( new URLRequest("xml/space-shapes.xml") );			
			
			// Add objects to the stage
			addChild(playBackground);
			addChild(goBackButton);
		}
		
		//------------------------------------------------------
		// Unload all of the elements
		//------------------------------------------------------
		public function unload() {
			trace("Unloading Space Shapes game ...");
			
			// Remov background
			removeChild(playBackground);
			
			// Remove whiteout elements
			for(var i=0; i<containerList.length; i++)
				removeChild(containerList[i]);
			
			// Removing previous round shape
			if( currentShape.length > 0 ) {
				removeChild(currentShape[0]);
				currentShape.splice(0,1);
			}			
		}
			
		
			//-------------------------------------------------
			// Parse the external XML file
			//--------------------------------------------------
			private function loadShapesXML( e:Event ) {
				trace("- Loading space shapes XML");
				
				// Load the XML data from file
				var shapesXML:XML = new XML( e.target.data );
				var id = 0;
			
				// Add each thumbnail to the screen
				for each(var shape:XML in shapesXML.*) {
					// Add shape to globally accessible array
					shapesList.push( shape );
				}
				
				// Start the game by moving to the next round
				nextRound();
			}
			
			//--------------------------------------------------------
			// Displays one round of the game
			//---------------------------------------------------------
			private function nextRound() {
				trace("- Loading a round ...");
				
				// Removing previous round shape
				if( currentShape.length > 0 ) {
					removeChild(currentShape[0]);
					currentShape.splice(0,1);
				}
						
				// Load and display all the cut-outs
				for(var i=0; i<shapesList.length; i++) {
					// Load the image
					var imgLoader:Loader = new Loader();
					var fileRequest = new URLRequest("images/play-games/space-shapes/whiteout/" + shapesList[i].filename);
					imgLoader.load( fileRequest );
					
					// Create a container sprite
					var container = new Sprite();
					
					// Position container on the stage
					if(i<3) {
						container.x = 650 + i*340;
						container.y = 480;
					} else {
						container.x = 650 + (i-3)*340;
						container.y = 710;
					}
					
					// Name the container
					imgLoader.name = shapesList[i].filename;
					
					// Listen for mouse clicks
					imgLoader.addEventListener(MouseEvent.CLICK, shapeClicked);
					
					// Add image to container sprite
					container.addChild(imgLoader);
					
					// Collect container
					containerList.push(container);
					
					// Add container to stage
					addChild(container);
				}
				
				// Choose a random shape to display
				var n = Math.floor(Math.random() * (1+(shapesList.length-1)-0)) + 0;
				var imgLoader2:Loader = new Loader();
				var fileRequest2 = new URLRequest("images/play-games/space-shapes/color/" + shapesList[n].filename);
				imgLoader2.load( fileRequest2 );	
				currentShapeName = shapesList[n].filename;
				
				// Position the shape on the stage
				imgLoader2.x = 730;
				imgLoader2.y = 140;
				
				// Add shape to globally accessible array
				currentShape.push(imgLoader2);
				
				// Add shape to stage
				addChild(imgLoader2);
				
			}
			
				//------------------------------------------------
				// Determine if shape clicked is correct
				//------------------------------------------------
				private function shapeClicked( e ) {
					// Create a TextFormat object with larger scope
					var hv = new Helvetica();
					var tf = new TextFormat();
					tf.size = 80;
					tf.font = hv.fontName;
					
					// Correct answer
					if( currentShapeName == e.target.name ) {
						trace("-- Correct shape");
						
						// Correct answer textfield
						var correctText = new TextField();
						correctText.x = 1100;
						correctText.y = 220;
						correctText.alpha = .8;
						correctText.width = 450;
						correctText.height = 200;
						correctText.textColor = 0xFFFFFF;
						correctText.selectable = false;
						correctText.defaultTextFormat = tf;
						correctText.text = "CORRECT!";						
						
						// Animate textfield
						tweenHolder.push( new Tween(correctText, "alpha", Strong.easeIn, 1, 0, 30) );
						
						// Add textfield to stage
						addChild(correctText);

					// Incorrect answer
					} else {
						trace("-- Incorrect shape");
						
						// Incorrect answer textfield
						var incorrectText = new TextField();
						incorrectText.x = 1100;
						incorrectText.y = 220;
						incorrectText.alpha = 1;
						incorrectText.width = 450;
						incorrectText.height = 200;
						incorrectText.textColor = 0xFF0000;
						incorrectText.selectable = false;
						incorrectText.defaultTextFormat = tf;
						incorrectText.text = "TRY AGAIN!";						
						
						// Animate textfield
						tweenHolder.push( new Tween(incorrectText, "alpha", Strong.easeIn, 1, 0, 30) );
						
						// Add textfield to stage
						addChild(incorrectText);						
					}
					
					// Move on to the next round
					nextRound();
				}
				
			//------------------------------------------------
			// Transition back to the home screen
			//------------------------------------------------
			private function goBack( e ) {
				unload();

				// Fire a custom event to go back
				dispatchEvent( new BackEvent("GAME") );	
			}		
			
	}	
}