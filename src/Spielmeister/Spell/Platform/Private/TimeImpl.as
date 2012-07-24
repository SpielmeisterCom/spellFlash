package Spielmeister.Spell.Platform.Private {

	public class TimeImpl {

		public function TimeImpl() {
		}

		public function getCurrentInMs() : Number {
			var date : Date = new Date()

			return date.getTime()
		}
	}
}
