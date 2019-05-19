open __partial class MainWindowController {

	private func setup() {
		//
		//  Do any shared initilaization, here
		//
	}

	//
	// Add Shared code here
	//

	@Notify public var valueA: String!
	@Notify public var valueB: String!
	@Notify public private(set) var result: String!

	@IBAction
	public func calculateResult(_ sender: id!) {
		if (length(valueA) == 0) | (length(valueB) == 0) {
			result = "(value required)"
		} else {
			if let a = Convert.TryToDoubleInvariant(valueA), let b = Convert.TryToDoubleInvariant(valueB) {
				result = Convert.ToString(a + b)
			} else {
				result = valueA + valueB
			}
		}
	}
}