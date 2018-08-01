unit HTcpAPI.TcpIntercept;

interface

uses
  System.Classes,
  IdTCPConnection,
  IdIntercept,
  IdGlobal,
  IdBlockCipherIntercept,
  HCryptoAPI.Types,
  HCommonAPI.Intercept;

type
  HTcp_TcpIntercept_OnRead  = procedure(var Buffer: TBytesArray) of object;
  HTcp_TcpIntercept_OnWrite = procedure(var Buffer: TBytesArray) of object;
  HTcp_TcpIntercept_OnConnect    = procedure of object;
  HTcp_TcpIntercapt_OnDisconnect = procedure of object;
  HTcp_TSimpleTcpIntercept = class(TIdConnectionIntercept)
  protected
    type HTcp_TcpIntercept_StreamEvent = TIdInterceptStreamEvent;
    type HTcp_TcpIntercept_NotifyEvent = TIdInterceptNotifyEvent;
  private
    FOnConnect_Callback: HTcp_TcpIntercept_OnConnect;
    FOnDisconnect_Callback: HTcp_TcpIntercapt_OnDisconnect;
    FOnWrite_Callback: HTcp_TcpIntercept_OnWrite;
    FOnRead_Callback: HTcp_TcpIntercept_OnRead;
    FIntercept: HTcp_TSimpleTcpIntercept;
  protected

    procedure Connect_Callback(Refer: TIdConnectionIntercept);
    procedure Disconnect_Callback(Refer: TIdConnectionIntercept);
    procedure Write_Callback(Refer: TIdConnectionIntercept; var Bytes: TIdBytes);
    procedure Read_Callback(Refer: TIdConnectionIntercept; var Bytes: TIdBytes);

  public
    { Callbacks }
    property OnConnect_Callback: HTcp_TcpIntercept_OnConnect read FOnConnect_Callback write FOnConnect_Callback;
    property OnDisconnect_Callback: HTcp_TcpIntercapt_OnDisconnect read FOnDisconnect_Callback write FOnDisconnect_Callback;
    property OnWrite_Callback: HTcp_TcpIntercept_OnWrite read FOnWrite_Callback write FOnWrite_Callback;
    property OnRead_Callback: HTcp_TcpIntercept_OnRead read FOnRead_Callback write FOnRead_Callback;

    { Intercept }
    property Intercept: HTcp_TSimpleTcpIntercept read FIntercept write FIntercept;

    function GetLastIntercept: HTcp_TSimpleTcpIntercept;

    constructor Create(AConnection: TComponent);
    destructor Destroy; override;
  end;

  HTcp_TConnectionBase = class;
  HTcp_TTcpIntercept = class(TIdConnectionIntercept)
  protected
    { To Inherit old class, we need to add support }
    type HTcp_TcpIntercept_StreamEvent = TIdInterceptStreamEvent;
    type HTcp_TcpIntercept_NotifyEvent = TIdInterceptNotifyEvent;
  private
    FTcpConnection: TidTCPConnection;
    FOnRead_Callback: HTcp_TcpIntercept_OnRead;
    FOnWrite_Callback: HTcp_TcpIntercept_OnWrite;
    FOnReadIn: HTcp_TcpIntercept_StreamEvent;
    FOnWriteIn: HTcp_TcpIntercept_StreamEvent;
    FOnConnectIn: HTcp_TcpIntercept_NotifyEvent;
    FOnDisconnectIn: HTcp_TcpIntercept_NotifyEvent;
    FOnConnect_Callback: HTcp_TcpIntercept_OnConnect;
    FOnDisconnect_Callback: HTcp_TcpIntercapt_OnDisconnect;
    FIntercept: HTcp_TSimpleTcpIntercept;
    FHTcpConnecion: HTcp_TConnectionBase;
  protected
    { To Inherit old class, we need to add support }
    property OnReadIn: HTcp_TcpIntercept_StreamEvent read FOnReadIn write FOnReadIn;
    property OnWriteIn: HTcp_TcpIntercept_StreamEvent read FOnWriteIn write FOnWriteIn;
    property OnConnectIn: HTcp_TcpIntercept_NotifyEvent read FOnConnectIn write FOnConnectIn;
    property OnDisconnectIn: HTcp_TcpIntercept_NotifyEvent read FOnDisconnectIn write FOnDisconnectIn;

    procedure Connected_Callback(Refer: TIdConnectionIntercept);
    procedure Disconnected_Callback(Refer: TIdConnectionIntercept);
    procedure Write_Callback(Refer: TIdConnectionIntercept; var Bytes: TIdBytes);
    procedure Read_Callback(Refer: TIdConnectionIntercept; var Bytes: TIdBytes);
    
  public
    { Changing the Intercept to private usage. }
    property TcpConnection: TidTCPConnection read FTcpConnection write FTcpConnection;
    property Intercept: HTcp_TSimpleTcpIntercept read FIntercept write FIntercept;
    property HTcpConnecion: HTcp_TConnectionBase read FHTcpConnecion write FHTcpConnecion;

    property OnRead_Callback: HTcp_TcpIntercept_OnRead read FOnRead_Callback write FOnRead_Callback;
    property OnWrite_Callback: HTcp_TcpIntercept_OnWrite read FOnWrite_Callback write FOnWrite_Callback;
    property OnConnect_Callback: HTcp_TcpIntercept_OnConnect read FOnConnect_Callback write FOnConnect_Callback;
    property OnDisconnect_Callback: HTcp_TcpIntercapt_OnDisconnect read FOnDisconnect_Callback write FOnDisconnect_Callback;

    function GetLastIntercept: HTcp_TSimpleTcpIntercept;

    constructor Create(AConnection: TComponent);
    destructor Destroy; override;
  end;

  HTcp_TServerTcpIntercept = class(TIdServerIntercept)
  protected
    procedure InitComponent; override;
  public
    procedure Init; override;
    function Accept(AConnection: TComponent): TIdConnectionIntercept; override;
  end;

  HTcp_TConnectionBase = class(TObject)
  private
    FIntercept: HTcp_TTcpIntercept;
  public
    property Owner: HTcp_TTcpIntercept read FIntercept write FIntercept;
    constructor Create(AOwner: HTcp_TTcpIntercept);
  end;

