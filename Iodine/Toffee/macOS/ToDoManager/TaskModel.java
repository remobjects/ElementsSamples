package ToDoManager;

import Foundation.*;

public class TaskModel implements INSCoding
{
	public NSString subject;// { get; set; }
	public NSDate dueDate;// { get; set; }
	public NSNumber priority;// { get; set; }
	public Boolean done;// {get; set; }

	public void encodeWithCoder(NSCoder coder)
	{
		coder.encodeObject(this.subject) forKey("subject");
		coder.encodeObject(this.dueDate) forKey("dueDate");
		coder.encodeObject(this.priority) forKey("priority");
		coder.encodeBool(this.done) forKey("done");
	}

	public instancetype initWithCoder(NSCoder decoder)
	{
		this = super.init();
		if (this != null)
		{
			this.subject = decoder.decodeObjectForKey("subject");
			this.dueDate = decoder.decodeObjectForKey("dueDate");
			this.priority = decoder.decodeObjectForKey("priority");
			this.done = decoder.decodeBoolForKey("done");
		}
		return this;
	}
}