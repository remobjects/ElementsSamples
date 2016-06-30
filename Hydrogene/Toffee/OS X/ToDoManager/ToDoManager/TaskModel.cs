using Foundation;

namespace ToDoManager
{
	public class TaskModel: INSCoding
	{
		#region Properties
		public NSString subject { get; set; }
		public NSDate dueDate { get; set; }
		public NSNumber priority { get; set; }
		public Boolean done {get; set; }
		#endregion
		
		#region INSCoding implementation
		
		public void encodeWithCoder(NSCoder! coder)
		{
			coder.encodeObject(this.subject) forKey("subject");
			coder.encodeObject(this.dueDate) forKey("dueDate");
			coder.encodeObject(this.priority) forKey("priority");
			coder.encodeBool(this.done) forKey("done");
		}
		
		public instancetype initWithCoder(NSCoder! decoder)
		{
			this = base.init();
			if (this != null)
			{
				this.subject = decoder.decodeObjectForKey("subject");
				this.dueDate = decoder.decodeObjectForKey("dueDate");
				this.priority = decoder.decodeObjectForKey("priority");
				this.done = decoder.decodeBoolForKey("done");
			}
			return this;
		}
		
		#endregion
	}
}
