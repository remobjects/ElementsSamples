namespace NullableTypes;

interface

type
  ConsoleApp = class
  public
    class method Main;
    
  end;

implementation

class method ConsoleApp.Main;

    method UsingColonOperator;
    var 
      MyString: string := 'Oxygene';
    begin
       // usual call, lLength = 7;
       var lLength: Int32 := MyString.Length;
       writeLn(lLength);
       
       MyString := nil;
    
       // nil value will be converted to 0
       lLength := MyString:Length; 
    
       // lLength2 will be a nullable Int32
       var lLength2 := MyString:Length;  
       writeLn(lLength2);
    end;
    
    method AssigningAndCasting;
    begin
      var n: nullable Int32 := nil;
      var i: Int32 := 10;
  
      // nil value will be converted to 0
      i := n; 
      
      // following line will throw an invalid cast exception because n is nil
      // i := Int32(n); 
      
      // following line will work fine n = 10;
      i:= 10;
      n := i;
   end;   
   
   method UsingValueOrDefault;
    begin 
      var n: nullable Int32; // initialized to nil
      var i: Int32; // initialized to 0
  
      // will assign 0 if n is nil
      i := valueOrDefault(n);
  
      // will assign -1 if n is nil
      i := valueOrDefault(n, -1);
      writeLn(i);
    end;

begin  
  AssigningAndCasting;
  UsingColonOperator;
  UsingValueOrDefault;
end;


end.