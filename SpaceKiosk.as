package  {
	import flash.display.MovieClip;
	import com.space.HomeScreen;
	
	public class SpaceKiosk extends MovieClip {
		private var homeScreen:HomeScreen;
		
		public function SpaceKiosk() {
			// Instantiate section objects
			homeScreen = new HomeScreen();
			
			// Add section objects to stage
			addChild(homeScreen);
			
			// Load the Home screen to start the app
			homeScreen.load();			
		}
	}	
}