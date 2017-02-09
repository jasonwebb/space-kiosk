package com.space {
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	import com.space.games.MarsGame;
	import com.space.games.SpaceShapesGame;
	import com.space.BackEvent;
	
	public class PlayGamesSection extends MovieClip {
		// Graphical objects
		private var Background;
		private var marsRoversButton;
		private var spaceShapesButton;
		private var goBackButton;
		
		// Game objects
		private var marsGame;
		private var spaceShapesGame;
		
		//--------------------------------------------
		// Constructor
		//--------------------------------------------
		public function PlayGamesSection() {}
		
		//------------------------------------------------
		// Load all of the elements for this section
		//------------------------------------------------
		public function load() {
			trace("Loading Play Games section ...");
			
			// Load objects from library
			Background = new PlayBackground();
			marsRoversButton = new MarsRoversButton();
			spaceShapesButton = new SpaceShapesButton();
			goBackButton = new BackButton();
			
			// Position the back button
			goBackButton.x = 80;
			goBackButton.y = 100;
			
			// Listen for mouse clicks on back button
			goBackButton.addEventListener( MouseEvent.CLICK, goBack );
			
			// Position objects
			marsRoversButton.x = 240;
			marsRoversButton.y = 570;
			spaceShapesButton.x = 1000;
			spaceShapesButton.y = 570;
			
			// Name the objects
			marsRoversButton.name = "Hunt";
			spaceShapesButton.name = "Shapes";
			
			// Listen for mouse clicks on the buttons
			marsRoversButton.addEventListener( MouseEvent.CLICK, buttonClicked );
			spaceShapesButton.addEventListener( MouseEvent.CLICK, buttonClicked );
					
			// Instantiate game objects
			marsGame = new MarsGame();
			spaceShapesGame = new SpaceShapesGame();
			
			// Listen for BackEvents from the games
			marsGame.addEventListener( BackEvent.GO_BACK, goBack );
			spaceShapesGame.addEventListener( BackEvent.GO_BACK, goBack );
			
			// Add objects to scene
			addChild(Background);
			addChild(marsRoversButton);
			addChild(spaceShapesButton);
			addChild(marsGame);
			addChild(spaceShapesGame);
			addChild(goBackButton);
		}
		
			//-------------------------------------------
			// Handle mouse clicks on buttons
			//--------------------------------------------
			private function buttonClicked( e:MouseEvent ) {				
				switch( e.target.name ) {
					case "Hunt":
						unload();
						marsGame.load();
						break;
					case "Shapes":
						unload();
						spaceShapesGame.load();
						break;
				}
			}
		
		//------------------------------------------------
		// Unload all of the elements for this section
		//-------------------------------------------------
		public function unload() {
			trace("Unloading Play Games section ...");
			
			removeChild(Background);
			removeChild(marsRoversButton);
			removeChild(spaceShapesButton);
			removeChild(goBackButton);
		}
		
			//------------------------------------------------
			// Transition back to the home screen
			//------------------------------------------------
			private function goBack( e ) {
				if( e.hasOwnProperty("destination") ) {
					if(e.destination!="GAME")
						unload();
				}

				// Fire a custom event to go back
				dispatchEvent( new BackEvent("HOME") );	
			}		
		
	}
}