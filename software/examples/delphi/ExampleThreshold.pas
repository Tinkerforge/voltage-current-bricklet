program ExampleThreshold;

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
    procedure ReachedCB(sender: TBrickletVoltageCurrent; const current: longint);
    procedure Execute;
  end;

const
  HOST = 'localhost';
  PORT = 4223;
  UID = 'ABC'; { Change to your UID }

var
  e: TExample;

{ Callback for current greater than 1A }
procedure TExample.ReachedCB(sender: TBrickletVoltageCurrent; const current: longint);
begin
  WriteLn(Format('Current is greater than 1A: %f', [current/1000.0]));
end;

procedure TExample.Execute;
begin
  { Create IP connection }
  ipcon := TIPConnection.Create;

  { Create device object }
  vc := TBrickletVoltageCurrent.Create(UID, ipcon);

  { Connect to brickd }
  ipcon.Connect(HOST, PORT);
  { Don't use device before ipcon is connected }


  { Get threshold callbacks with a debounce time of 10 seconds (10000ms) }
  vc.SetDebouncePeriod(10000);

  { Register threshold reached callback to procedure ReachedCB }
  vc.OnCurrentReached := {$ifdef FPC}@{$endif}ReachedCB;

  { Configure threshold for "greater than 1A" (unit is mA) }
  vc.SetCurrentCallbackThreshold('>', 1*1000, 0);

  WriteLn('Press key to exit');
  ReadLn;
  ipcon.Destroy;
end;

begin
  e := TExample.Create;
  e.Execute;
  e.Destroy;
end.
