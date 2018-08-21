namespace SharedUI.Shared
{
	public partial class MainWindowController
	{
		private void setup()
		{
			//
			// Do any shared initilaization, here
			//
		}

		//
		// Add Shared code here
		//

		[Notify] public string valueA { get; set; }
		[Notify] public string valueB { get; set; }
		[Notify] public string result { get; private set; } = "N/A";

		[IBAction]
		public void calculateResult(id sender)
		{
			if (length(valueA) == 0 || length(valueB) == 0)
			{
				result = "(value required)";
			}
			else
			{
				var a = Convert.TryToDoubleInvariant(valueA);
				var b = Convert.TryToDoubleInvariant(valueB);
				if (a != null && b != null)
				{
					result = Convert.ToString(a+b);
				}
				else
				{
					result = valueA+valueB;
				}
			}
		}
	}
}