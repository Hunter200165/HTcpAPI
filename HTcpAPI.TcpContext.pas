unit HTcpAPI.TcpContext;

interface

uses
  System.SysUtils,
  IdContext,
  IdIOHandler,
  IdCustomTCPServer;

type
  HTcp_EBadRequest = class(Exception);

type
  HTcp_TTcpContext = class(TIdServerContext)
  private
    FCachedResponce: UInt64;
    FCachedRequest: UInt64;

  public
    property CachedResponce: UInt64 read FCachedResponce;
    property CachedRequest: UInt64 read FCachedRequest;

    { Internal }
    procedure SendInt64(const Context: UInt64);
    function ReceiveInt64: UInt64;

    procedure PerformConnection;
  end;

implementation

{ HTcp_TTcpContext }

procedure HTcp_TTcpContext.PerformConnection;
begin
  if ReceiveInt64 <> 101 then
    raise HTcp_EBadRequest.Create('Bad request: ' + CachedRequest.ToString);
  SendInt64(200);
end;

function HTcp_TTcpContext.ReceiveInt64: UInt64;
begin
  Result := Connection.IOHandler.ReadUInt64;
  FCachedRequest := Result;
  Writeln('Client -> ', Result);
end;

procedure HTcp_TTcpContext.SendInt64(const Context: UInt64);
begin
  FCachedResponce := Context;
  Connection.IOHandler.Write(UInt64(Context));
  Writeln('Client <- ', Context);
end;

end.
