unit HTcpAPI.TcpRequestsResponces;

interface

type
  HTcp_Requests = record
  public

    { Connection requests }
    const Connection_Open    = 101;
    const Connection_Close   = 102;
    const Connection_Encrypt = 103;
    const Connection_EndInit = 100;

  end;
  HTcp_Responces = record
  public

    { General }
    const OK     = 200;
    const OK_Msg = 201;
    const Warn   = 300;
    const Error     = 400;
    const Error_Msg = 401;

    { Connection }
    const Connection_Opened  = 2101;
    const Connection_Refused = 4101;
    const Connection_Closed  = 2102;
    const Connection_StartS  = 2103;

  end;

implementation

end.