implementation

{ HTcp_TTcpIntercept }

uses
  HTcpAPI.TcpConnection;

procedure HTcp_TTcpIntercept.Connected_Callback(Refer: TIdConnectionIntercept);
begin
  { Internal code }
  if Assigned(OnConnect_Callback) then begin
    TcpConnection := Connection as TIdTCPConnection;
    (HTcpConnecion as HTcp_TTcpConnection).Connection := TcpConnection;
    OnConnect_Callback;
  end;
  if Assigned(Intercept) then
    Intercept.Connect(Self.Connection);
end;

constructor HTcp_TTcpIntercept.Create(AConnection: TComponent);
begin
  inherited;
  TcpConnection := AConnection as TIdTCPConnection;

  { Callbacks }
  OnConnectIn := Connected_Callback;
  OnDisconnectIn := Disconnected_Callback;
  OnWriteIn := Write_Callback;
  OnReadIn := Read_Callback;

  OnSend := OnWriteIn;
  OnReceive := OnReadIn;
  OnConnect := OnConnectIn;
  OnDisconnect := OnDisconnectIn;

  HTcpConnecion := HTcp_TTcpConnection.Create(Self);
end;

destructor HTcp_TTcpIntercept.Destroy;
begin
  if Assigned(Intercept) then
    Intercept.Free;
  inherited;
end;

procedure HTcp_TTcpIntercept.Disconnected_Callback(Refer: TIdConnectionIntercept);
begin
  if Assigned(Intercept) then
    Intercept.Disconnect;
  if Assigned(OnDisconnect_Callback) then
    OnDisconnect_Callback;
end;

function HTcp_TTcpIntercept.GetLastIntercept: HTcp_TSimpleTcpIntercept;
begin
  Result := nil;
  if Assigned(Intercept) then
    Result := Intercept.GetLastIntercept;
end;

procedure HTcp_TTcpIntercept.Read_Callback(Refer: TIdConnectionIntercept; var Bytes: TIdBytes);
begin
  if Assigned(Intercept) then
    Intercept.Receive(Bytes);
  if Assigned(OnRead_Callback) then
    OnRead_Callback(TBytesArray(Bytes));
end;

procedure HTcp_TTcpIntercept.Write_Callback(Refer: TIdConnectionIntercept; var Bytes: TIdBytes);
begin
  if Assigned(OnWrite_Callback) then
    OnWrite_Callback(TBytesArray(Bytes));
  if Assigned(Intercept) then
    Intercept.Send(Bytes);
end;

{ HTcp_TConnectionBase }

constructor HTcp_TConnectionBase.Create(AOwner: HTcp_TTcpIntercept);
begin
  inherited Create;
  Owner := AOwner;
end;

{ HTcp_TSimpleTcpIntercept }

procedure HTcp_TSimpleTcpIntercept.Connect_Callback(Refer: TIdConnectionIntercept);
begin
  if Assigned(OnConnect_Callback) then
    OnConnect_Callback;
  if Assigned(Intercept) then
    Intercept.Connect(Self.Connection);
end;

constructor HTcp_TSimpleTcpIntercept.Create(AConnection: TComponent);
begin
  inherited;
  { Callbacks }
  OnConnect := Connect_Callback;
  OnDisconnect := Disconnect_Callback;
  OnSend := Write_Callback;
  OnReceive := Read_Callback;
end;

destructor HTcp_TSimpleTcpIntercept.Destroy;
begin
  if Assigned(Intercept) then
    Intercept.Free;
  inherited;
end;

procedure HTcp_TSimpleTcpIntercept.Disconnect_Callback(Refer: TIdConnectionIntercept);
begin
  if Assigned(Intercept) then
    Intercept.Disconnect;
  if Assigned(OnDisconnect_Callback) then
    OnDisconnect_Callback;
end;

function HTcp_TSimpleTcpIntercept.GetLastIntercept: HTcp_TSimpleTcpIntercept;
begin
  Result := Self;
  if Assigned(Intercept) then
    Result := Intercept.GetLastIntercept;
end;

procedure HTcp_TSimpleTcpIntercept.Read_Callback(Refer: TIdConnectionIntercept; var Bytes: TIdBytes);
begin
  if Assigned(Intercept) then
    Intercept.Receive(Bytes);
  if Assigned(OnRead_Callback) then
    OnRead_Callback(TBytesArray(Bytes));
end;

procedure HTcp_TSimpleTcpIntercept.Write_Callback(Refer: TIdConnectionIntercept; var Bytes: TIdBytes);
begin
  if Assigned(OnWrite_Callback) then
    OnWrite_Callback(TBytesArray(Bytes));
  if Assigned(Intercept) then
    Intercept.Send(Bytes);
end;

{ HTcp_TServerTcpIntercapt }

function HTcp_TServerTcpIntercept.Accept(AConnection: TComponent): TIdConnectionIntercept;
begin
  { Returning Intercept }
  Result := HTcp_TTcpIntercept.Create(AConnection);
end;

procedure HTcp_TServerTcpIntercept.Init;
begin
  { Empty space. }
end;

procedure HTcp_TServerTcpIntercept.InitComponent;
begin
  inherited;
  { Empty space }
end;

end.
