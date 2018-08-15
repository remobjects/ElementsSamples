package SharedUI.Shared;

public __partial class MainWindowController
{
	private void setup()
	{
		//
		//  Do any shared initilaization, here
		//
	}

	//
	// Add Shared code here
	//

	@Notify public String valueA { __get; __set; }
	@Notify public String valueB { __get; __set; }
	@Notify public String result { __get; private __set; }

	@IBAction
	public void calculateResult(id sender)
	{
		if ((length(valueA) == 0) | (length(valueB) == 0))
		{
			result = "(value required)";
		}
		else
		{
			var a = Convert.TryToDoubleInvariant(valueA);
			var b = Convert.TryToDoubleInvariant(valueB);
			if (a != null & b != null)
			{
				result = Convert.ToString(a + b);
			}
			else
			{
				result = valueA + valueB;
			}
		}
	}
}