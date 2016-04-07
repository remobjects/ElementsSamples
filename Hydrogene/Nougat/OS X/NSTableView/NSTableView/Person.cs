using AppKit;

namespace NSTableView
{
    public class Person
    {
        private string fName;
        private NSInteger fAge;

        public string name {
            get {
              return fName;
             }
             set {
               fName = value;
             }
        }

        public NSInteger age {
            get {
              return fAge;
             }
             set {
               fAge = value;
             }
        }		
    }
}
