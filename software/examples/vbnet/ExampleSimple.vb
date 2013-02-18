Imports Tinkerforge

Module ExampleSimple
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "aNt" ' Change to your UID

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim vc As New BrickletVoltageCurrent(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get current current and voltage (unit is mA and mV)
        Dim current As Integer = vc.GetCurrent()
        Dim voltage As Integer = vc.GetVoltage()

        System.Console.WriteLine("Current: " + (current/1000.0).ToString() + " A")
        System.Console.WriteLine("Voltage: " + (voltage/1000.0).ToString() + " V")

        System.Console.WriteLine("Press key to exit")
        System.Console.ReadKey()
        ipcon.Disconnect()
    End Sub
End Module
