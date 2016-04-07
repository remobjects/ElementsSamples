namespace nullabletypes;

interface

type
  ConsoleApp = class
  public
    class method Main(args: array of String);
    
  end;

implementation

class method ConsoleApp.Main(args: array of String);

    method UsingColonOperator;
    var 
      MyString: String := 'Oxygene';
    begin
       // usual call, lLength = 7;
       var lLength: Integer := MyString.length;
       
       MyString := nil;
    
       // nil value will be converted to 0
       lLength := MyString:length; 
    
       // lLen will be a nullable Int32
       var lLen := MyString:length;  
    end;
    
    method AssigningAndCasting;
    begin
      var n: nullable Integer := nil;
      var i: Integer := 10;
  
      // nil value will be converted to 0
      i := n; 
      
      // following line will throw a null reference exception because n is nil
      i := Int32(n); 
      
      // following line will work fine n = 10;
      i:= 10;
      n := i;
   end;   
   
   method UsingValueOrDefault;
    begin 
      var n: nullable Integer; // initialized to nil
      var i: Integer; // initialized to 0
  
      // will assign 0 if n is nil
      i := valueOrDefault(n);
  
      // will assign -1 if n is nil
      i := valueOrDefault(n, -1); 
    end;

begin  
  AssigningAndCasting;
  UsingColonOperator;
  UsingValueOrDefault;
end;


end.
