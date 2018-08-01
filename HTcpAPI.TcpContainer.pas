unit HTcpAPI.TcpContainer;

interface

uses
  System.Generics.Collections,
  HCommonAPI.Container;

{ This containers are used in TCP connection class }
type
  HTcp_TTcpContainer = class(HCommon_Container);
  HTcp_TTcpContainerList = TObjectList<HTcp_TTcpContainer>;

implementation

end.
