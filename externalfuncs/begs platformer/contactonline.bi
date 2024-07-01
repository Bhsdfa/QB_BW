Dim info(3)

If PlayersMax > 1 Then

    Print "You can just insert V and press enter to paste a copied IP."
    Print "If you dont want to play multiplayer just put 0."

    _Dest _Console: Input "Join or host? (0 - single, 1 - host, 2 - join): ", joinorhost: _Dest 0

    If joinorhost = 1 Then
        server& = _OpenHost("TCP/IP:25535")
        Print "Waiting for player 2! "
        Do
            connection& = _OpenConnection(server&)
        Loop Until connection& <> 0
        Print "2nd Player Joined!"
        _NotifyPopup "Multiplayer", "Player 2 Joined!", "info"
        Print "Connection: "; connection&
        Put connection&, 1, username$
        _Dest _Console: Print "Getting Player 2 name": _Dest 0
        Do
            Get connection&, 1, usernameP2$

        Loop While usernameP2$ = ""

        _Delay 1
    End If


    If joinorhost = 2 Then
        joinip$ = _InputBox$("Put a Valid IP: ")
        Print "IP entered: ", joinip$: _Delay 1
        1
        connection& = _OpenClient("TCP/IP:25535:" + joinip$)
        If connection& = 0 Then Print "Connection failed!": Sleep 2: Cls: GoTo 1
        Put connection&, , username$
        Do
            Get connection&, 1, usernameP2$
        Loop While usernameP2$ = ""

        Print "Got your username mr host!!!"
        _Delay 1
    End If
    If joinorhost = 0 Then multiplayer = -1
End If
_Dest _Console: Print "Going to load Map": _Dest 0
MapLoading:
If joinorhost <> 2 Then
    _Dest _Console: Input "Map name: ", MapNameCreate$: _Dest 0
    Call LoadMap
End If

If MapNameCreate$ = "" And joinorhost <> 2 Then GoTo MapLoading
If joinorhost = 1 Then
    Connect:
    i = 1
    Open ("assets\begs fight\maps\" + MapNameCreate$ + ".bhmap") For Input As #1
    Input #1, Name$
    Input #1, Filelength
    Input #1, trash
    Put connection&, 1, Name$
    'Put connection&, 3, numberamount

    Do
        _Limit 60
        i = i + 1
        Input #1, line$
        Put connection&, 2, line$
        Do
            _Limit 60
            Get connection&, , response
            o = o + 1
            If o = 800 Then Beep: Beep: Print "COULDNT GET RESPONSE FROM CLIENT!": _Delay 200
        Loop Until response = i Or o = 800
        Beep

    Loop Until Filelength = response

    Close #1
    Get connection&, , linesamount

    If lineslong <> lineslong Then Print "Failed to connect to partner!": Beep: GoTo Connect
End If


If joinorhost = 2 Then
    Name$ = ""
    i = 1
    Do
        _Limit 60
        Get connection&, 1, Name$
        o = o + 1
    Loop While Name$ = "" Or o = 800
    If o = 800 Then Beep: Beep: Beep: Print "COULDNT GET MAP NAME! ": _Delay 200
    Print Name$
    Open ("downloads/" + Name$ + ".bhmap") For Output As #1
    Print #1, Name$
    Do
        _Limit 60
        i = i + 1
        Do
            Get connection&, 2, line$

        Loop While line$ = ""
        If line$ = " END OF FILE " Then hasreachedendoflife = 1

        Print #1, line$
        Print "line: "; line$
        line$ = ""
        Put connection&, , i
    Loop Until hasreachedendoflife = 1
    Close #1
    MAP$ = ("downloads/" + Name$ + ".bhmap")
    Call LoadMap
End If





