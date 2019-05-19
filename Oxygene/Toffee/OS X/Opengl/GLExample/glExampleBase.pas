namespace GLExample;

type
 IAppInterface = public interface
  method update(width, Height : Integer; const ATotalTimeSec : Double := 0.3);
  method ChangeFillmode;
  method Initialize : Boolean;
end;



end.