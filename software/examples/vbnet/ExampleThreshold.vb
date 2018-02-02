Imports System
Imports Tinkerforge

Module ExampleThreshold
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change XYZ to the UID of your Voltage/Current Bricklet

    ' Callback subroutine for power reached callback
    Sub PowerReachedCB(ByVal sender As BrickletVoltageCurrent, ByVal power As Integer)
        Console.WriteLine("Power: " + (power/1000.0).ToString() + " W")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim vc As New BrickletVoltageCurrent(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        vc.SetDebouncePeriod(10000)

        ' Register power reached callback to subroutine PowerReachedCB
        AddHandler vc.PowerReachedCallback, AddressOf PowerReachedCB

        ' Configure threshold for power "greater than 10 W"
        vc.SetPowerCallbackThreshold(">"C, 10*1000, 0)

        Console.WriteLine("Press key to exit")
        Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
