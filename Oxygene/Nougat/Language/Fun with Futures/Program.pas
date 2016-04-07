namespace FunWithFutures;

interface

type
  ConsoleApp = static class
  private
    method Fast: String;
    method Medium: String;
    method Slow: String;

  public
    method Main(args: array of String);

  end;

implementation

method ConsoleApp.Main(args: array of String);
begin
  writeLn('Welcome to the Future.');
  writeLn();

  var f, m, s: future String;

  writeLn('Test 1: Sync Futures');
  writeLn();
  writeLn('In this first and simples case, two variables will be initialized to regular NON-ASYNC');
  writeLn('futures. As a result, "m" and "s" will be evaluated one after the other:');
  writeLn();

  s := Slow();
  m := Medium();
  writeLn(s+m);

  writeLn('Test 2: One Async Future');
  writeLn();
  writeLn('Now, we use an ASYNC future for the second value. This way, while "s" is being evaluated');
  writeLn('inline, "m" can alreasdy start processing in the background and will, in fact, br ready');
  writeLn('by the time it is needed');
  writeLn();

  s := Slow();
  m := async Medium();
  writeLn(s+m);

  writeLn('Test 3: More Async Future');
  writeLn();
  writeLn('In fact, several async futures can run in parallel, CPU cores permitting, so that in the');
  writeLn('following scenario, both "s" and "m" evakluate in the backgorund.');
  writeLn();
  writeLn('Note that "f" of course finishes first, and execution will then block to wait for "s"');
  writeLn('and then "m" to be finished');
  writeLn();

  f := Fast();
  s := async Slow();
  m := async Medium();
  writeLn(f+s+m);

  writeLn('Test 4: Futures wirth Anonymous methods and Lambdas');
  writeLn();
  writeLn('Instead of calling methods, we can also provide a value to a future via an anonymous method');
  writeLn('or a lambda expression (which really are just two syntaxes for the same underlying thing.');
  writeLn();
  writeLn('Note also that since we do not reassign "m", but do reuse it, the "Medium" method will not');
  writeLn('be called again. Futures are only evalauted ones, and their value is then available immediately,');
  writeLn('any time you reference the future.');
  writeLn();

  f := -> begin writeLn('-> fast λ'); result:= 'Fast λ '; writeLn('<- Fast λ'); end;
  s := async method: String begin 
         writeLn('-> Slow λ'); 
         usleep(3000000);
         result := 'Slow λ '; 
         writeLn('<- Slow λ'); 
       end;
  writeLn(f+s+m);

  writeLn();
end;

method ConsoleApp.Fast: String;
begin
  writeLn('-> Fast');
  usleep(10000);
  result := 'Fast ';
  writeLn('<- Fast');
end;

method ConsoleApp.Medium: String;
begin
  writeLn('-> Medium');
  usleep(1000000);
  result := 'Medium ';
  writeLn('<- Medium');
end;

method ConsoleApp.Slow: String;
begin
  writeLn('-> Slow');
  usleep(3000000);
  result := 'Slow ';
  writeLn('<- Slow');
end;

end.
