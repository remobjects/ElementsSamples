namespace GoCrawler;

uses
  System.Collections.Generic,
  System.Linq,
  go.net.http,
  go.net.url,
  go.strings,
  go.golang.org.x.net.html;

type
  Program = class
  public

    // we spider docs.hydra4.com which is a fairly small site.
    const Root = 'https://docs.hydra4.com/';
    // and block the api urls because those are large.
    const BlockList: array of String = ['https://docs.hydra4.com/API'];

    class var fQueue: List<String> := new List<String>;
    class var fDone: HashSet<String> := new HashSet<String>;

    class method Queue(aUrl, aPath: String);
    begin
      // this resolves aPath relative to aUrl (the caller) and returns the real url. If aPath is a full url it returns jsut that.
      var lNewUrl := String(go.net.url.Parse(aUrl)[0].ResolveReference(go.net.url.Parse(aPath)[0]).String());
      // Ensure to only crawl our domain, skip blocklisted ones, and only process things we see first.
      if lNewUrl.StartsWith(Root) and not fDone.Contains(lNewUrl) and not BlockList.Any(a -> lNewUrl.StartsWith(a)) then
        fQueue.Add(lNewUrl);
    end;

    class method Crawl(aUrl: String);
    begin
      if not fDone.Add(aUrl) then exit;
      writeLn('Crawling '+aUrl);
      var lRes := go.net.http.Get(aUrl);

      if lRes.err <> nil then begin
        writeLn('Error getting '+aUrl+': '+lRes.err.Error())
      end
      else begin
        // Parses the html for this rul
        var lTok := NewTokenizer(lRes.resp.Body);
        loop begin
          var lElement := lTok.Next();
          case lElement.Value of
            // ErrorToken.Value is EOF in most cases, or a parser error; either way, we stop here.
            ErrorToken.Value: break;
            StartTagToken.Value: begin
                var lToken := lTok.Token;
                // Start tag "a", with a href means a sub page.
                if lToken.Data ='a' then
                  for each el in lToken.Attr do
                    if el[1].Key = 'href' then
                      Queue(aUrl, el[1].Val);
              end;
          end;
        end;
      end;
    end;

    class method Main(args: array of String): Int32;
    begin
      Queue(Root, Root);
      while fQueue.Count > 0 do begin
        var lItem := fQueue[0];
        fQueue.RemoveAt(0);
        Crawl(lItem);
      end;

      for each el in fDone do begin
        writeLn('Page: '+el);
      end;

      writeLn('Done');
      Console.ReadLine;
    end;

  end;

end.