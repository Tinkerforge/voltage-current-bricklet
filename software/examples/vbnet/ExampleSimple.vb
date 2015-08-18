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
        System.Console.WriteLine("Voltage: " + (voltage/1000.0).ToString() + " V")

        System.Console.WriteLine("Press key to exit")
        System.Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
