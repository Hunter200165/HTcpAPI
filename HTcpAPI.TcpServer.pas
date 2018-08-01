unit HTcpAPI.TcpServer;

interface

uses
  System.Classes,
  IdTCPServer,
  IdContext,
  HTcpAPI.TcpContext,
  HCryptoAPI.Types;

{ HTcpAPI uses Indy to create high supported connections }

type
  HTcp_TTcpServer = class(TIdTCPServer)
  private
  protected
  public
    constructor Create(AOwner: TComponent);
  end;

implementation

{ HTcpAPI_TTcpServer }

constructor HTcp_TTcpServer.Create(AOwner: TComponent);
begin
  inherited;
  ContextClass := HTcp_TTcpContext;
end;

end.
