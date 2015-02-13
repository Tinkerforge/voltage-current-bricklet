Imports Tinkerforge

Module ExampleThreshold
    Const HOST As String = "localhost"
    Const PORT As Integer = 4223
    Const UID As String = "aNt" ' Change to your UID

    ' Callback for current greater than 1A
    Sub ReachedCB(ByVal sender As BrickletVoltageCurrent, ByVal current As Integer)
        System.Console.WriteLine("Current is greater than 1A: " + (current/1000.0).ToString() + "A")
    End Sub

    Sub Main()
        Dim ipcon As New IPConnection() ' Create IP connection
        Dim vc As New BrickletVoltageCurrent(UID, ipcon) ' Create device object

        ipcon.Connect(HOST, PORT) ' Connect to brickd
        ' Don't use device before ipcon is connected

        ' Get threshold callbacks with a debounce time of 10 seconds (10000ms)
        vc.SetDebouncePeriod(10000)

        ' Register threshold reached callback to function ReachedCB
        AddHandler vc.CurrentReached, AddressOf ReachedCB

        ' Configure threshold for "greater than 1A" (unit is mA)
        vc.SetCurrentCallbackThreshold(">"C, 1*1000, 0)

        System.Console.WriteLine("Press key to exit")
        System.Console.ReadLine()
        ipcon.Disconnect()
    End Sub
End Module
