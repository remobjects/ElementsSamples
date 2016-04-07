using Foundation;

namespace ToDoManager
{
	public class Helpers
	{
		static private Helpers _instance;
 		static public Helpers sharedInstance 
		{
			get 
			{
				if (_instance == null)
				{
					_instance = new Helpers();
				}
				return _instance;
			}
		}
		
		private NSDateFormatter _dateFormatter;
		private NSNumberFormatter _decimalFormatter;
		public override id init()
		{
			this = base.init();
			if (this != null)
			{
				_dateFormatter = new NSDateFormatter();
				_dateFormatter.dateStyle = NSDateFormatterStyle.NSDateFormatterMediumStyle;
				_dateFormatter.timeStyle = NSDateFormatterStyle.NSDateFormatterMediumStyle;
				
				_decimalFormatter = new NSNumberFormatter();
				_decimalFormatter.numberStyle= NSNumberFormatterStyle.NSNumberFormatterDecimalStyle;
				
			}
			return this;	
		}
		
		public String stringFromDate(NSDate value)
		{
			if (value == null)
				return "date is null";
		    return _dateFormatter.stringFromDate(value);
		}
		
		public NSNumber decimalNumberFromString(String value)
		{
		   if ((value == null) || (value.length == 0))
			   return NSNumber.alloc().initWithInt(0);
			return _decimalFormatter.numberFromString(value);
		}
	}
}
