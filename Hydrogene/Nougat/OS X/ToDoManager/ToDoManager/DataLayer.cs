using Foundation;

namespace ToDoManager
{
	public class DataLayer
	{
		#region Singleton
		static private DataLayer _instance;
		 static public DataLayer sharedInstance 
		{
			get 
			{
				if (_instance == null)
				{
					_instance = new DataLayer();
				}
				return _instance;
			}
		}
		#endregion
		
		#region Properties
		private String _dataFileName;
		
		public NSMutableArray tasks { private set; get; }
		#endregion
		
		public override id init() 
		{
			NSString documentsDirectory = Foundation.NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.NSDocumentDirectory, NSSearchPathDomainMask.NSUserDomainMask, true).firstObject();
			_dataFileName = documentsDirectory.stringByAppendingPathComponent("tasks.plist");
			
			this.load();
		}
		
		#region Serialization/Deserialization
		public void save()
		{
			NSData data = NSKeyedArchiver.archivedDataWithRootObject(this.tasks);
			data.writeToFile(_dataFileName) atomically(true);
			NSLog("Data has been saved to local file (%@)", _dataFileName);
		}
		
		public void load()
		{
			Boolean hasFile = NSFileManager.defaultManager.fileExistsAtPath(_dataFileName);
			if (hasFile) 
			{
				NSData data = NSData.dataWithContentsOfFile(_dataFileName) options(0) error(null);
				this.tasks = NSKeyedUnarchiver.unarchiveObjectWithData(data);
				NSLog("Data has been loaded from local file (%@)", _dataFileName);
			}
			else
			{
				this.generateTestData();
				NSLog("Test data has been generated");
			}
		}
		#endregion 
		
		#region Helper methods
		
		public static TaskModel newTaskWithSubject(String subj) andPriority(NSInteger prio) datedBy(NSDate due)
		{
			TaskModel t = new TaskModel();
			t.subject = subj;
			t.priority = prio;
			t.dueDate = due;
			return t;
		}
		
		private void generateTestData()
		{
			tasks = new NSMutableArray();
			
			tasks.addObject(
				DataLayer.newTaskWithSubject("Meeting with Kate") 
					andPriority(9) 
					datedBy(new NSDate()));
			
			tasks.addObject(
				DataLayer.newTaskWithSubject("Buy some food") 
					andPriority(5) 
					datedBy(new NSDate().dateByAddingTimeInterval( 60 * 60 * 24 * 3)));
			
			TaskModel doneTaskSample = 
				DataLayer.newTaskWithSubject("Fill the car") 
					andPriority(2) 
					datedBy(new NSDate().dateByAddingTimeInterval( 60 * 60 * 24 * 2));
			doneTaskSample.done = true;

			tasks.addObject(doneTaskSample);
		}
		#endregion
	}
}
