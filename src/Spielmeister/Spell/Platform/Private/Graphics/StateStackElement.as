package Spielmeister.Spell.Platform.Private.Graphics {
	import net.richardlord.coral.Matrix3d

	public class StateStackElement {
		public var opacity : Number
		public var color : uint
		public var matrix : Matrix3d = new Matrix3d()
		public var viewMatrix : Matrix3d = new Matrix3d()

		public function StateStackElement( opacity : Number, color : uint, matrix : Matrix3d, viewMatrix : Matrix3d  ) {
			this.opacity     = opacity
			this.color       = color
			this.matrix      = matrix
			this.viewMatrix  = viewMatrix
		}
	}
}
