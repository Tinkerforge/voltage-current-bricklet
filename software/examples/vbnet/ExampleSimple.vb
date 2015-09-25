Imports System
Imports Tinkerforge

Module ExampleSimple
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change to your UID

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim vc As New BrickletVoltageCurrent(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get current voltage (unit is mV)
        Dim voltage As Integer = vc.GetVoltage()
        Console.WriteLine("Voltage: " + (voltage/1000.0).ToString() + " V")

        ' Get current current (unit is mA)
        Dim current As Integer = vc.GetCurrent()
        Console.WriteLine("Current: " + (current/1000.0).ToString() + " A")

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
