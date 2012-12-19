program ExampleSimple;

{$ifdef MSWINDOWS}{$apptype CONSOLE}{$endif}
{$ifdef FPC}{$mode OBJFPC}{$H+}{$endif}

uses
  SysUtils, IPConnection, BrickletVoltageCurrent;

type
  TExample = class
  private
    ipcon: TIPConnection;
    vc: TBrickletVoltageCurrent;
  public
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'ABC'; { Change to your UID }

var
  e: TExample;

procedure TExample.Execute;
var current: longint;
var voltage: longint;
begin
  { Create IP connection to brickd }
  ipcon := TIPConnection.Create(HOST, PORT);

  { Create device object }
  vc := TBrickletVoltageCurrent.Create(UID);

  { Add device to IP connection }
  ipcon.AddDevice(vc);
  { Don't use device before it is added to a connection }

  { Get current current and voltage (unit is mA and mV) }
  current := vc.GetCurrent;
  voltage := vc.GetVoltage;
  WriteLn(Format('Current: %f A', [current/1000.0]));
  WriteLn(Format('Voltage: %f V', [voltage/1000.0]));

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy;
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
