namespace CirrusCalculatorInterfaceAspectLibrary;

interface

uses
  RemObjects.Elements.Cirrus;

type
  // This attribute will be transformed into RemObjects Cirrus Aspect later.
  // Note how RemObjects.Elements.Cirrus.IMethodDefinition and RemObjects.Elements.Cirrus.ITypeImplementationDecorator
  // interfaces are implemented
  // 
  // Also note how GetItemFromCache and AddItemToCache method declarations are marked. These methods will be injected into target
  // class of aspect
  //
  // Aspects should be declared in separate library so Cirrus framework will be able to apply them to target classes
  // In most cases nor this library assembly containing Aspects nor RemObjects.Elements.Cirrus assembly aren't needed to
  // run resulting application


  [AttributeUsage(AttributeTargets.Class)]
  CalculatorInterfaceAttribute = public class(Attribute, RemObjects.Elements.Cirrus.ITypeInterfaceDecorator)
  public
    //[Aspect:RemObjects.Elements.Cirrus.AutoInjectIntoTarget]
    //class method GetItemFromCache(aArguments: array of Object; aCache: System.Collections.Hashtable): Object;
//
    //[Aspect:RemObjects.Elements.Cirrus.AutoInjectIntoTarget]
    //class method AddItemToCache(aArguments: array of Object; aCache: System.Collections.Hashtable; aValue: Object);
  //public
    //method HandleImplementation(Services: RemObjects.Elements.Cirrus.IServices; aMethod: RemObjects.Elements.Cirrus.IMethodDefinition);
    //method HandleImplementation(Services: RemObjects.Elements.Cirrus.IServices; aType: RemObjects.Elements.Cirrus.ITypeDefinition);
    method HandleInterface(Services: RemObjects.Elements.Cirrus.IServices; aType: RemObjects.Elements.Cirrus.ITypeDefinition);
  end;


implementation

//
//method CachedCalculationsAttribute.HandleImplementation(Services: RemObjects.Elements.Cirrus.IServices; aMethod: RemObjects.Elements.Cirrus.IMethodDefinition);
//begin
  //// Here target class constructor is modified. 
  //// Note how added thru this aspect private field fCache is accessed nad initialized
  //if  (String.Equals(aMethod.Name, '.ctor', StringComparison.OrdinalIgnoreCase))  then  begin
    //aMethod.SetBody(Services,
      //method begin
        //Aspects.OriginalBody;
//
        //unquote<System.Collections.Hashtable>(new RemObjects.Elements.Cirrus.Values.FieldValue(new RemObjects.Elements.Cirrus.Values.SelfValue(), aMethod.Owner.GetField('fCache'))) := new System.Collections.Hashtable();
      //end);
    //exit;
  //end;
//
  //if  (not String.Equals(aMethod.Name, 'Calculate', StringComparison.OrdinalIgnoreCase))  then  exit;
  //
  //// Only method with name Calculate will be modified
  //// Note how field fCache is accessed
  //// Also note how target method is modified and caching capatibilies are added there
  //aMethod.SetBody(Services,
    //method  begin
      //var lCache := unquote<System.Collections.Hashtable>(new RemObjects.Elements.Cirrus.Values.FieldValue(new RemObjects.Elements.Cirrus.Values.SelfValue(), aMethod.Owner.GetField('fCache')));
//
      //var lValue: Object := GetItemFromCache(Aspects.GetParameters(), lCache);
      //if  (assigned(lValue))  then
        //exit  Int64(lValue);
//
      //var lMethodResult: Int64;
      //try
        //Aspects.OriginalBody;
        //lMethodResult := Aspects.RequireResult;
      //finally
        //AddItemToCache(Aspects.GetParameters(), lCache, lMethodResult);
      //end;
    //end);
//end;
//
//// This method implements interface RemObjects.Elements.Cirrus.ITypeImplementationDecorator
//// Note how new field is added to target class
//method CachedCalculationsAttribute.HandleImplementation(Services: RemObjects.Elements.Cirrus.IServices; aType: RemObjects.Elements.Cirrus.ITypeDefinition);
//begin
  //aType.AddField('fCache', aType.GetContextType('System.Collections.Hashtable'), false);
//end;
//
//
//// This method will be injected into target class because it is marked as
//// [Aspect:RemObjects.Elements.Cirrus.AutoInjectIntoTarget]
//// in interface section
//// It returns value stored in cache, if this is possible or nil otherwise
//class method CachedCalculationsAttribute.GetItemFromCache(aArguments: array of Object; aCache: System.Collections.Hashtable): Object;
//begin
  //if  (not assigned(aArguments))  then 
    //exit  (nil);
//
  //if  (Length(aArguments) <> 1)  then 
    //exit  (nil);
//
  //var  lKey: Int32 := Int32(aArguments[0]);
//
  //if  (aCache.ContainsKey(lKey))  then
    //exit (aCache[lKey]);
//
  //exit  (nil);
//end;
//
//
//// This method will be injected into target class because it is marked as
//// [Aspect:RemObjects.Elements.Cirrus.AutoInjectIntoTarget]
//// in interface section
//// It put value provided to the cache
//class method CachedCalculationsAttribute.AddItemToCache(aArguments: array of Object; aCache: System.Collections.Hashtable; aValue: Object);
//begin
    //if  (not assigned(aArguments))  then 
    //exit;
//
  //if  (Length(aArguments) <> 1)  then 
    //exit;
//
  //var  lKey: Int32 := Int32(aArguments[0]);
//
  //if  (aCache.ContainsKey(lKey))  then
    //aCache[lKey] := aValue
  //else
    //aCache.Add(lKey, aValue);
//end;
//
method CalculatorInterfaceAttribute.HandleInterface(Services: RemObjects.Elements.Cirrus.IServices; aType: RemObjects.Elements.Cirrus.ITypeDefinition);
begin
  aType.AddInterface(aType.GetContextType('CalculatorLibrary.ICalculator'));
end;

//
end.
