unit HTcpAPI.TcpConnection.Client;

interface

uses
  HCryptoAPI.Types,
  HTcpAPI.TcpConnection;

type
  HTcp_TClientTcpConnection = class(TObject)
  private
    FBaseConnection: HTcp_TTcpConnection;
  public
    property BaseConnection: HTcp_TTcpConnection read FBaseConnection write FBaseConnection;

    constructor Create(AConnection: HTcp_TTcpConnection);
  end;

implementation

{ HTcp_TClientTcpConnection }

constructor HTcp_TClientTcpConnection.Create(AConnection: HTcp_TTcpConnection);
begin
  BaseConnection := AConnection;
end;

end.
