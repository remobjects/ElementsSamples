namespace CirrusMethodLogAspectLibrary;

interface

uses
  RemObjects.Elements.Cirrus;

type
  [AttributeUsage(AttributeTargets.Class + AttributeTargets.Struct)]
  MethodLogAttribute = public class(Attribute, RemObjects.Elements.Cirrus.IMethodImplementationDecorator)
  public
    [Aspect:RemObjects.Elements.Cirrus.AutoInjectIntoTarget]
    method LogMessage(aEnter: Boolean; aName: String; Args: Array of object); 

    method HandleImplementation(Services: RemObjects.Elements.Cirrus.IServices; aMethod: RemObjects.Elements.Cirrus.IMethodDefinition);
  end;

  
implementation


method MethodLogAttribute.HandleImplementation(Services: RemObjects.Elements.Cirrus.IServices; aMethod: RemObjects.Elements.Cirrus.IMethodDefinition);
begin
  if String.Equals(aMethod.Name, 'LogMessage', 
    StringComparison.OrdinalIgnoreCase) then exit;

  aMethod.SetBody(Services,
    method begin
      try
        LogMessage(true, typeof(self) + Aspects.MethodName, Aspects.GetParameters);
        Aspects.OriginalBody;
      finally
        LogMessage(false, Aspects.MethodName, Aspects.GetParameters);
      end;
    end);
end;


method MethodLogAttribute.LogMessage(aEnter: Boolean; aName: String; Args: Array of object);
begin
  var lMessage: String := iif(aEnter, 'Entering ', 'Exiting ') + aName;
  
  if  (aEnter  and  (assigned(Args)))  then  begin
    lMessage := lMessage + ' with arguments';
    for  I: Int32  :=  0  to  Length(Args)-1  do
      lMessage := lMessage + String.Format(' {0}', Args[i]);
  end;

  Console.WriteLine(lMessage);
end;


end.
