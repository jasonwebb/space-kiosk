package com.space.games {
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;	
	import com.space.BackEvent;
	
	public class MarsGame extends MovieClip {
		// Graphic objects
		private var landscape;
		private var rock1, rock2, rock3;
		private var tribble1, tribble2, tribble3;
		private var rover;
		private var goBackButton;
		
		// Gameplay variables
		private var ROCK_1_ON = false;
		private var ROCK_2_ON = false;
		private var ROCK_3_ON = false;
		private var TRIBBLE_1_FOUND = false;
		private var TRIBBLE_2_FOUND = false;
		private var TRIBBLE_3_FOUND = false;
	
		// General
		private var tweenHolder = new Array();
		private var newX;
		private var section;
		private var r1X = 200, r1Y = 750;
		private var r2X = 1500, r2Y = 750;
		private var r3X = 850, r3Y = 800;
		
		//------------------------------
		// Constructor
		//------------------------------
		public function MarsGame() {}
		
		//-------------------------------------------------
		// Load all of the elements for the game
		//-------------------------------------------------
		public function load() {
			trace("Loading Mars Rover Scavenger Hunt game ...");
			
			// Load all of the objects from the library
			landscape = new MarsLandscape();
			rock1 = new Rock();
			rock2 = new Rock();
			rock3 = new Rock();
			tribble1 = new Tribble();
			tribble2 = new Tribble();
			tribble3 = new Tribble();
			rover = new MarsRover();
			goBackButton = new BackButton();
			section = new Sprite();
			
			// Position the back button
			goBackButton.x = 80;
			goBackButton.y = 100;
			
			// Listen for mouse clicks on back button
			goBackButton.addEventListener( MouseEvent.CLICK, goBack );
			
			// Size and place the rover
			rover = new MarsRover();
			rover.x = 500;
			rover.y = 520;
			
			// Start making the rover move around
			newX = Math.floor(Math.random() * (1+stage.stageWidth-0)) + 0;
			
			if(newX < rover.x)
				rover.scaleX = -1;
			else
				rover.scaleX = 1;
			
			var tw = new Tween(rover, "x", Strong.easeOut, rover.x, newX, 200);
			tweenHolder.push( tw );
			tw.addEventListener( TweenEvent.MOTION_FINISH, moveRover );
				
			// Size and place the rocks
			rock1.x = r1X;
			rock1.y = r1Y;
			rock1.width = 200;
			rock1.height = 155;
			rock1.rotation = 10;
			rock1.name = "1";

			rock2.x = r2X;
			rock2.y = r2Y;
			rock2.width = 300;
			rock2.height = 233;
			rock2.rotation = -5;
			rock2.name = "2";
			
			rock3.x = r3X;
			rock3.y = r3Y;
			rock3.width = 270;
			rock3.height = 209;
			rock3.rotation = -160;
			rock3.name = "3";
			
			// Position the tribbles
			tribble1.x = rock1.x;
			tribble1.y = rock1.y;
			tribble1.scaleX = .2;
			tribble1.scaleY = tribble1.scaleX;
			
			tribble2.x = rock2.x;
			tribble2.y = rock2.y;
			tribble2.scaleX = .3;
			tribble2.scaleY = tribble2.scaleX;
			
			tribble3.x = rock3.x;
			tribble3.y = rock3.y;
			tribble3.scaleX = .3;
			tribble3.scaleY = tribble3.scaleX;
			
			// Add interactivity to the rocks
			rock1.addEventListener( MouseEvent.MOUSE_DOWN, mouseOn );
			rock2.addEventListener( MouseEvent.MOUSE_DOWN, mouseOn );
			rock3.addEventListener( MouseEvent.MOUSE_DOWN, mouseOn );
			
			// If rock is being clicked, move it with mouse
			stage.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoved );
			stage.addEventListener( MouseEvent.MOUSE_UP, mouseOff );

			// Add objects to the stage
			section.addChild(landscape);
			section.addChild(rover);
			section.addChild(tribble1);
			section.addChild(tribble2);
			section.addChild(tribble3);
			section.addChild(rock1);
			section.addChild(rock2);
			section.addChild(rock3);
			section.addChild(goBackButton);
			
			addChild(section);
		}
		
			public function unload() {
				trace("Unloading Mars Rover game ...");
				
				removeChild(section);
			}
		
			//-------------------------------------------------------------
			// Move the rover to a new location
			//-------------------------------------------------------------
			private function moveRover( e ) {
				// Generate a new location to move to
				newX = Math.floor(Math.random() * (1+stage.stageWidth-0)) + 0;
				
				// Flip the robot to face the right direction
				if(newX < rover.x)
					tweenHolder.push( new Tween(rover, "scaleX", None.easeIn, rover.scaleX, -1, 8) );
				else
					tweenHolder.push( new Tween(rover, "scaleX", None.easeIn, rover.scaleX, 1, 8) );
				
				// Move the rover to the next location, and wait for animation to finish
				var tw = new Tween(rover, "x", Strong.easeOut, rover.x, newX, 200);
				tweenHolder.push( tw );
				tw.addEventListener( TweenEvent.MOTION_FINISH, moveRover );
			}
			
			//-----------------------------------------------------
			// Attach rock to mouse when clicked
			//------------------------------------------------------
			private function mouseOn( e:MouseEvent ) {
				switch( e.target.name ) {
					case "1":
						// attach rock1 to mouse
						ROCK_1_ON = true;
						break;
					case "2":
						// attach rock2 to mouse
						ROCK_2_ON = true;
						break;
					case "3":
						// attach rock3 to mouse
						ROCK_3_ON = true;
						break;
				}
			}
			
			//-----------------------------------------------------
			// Detach all rocks from mouse
			//-----------------------------------------------------
			private function mouseOff( e:MouseEvent ) {
				ROCK_1_ON = false;
				ROCK_2_ON = false;
				ROCK_3_ON = false;
				
				// Check for displacement of rock1
				if( Math.abs(rock1.x - r1X) >= 50  || Math.abs(rock1.y - r1Y) >= 50 ) {
					tweenHolder.push( new Tween(tribble1, "x", None.easeIn, tribble1.x, 700, 10) );
					tweenHolder.push( new Tween(tribble1, "y", None.easeIn, tribble1.y, 300, 10) );
					TRIBBLE_1_FOUND = true;
				}
				
				// Check for displacement of rock2
				if( Math.abs(rock2.x - r2X) >= 70 || Math.abs(rock2.y - r2Y) >= 70 ) {
					tweenHolder.push( new Tween(tribble2, "x", None.easeIn, tribble2.x, 1050, 10) );
					tweenHolder.push( new Tween(tribble2, "y", None.easeIn, tribble2.y, 300, 10) );
					TRIBBLE_2_FOUND = true;
				}
				
				// Check for displacement of rock3
				if( Math.abs(rock3.x - r3X) >= 70 || Math.abs(rock3.y - r3Y) >= 70 ) {
					tweenHolder.push( new Tween(tribble3, "x", None.easeIn, tribble3.x, 870, 10) );
					tweenHolder.push( new Tween(tribble3, "y", None.easeIn, tribble3.y, 300, 10) );
					TRIBBLE_3_FOUND = true;
				}
				
				// Check if all tribbles have been found
				if( TRIBBLE_1_FOUND && TRIBBLE_2_FOUND && TRIBBLE_3_FOUND ) {
					// Create a TextFormat object with larger scope
					var hv = new Helvetica();
					var tf = new TextFormat();
					tf.size = 80;
					tf.font = hv.fontName;
					
					// Tell the user they won
					var winText = new TextField();
					winText.x = 1300;
					winText.y = 250;
					winText.alpha = .8;
					winText.width = 450;
					winText.height = 200;
					winText.textColor = 0xFFFFFF;
					winText.selectable = false;
					winText.defaultTextFormat = tf;
					winText.text = "YOU WIN!";						
										
					// Add textfield to stage
					addChild(winText);					
				}
			}
			
			//----------------------------------------------
			// Move the correct rock with the mouse
			//----------------------------------------------
			private function mouseMoved( e ) {
				// Move any rocks
				if(ROCK_1_ON) {
					rock1.x = mouseX;
					rock1.y = mouseY;
				} else if(ROCK_2_ON) {
					rock2.x = mouseX;
					rock2.y = mouseY;
				} else if(ROCK_3_ON) {
					rock3.x = mouseX;
					rock3.y = mouseY;
				}
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