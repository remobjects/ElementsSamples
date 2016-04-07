namespace CirrusTraceAspectLibrary;

interface

uses
  RemObjects.Elements.Cirrus;

type
  // This attribute will be transformed into RemObjects Cirrus Aspect later.
  // Note how RemObjects.Elements.Cirrus.IMethodDefinition interface is implemented
  // Also note how WriteLine method declaration is marked. This method will be injected into target class of aspect
  // Aspects should be declared in separate library so Cirrus framework will be able to apply them to target classes
  // In most cases nor this library assembly containing Aspects nor RemObjects.Elements.Cirrus assembly aren't needed to
  // run resulting application
  [AttributeUsage(AttributeTargets.Class)]
  TraceAttribute = public class(Attribute, RemObjects.Elements.Cirrus.IMethodImplementationDecorator)
  public
    [Aspect:RemObjects.Elements.Cirrus.AutoInjectIntoTarget]
    method WriteLine(aEnter: Boolean; aName: String; Args: Array of object); 

    method HandleImplementation(Services: RemObjects.Elements.Cirrus.IServices; aMethod: RemObjects.Elements.Cirrus.IMethodDefinition);
  end;

  
implementation


method TraceAttribute.HandleImplementation(Services: RemObjects.Elements.Cirrus.IServices; aMethod: RemObjects.Elements.Cirrus.IMethodDefinition);
begin
  // This check is needed to prefent endless recursion when method WriteLine  is called
  if  (String.Equals(aMethod.Name, 'WriteLine', StringComparison.OrdinalIgnoreCase))  then
    exit;

  // This call modifies method implementation in target class by injecting there some code
  // Note that typeOf(self) there will return type of target class, not type of TraceAttribute
  // try .. finally statement is used to make sure that WriteLine method will be called after original method call, even if
  // this method contain exit() statements
  aMethod.SetBody(Services,
    method begin
      try
        WriteLine(true, String.Format('{0}.{1}', typeOf(self), Aspects.MethodName), Aspects.GetParameters);
        Aspects.OriginalBody;
      finally
        WriteLine(false, Aspects.MethodName, nil);
      end;
    end);
end;

  // This method will be inserted into aspect target class
method TraceAttribute.WriteLine(aEnter: Boolean; aName: String; Args: Array of object);
begin
  var lMessage: String := 'Trace:  ' + iif(aEnter, 'Entering ', 'Exiting ') + aName;
  
  if  (aEnter  and  (assigned(Args)))  then  begin
    lMessage := lMessage + ' with arguments';
    for  I: Int32  :=  0  to  Length(Args)-1  do
      lMessage := lMessage + String.Format(' {0}', Args[i]);
  end;

  Console.WriteLine(lMessage);
end;


end.
