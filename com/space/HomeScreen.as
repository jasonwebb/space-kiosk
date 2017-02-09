package com.space {
	import flash.display.MovieClip;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import flash.events.MouseEvent;
	import com.space.LearnSection;
	import com.space.PicsVidsSection;
	import com.space.PlayGamesSection;
	
	public class HomeScreen extends MovieClip {
		private var Background;
		private var LearnButton, PlayButton, PicturesVideosButton;
		private var learnTween:Tween, playTween:Tween, picturesVideosTween:Tween;
		private var tweenHolder:Array = new Array();
		private var learnSection:LearnSection;
		private var picsVidsSection:PicsVidsSection;
		private var playGamesSection;
		
		public function HomeScreen() {}
		
		public function load() {
			trace("Loading home screen ...");
			
			// Instantiate section objects
			learnSection = new LearnSection();
			picsVidsSection = new PicsVidsSection();
			playGamesSection = new PlayGamesSection();

			// Instantiate graphic objects from Library
			Background = new homeBackground();
			LearnButton = new learnButton();
			PlayButton = new playGamesButton();
			PicturesVideosButton = new picturesVideosButton();
			
			// Set up target names
			LearnButton.name = "Learn";
			PlayButton.name = "Play";
			PicturesVideosButton.name = "PicsVids";
			
			// Set up locations for all objects
			LearnButton.x = stage.stageWidth/2;
			LearnButton.y = stage.stageHeight/2 - 200;
			PicturesVideosButton.x = stage.stageWidth/2 - 400;
			PicturesVideosButton.y = stage.stageHeight/2 + 200;
			PlayButton.x = stage.stageWidth/2 + 400;
			PlayButton.y = stage.stageHeight/2 + 200;
			
			// Initiate all the Tweens --------------------------------------------------------------
			// Learn about NASA button
			tweenHolder.push( new Tween(LearnButton,"scaleX",Elastic.easeOut,0,1,20) );
			tweenHolder.push( new Tween(LearnButton,"scaleY",Elastic.easeOut,0,1,20) );

			// "Play Games" button
			tweenHolder.push( new Tween(PlayButton,"scaleX",Elastic.easeOut,0,1,26) );
			tweenHolder.push( new Tween(PlayButton,"scaleY",Elastic.easeOut,0,1,26) );
			
			// "Pictures + Videos" button
			tweenHolder.push( new Tween(PicturesVideosButton,"scaleX",Elastic.easeOut,0,1,30) );
			tweenHolder.push( new Tween(PicturesVideosButton,"scaleY",Elastic.easeOut,0,1,30) );
			
			// Add mouse listeners to buttons
			LearnButton.addEventListener( MouseEvent.CLICK, buttonPressed );
			PicturesVideosButton.addEventListener( MouseEvent.CLICK, buttonPressed );
			PlayButton.addEventListener( MouseEvent.CLICK, buttonPressed );
			
			// Listen for Back Events from sections
			learnSection.addEventListener( BackEvent.GO_BACK, reload );
			picsVidsSection.addEventListener( BackEvent.GO_BACK, reload );
			playGamesSection.addEventListener( BackEvent.GO_BACK, reload );

			// Add all the objects to the stage (in correct order)
			addChild(Background);
			addChild(LearnButton);
			addChild(PlayButton);
			addChild(PicturesVideosButton);
			
			// Add other objects to stage, so they can populate later
			addChild(learnSection);
			addChild(picsVidsSection);
			addChild(playGamesSection);
		}

		public function unload() {
			trace("Unloading Home Screen ...");

			// Remove objects from stage
			removeChild(Background);
			removeChild(LearnButton);
			removeChild(PlayButton);
			removeChild(PicturesVideosButton);
		}
		
			private function reload(e) {
				load();
			}
		
			// Handle clicks on home buttons
			private function buttonPressed( e:MouseEvent ) {			
				switch( e.target.name ) {
					case "Learn":
						unload();
						learnSection.load();				
						break;
					case "PicsVids":
						unload();
						picsVidsSection.load();
						break;
					case "Play":
						unload();
						playGamesSection.load();
						break;
				}
			}
	}
	
}