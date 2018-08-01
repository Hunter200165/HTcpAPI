unit HTcpAPI.TcpServer.TestServer;

interface

uses
  System.Classes,
  System.SysUtils,
  IdContext,
  HTcpAPI.TcpContext,
  HTcpAPI.TcpServer;

type
  HTcpAPI_TTestTcpServer = class(HTcp_TTcpServer)
  public
    procedure IncomingExecution(AContext: TIdContext);

    constructor Create(AOwner: TComponent);
  end;

implementation

{ HTcpAPI_TTestTcpServer }

constructor HTcpAPI_TTestTcpServer.Create(AOwner: TComponent);
begin
  inherited;
  OnExecute := IncomingExecution;
  with Self.Bindings.Add do begin
    IP := '127.0.0.1';
    Port := 51245;
  end;
end;

procedure HTcpAPI_TTestTcpServer.IncomingExecution(AContext: TIdContext);
var Context: HTcp_TTcpContext;
begin
  Context := AContext as HTcp_TTcpContext;
  try
    Context.PerformConnection;
    Writeln('Connection done.');
  except
    on E: Exception do begin
      Writeln('Unhandled exception: ' + E.Message);
    end;
  end;
  Context.Connection.Disconnect;
end;

end.
