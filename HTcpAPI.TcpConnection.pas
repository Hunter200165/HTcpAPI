unit HTcpAPI.TcpConnection;

interface

uses
  IdIntercept,
  IdContext,
  IdTCPConnection,
  InTCPConnection,
  HCryptoAPI.Types,
  HCryptoAPI.Commons,
  HCommonAPI.Intercept,
  HCommonAPI.Container,
  HTcpAPI.TcpContainer,
  HTcpAPI.TcpIntercept;

type
  HTcp_TTcpConnection = class(HTcp_TConnectionBase)
  private
    FContainers: HTcp_TTcpContainerList;
    FConnection: TIdTCPConnection;
  public
    property Containers: HTcp_TTcpContainerList read FContainers write FContainers;
    property Connection: TIdTCPConnection read FConnection write FConnection;

    { Methods }
    (* Internal *)
    procedure SendInt64Internal(const Content: UInt64);
    function ReceiveInt64Internal: UInt64;

    constructor Create(AOwner: HTcp_TTcpIntercept);
    destructor Destroy; override;
  end;

implementation

{ HTcp_TTcpConnection }

constructor HTcp_TTcpConnection.Create(AOwner: HTcp_TTcpIntercept);
begin
  inherited Create(AOwner);
  Containers := HTcp_TTcpContainerList.Create;
  Connection := Owner.TcpConnection;
end;

destructor HTcp_TTcpConnection.Destroy;
begin
  Containers.Free;
  inherited;
end;

function HTcp_TTcpConnection.ReceiveInt64Internal: UInt64;
begin
  Result := Connection.IOHandler.ReadUInt64;
end;

procedure HTcp_TTcpConnection.SendInt64Internal(const Content: UInt64);
begin
  Connection.IOHandler.Write(UInt64(Content));
end;

end.
