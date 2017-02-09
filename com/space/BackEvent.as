package com.space {
	import flash.events.Event;
	
	/****************************************************
	 Custom event to facilitate back-tracking in the
	 main app. Parent sections can listen for this
	 event, which can be dispatched from child sections
	 when the user is trying to go back.
	*****************************************************/
	public class BackEvent extends Event {
		public static const GO_BACK = 0;
		public var destination;
		
		public function BackEvent( destination:String ) {
			super( GO_BACK );
			this.destination = destination;
		}
		
	}
	
}