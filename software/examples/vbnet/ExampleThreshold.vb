Imports Tinkerforge

Module ExampleThreshold
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "XYZ" ' Change to your UID

    ' Callback function for power greater than 10 W (parameter has unit mW)
    Sub PowerReachedCB(ByVal sender As BrickletVoltageCurrent, ByVal power As Integer)
        System.Console.WriteLine("Power: " + (power/1000.0).ToString() + " W")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim vc As New BrickletVoltageCurrent(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        vc.SetDebouncePeriod(10000)

        ' Register threshold reached callback to function PowerReachedCB
        AddHandler vc.PowerReached, AddressOf PowerReachedCB

        ' Configure threshold for "greater than 10 W" (unit is mW)
        vc.SetPowerCallbackThreshold(">"C, 10*1000, 0)

        System.Console.WriteLine("Press key to exit")
        System.Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
