namespace AllLanguageFeatures;

interface

type
  ISomeEvents = public interface
    event Foo: OnFoo; { automatically abstract, like all interface members }
  end;

  Events = assembly abstract class(ISomeEvents) { no Object needed when implementing interface }
  private
    fBar: OnBar;
    method AddBar(aEvent: OnBar);
    method RemoveBar(aEvent: OnBar);
    method RaiseBar(aString: String);
  protected
  public
    event Foo: OnFoo;
    event Bar: OnBar delegate fBar; virtual; final;
    event Bar2: OnBar add AddBar remove RemoveBar;

    event FooFoo: OnFoo; abstract; { no virtual needed for abstarct, in Oxygene }

    { Oxygene only: }
    event BarFoo: OnBar raise;
    event Full: OnBar add AddBar remove RemoveBar public raise RaiseBar;
  end;

  Events2 = assembly sealed class(Events)
  public
    event Bar2: OnBar; reintroduce; { reintroduce supported for non-method members }
    event FooFoo: OnFoo; override; { no virtual needed! }
  end;

  OnFoo = public delegate;
  OnBar = assembly delegate(aString: string);

  { backward compatibility }
  OnOld = delegate(x: integer) of object;
  OnOld2 = procedure(x: integer);
  OnOld3 = function(x: integer): string;
  OnOld4 = function(x: integer): string of object;


implementation

method Events.AddBar(aEvent: OnBar);
begin
end;

method Events.RemoveBar(aEvent: OnBar);
begin
end;

method Events.RaiseBar(aString: String);
begin
end;

end.