unit HTcpAPI.TcpClient;

interface

uses
  System.Types,
  System.Classes,
  System.SysUtils,
  IdTCPClient,
  HCryptoAPI.Types,
  HTcpAPI.TcpConnection,
  HTcpAPI.TcpIntercept;

type 
  HTcp_EInvalidResponce = class(Exception);
  
type
  HTcp_TTcpClient = class(TIdTCPClient)
  private
    FTcpConnection: HTcp_TTcpConnection;
    FCachedResponce: UInt64;
    FCachedRequest: UInt64;
  public
    property TcpConnection: HTcp_TTcpConnection read FTcpConnection write FTcpConnection;
    property CachedResponce: UInt64 read FCachedResponce;
    property CachedRequest: UInt64 read FCachedRequest;

    procedure SendInt64(const Context: UInt64);
    function ReceiveInt64: UInt64;
    procedure PerformConnection;

    constructor Create(AOwner: TComponent);
  end;

implementation

{ HTcp_TTcpClient }

constructor HTcp_TTcpClient.Create(AOwner: TComponent);
begin
  inherited;
//  Intercept := HTcp_TTcpIntercept.Create(Self);
//  TcpConnection := (Intercept as HTcp_TTcpIntercept).HTcpConnecion as HTcp_TTcpConnection;
end;

procedure HTcp_TTcpClient.PerformConnection;
begin
  { Open connection }
  SendInt64(101);
  if not (ReceiveInt64 = 200) then
    raise HTcp_EInvalidResponce.Create('Unexpected: ' + CachedResponce.ToString);
end;

function HTcp_TTcpClient.ReceiveInt64: UInt64;
begin
  Result := IOHandler.ReadUInt64;
  FCachedResponce := Result;
  Writeln('Server -> ', Result);
end;

procedure HTcp_TTcpClient.SendInt64(const Context: UInt64);
begin
  FCachedRequest := Context;
  IOHandler.Write(UInt64(Context));
  Writeln('Server <- ', Context);
end;

end.
