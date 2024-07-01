If Not _DirExists("assets") Then
    Print "YOU ARE MISSING 'assets'!"
    Print "PROGRAM WILL NOT CONTINUE DUE TO NO ASSET FILES."
    Print "Contact Bhsdfa if this is wrong."
    Do
        _Limit 1
        u = u + 1
        If u = 1 Then Beep
        If u = 2 Then u = 1
    Loop While InKey$ = ""
    _Delay 2
    System
End If
If Not _DirExists("assets/begs platform") Then
    Print "YOU ARE MISSING 'assets/begs platform'!"
    Print "PROGRAM WILL NOT CONTINUE DUE TO NO ASSET FILES."
    Print "Contact Bhsdfa if this is wrong."
    Do
        _Limit 1
        u = u + 1
        If u = 1 Then Beep
        If u = 2 Then u = 1
    Loop While InKey$ = ""
    _Delay 2
    System
End If
If Not _FileExists("assets/begs platform/settings/PlayerSettings.bhconfig") Then
    Print "You are missing PlayerSettings.bhconfig!"
    Print "Not Having this file will result in a ''Noobie'' nickname and default resolution."
    If _MessageBox("Begs Platformer", "Do you want to set it up?", "yesno", "question") = 1 Then
        username$ = _InputBox$("Begs Platformer", "Enter your name:", "Noobie")
        resolution$ = _InputBox$("Begs Platformer", "Enter your resolution ex: (800x600) (y res, x res):", "800x600")
        findx = InStr(1, resolution$, "x")
        resx = Val(Mid$(resolution$, 1, findx))
        resy = Val(Mid$(resolution$, findx + 1, Len(resolution$)))
        Open "assets/begs platform/settings/PlayerSettings.bhconfig" For Output As #1
        Print #1, username$
        Print #1, resx
        Print #1, resy
        Close #1
    Else
        Beep
        _MessageBox "Begs Platformer", "Ok then Noobie!"
        username$ = "Noobie"
        resx = 800
        resy = 600
End If: End If

If _FileExists("assets/begs platform/settings/PlayerSettings.bhconfig") Then
    Open "assets/begs platform/settings/PlayerSettings.bhconfig" For Input As #1
    Input #1, username$
    Input #1, resx
    Input #1, resy
    Close #1
End If
'Screen _NewImage(resx, resy, 32)

