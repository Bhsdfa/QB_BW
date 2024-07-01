Screen _NewImage(900, 600, 32)
Print "First Start"
$Color:32
Dim Shared MAP$
Dim Shared username$
'$Include:'externalfuncs/begs platformer/types.bi''
Print "Include Types done"
'$Include:'externalfuncs/begs platformer/checkonrun.bi''
Print "Include Check on run done"
'$Include:'externalfuncs/begs platformer/loadassets.bi''
Print "Finished Running Includes (1)"
Type Dialog
    bx1 As Long
    by1 As Long
    bx2 As Long
    by2 As Long
    boxsizex As Long
    boxsizey As Long
    text1 As String
    text1size As Integer
    lettercord As Integer
    text2 As String
    text21 As String
    text22 As String
    text23 As String
    targetx As Long
    targety As Long
    arrowx As Integer
    arrowy As Integer
    arrowsize As Integer
    colors As Long
    active As Integer
    setdelaypl As Integer
    delaypl As Integer
End Type
Dim Shared Dialog As Dialog
Type Particle
    y As Long
    x As Long
    types As Integer
    age As Integer
    xm As Double
    ym As Double
    stale As Integer
    gravity As Double
    dead As Integer
End Type
Dim Shared ParticleMax
ParticleMax = 10000
Dim Shared Part(ParticleMax) As Particle
'textures:
Type textures
    id As Integer
    txtname As String
    originalsizex As Integer
    originalsizey As Integer
End Type
Dim Shared TexturesMaxQuantity
Open "assets/_UNIV/textures/_TexturesValue.txt" For Input As #1
Input #1, trash$
Input #1, TexturesMaxQuantity
Dim Shared TexturesImg(TexturesMaxQuantity)
txt = 1
Dim Shared Texture(TexturesMaxQuantity) As textures
For txt = 1 To TexturesMaxQuantity
    Beep
    Texture(txt).id = txt
    Input #1, Texture(txt).txtname
    TexturesImg(txt) = _LoadImage("assets/_UNIV/textures/" + RTrim$(LTrim$(Str$(txt))) + ".png")
    Texture(txt).originalsizex = _Width(TexturesImg(txt))
    Texture(txt).originalsizey = _Height(TexturesImg(txt))
Next
Close #1

Type Trigger
    x1 As Long
    x2 As Long
    y1 As Long
    y2 As Long
    x As Long
    y As Long
    types As Integer
    outputtoid As Integer
    inputfromid As Integer
    value As Integer
    text As String
    setdelaypl As Integer
End Type
Dim Shared Trigger(128) As Trigger


Dialog.bx1 = 7
Dialog.by1 = 467
Dialog.bx2 = 812
Dialog.by2 = 592
Dialog.boxsizex = Dialog.bx2 - Dialog.bx1
Dialog.boxsizey = Dialog.by2 - Dialog.by1



Dialog.arrowx = 411
Dialog.arrowy = 467
Dialog.arrowsize = 40
'QuickSettings
FreeCamMaxDistance = 4000
RenderBegsModel = 1
CameraShake = 0
FreeCam = 0


'$Include:'externalfuncs/begs platformer/dims.bi''
Print "Include Dims Done": _Dest 0
Dim Shared TriggerID


If PlayersMax > 1 Then

    Print "You can just insert V and press enter to paste a copied IP."
    Print "If you dont want to play multiplayer just put 0."

    Input "Join or host? (0 - single, 1 - host, 2 - join): ", joinorhost

    If joinorhost = 1 Then
        server& = _OpenHost("TCP/IP:25539")
        Print "Waiting for player 2! "
        Do
            connection& = _OpenConnection(server&)
        Loop Until connection& <> 0
        Print "2nd Player Joined!"
        _NotifyPopup "Multiplayer", "Player 2 Joined!", "info"
        Print "Connection: "; connection&
        Put connection&, 1, username$
        Print "Getting Player 2 name":
        Do
            Get connection&, 1, usernameP2$
        Loop While usernameP2$ = ""
        _Delay 1
    End If


    If joinorhost = 2 Then
        joinip$ = _InputBox$("Put a Valid IP: ")
        Print "IP entered: ", joinip$: _Delay 1
        1
        connection& = _OpenClient("TCP/IP:25539:" + joinip$)
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
Print "Going to load Map"
MapLoading:
If joinorhost <> 2 Then
    Input "Map name: ", MapNameCreate$
    MAP$ = ("assets\begs fight\maps\" + MapNameCreate$ + ".bhmap")
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
        response = 0
        i = i + 1
        Input #1, line$
        Put connection&, 2, line$
        Do
            Get connection&, , response
            If response <> 0 Then _Dest console: Print "Host got response from client!": _Dest 0
        Loop Until response <> 0
    Loop Until EOF(1)
    Close #1
End If


If joinorhost = 2 Then
    Name$ = ""
    i = 1
    hasreachedendoflife = 0
    Do
        Get connection&, 1, Name$
        o = o + 1
    Loop While Name$ = "" Or o = 800
    If o = 800 Then Print "COULDNT GET MAP NAME! "
    Print "MAP NAME IS: "; Name$
    Open ("downloads/" + Name$ + ".bhmap") For Output As #1
    Print #1, Name$
    Print #1, "420"
    Print #1, "69"
    Do

        i = i + 1
        'If i > 300 Then i = 0
        Do
            Get connection&, , line$

        Loop While line$ = ""
        If line$ = RTrim$(LTrim$("END OF FILE")) Then hasreachedendoflife = 1

        Print #1, line$
        Print "line: "; line$
        line$ = ""
        Put connection&, , i
    Loop Until hasreachedendoflife = 1

    Close #1
    MAP$ = ("downloads/" + Name$ + ".bhmap")
    Call LoadMap
End If
























Print "Include Contact Online Done"
For i = 1 To ParticleMax
    Part(i).dead = 1
Next

Player(1).health = 100
Player(1).types = -1
ItemsMax = 20
For y = 1 To 20
    Item(y).x = 200 + y * 8
    Item(y).y = 1 - y * 16
    Item(y).sizex = 16
    Item(y).sizey = 16
    Item(y).gravity = 3
    Item(y).playecanpickup = 1
    Item(y).hard = 1
Next

If hostorjoin = 0 Then
    Player(2).sizex = 1
    Player(2).sizey = 1
End If

Dim Shared Begsfont&
'Dim Shared NickNameP1
Dim Shared NickNameP2
Begsfont$ = "assets\begs platform\mouse.ttf"
Begsfont2& = _LoadFont(Begsfont$, 20, "")


Carlinhos = _LoadImage("assets/begs platform/textures/carlinhos.png")


thx = _PrintWidth(username$)
thy = _FontHeight(Begsfont2&)
NickNameP1 = _NewImage(thx * 3, thy * 3, 32)
If joinorhost = 0 Then usernameP2$ = "404"


thxP2 = _PrintWidth(usernameP2$)
thy = _FontHeight(Begsfont2&)
NickNameP2 = _NewImage(thxP2 * 3, thy * 3, 32)


_Dest NickNameP1: _Font Begsfont2&: Print username$
_Dest NickNameP2: _Font Begsfont2&: Print usernameP2$
Player(1).xm = -10

_Dest 0
_Source 0
PlayerInWater = 0
oxygen = 2000
Do: _Limit 60: Cls:
    PlayerInWater = 0
    If ParticleSummon >= ParticleMax Then ParticleSummon = 2
    ff% = ff% + 1
    If Timer - start! >= 1 Then fps% = ff%: ff% = 0: start! = Timer
    Do While _MouseInput
        Mousex = _MouseX
        Mousey = _MouseY
        MouseClick = _MouseButton(1)
    Loop
    If Part(1).age > 0 And Part(1).age < 64 Then Part(1).age = Part(1).age - 4
    'Debugs
    If _KeyDown(18688) Then Player(1).sizex = Player(1).sizex + 1: Player(1).sizey = Player(1).sizex * 2
    If _KeyDown(20736) Then Player(1).sizex = Player(1).sizex - 1: Player(1).sizey = Player(1).sizex * 2
    If _KeyDown(20224) Then Player(1).sizex = 32: Player(1).sizey = 64
    If ChatOnScreen < 0 Then ChatOnScreen = ChatOnScreen + 1
    If ChatOnScreen > 3 Then ChatOnScreen = ChatOnScreen - 1
    If ChatOnScreen = 5 Then ChatOnScreen = 0

    If Player(1).x > 15000 Then Player(1).x = -15000
    If Player(1).x < -15000 Then Player(1).x = 15000
    If Player(1).y > 16000 Then Player(1).y = -16000
    If Player(1).y < -16000 Then Player(1).y = 16000

    If Player(1).sizex < 4 Then Player(1).sizex = 4

    Player(1).xb = Player(1).x
    Player(1).yb = Player(1).y

    GoSub KeyboardInput 'Call sub to get keys from the keyboard and apply them to joy.(...)
    GoSub InputToPlayer 'Puts the Joy.(...) to actual player movement

    'Physics related
    GoSub Playerxys
    GoSub Entitiesxyz
    GoSub EntitiesPhyis
    GoSub MapBlockPhysics
    GoSub Playerphysics 'explains itself.
    GoSub ItemStuff
    If Noclip = 0 Then If Player(1).xb <> Player(1).x And Player(1).yb <> Player(1).y Then GoSub CheckInBetween


    If Noclip = 1 Then
        If _KeyDown(119) Then If Player(1).ym > -120 Then Player(1).ym = Player(1).ym - 4
        If Player(1).ym < 0 Then Player(1).ym = Player(1).ym + 1
        If Player(1).ym > 0 Then Player(1).ym = Player(1).ym - 1
    End If


    'All interactions here!
    If Player(1).interaction = 1 And Part(1).age > 0 And ChatOnScreen = 0 And Player(1).referencedtotype = 1 Then GoSub DialogStart

    If Player(1).interaction = 1 And Part(1).age > 0 And Player(1).referencedtotype = 2 Then
        Item(Player(1).referencedtoid).referencedtoid = 1
        Item(Player(1).referencedtoid).referencedtotype = 1
        Player(1).animstate = 2

    End If
    For p = 1 To 2
        If Player(p).interaction = 2 And Player(p).referencedtotype = 2 And Player(p).referencedtoid <> 0 Then
            VectorX = 0
            VectorY = 0
            RotThrow = 0
            If p = 1 Then RotThrow = PlayerBody(4).rotation + 180
            If p = 2 Then RotThrow = PlayerBody(10).rotation - 180
            If RotThrow > 180 Then RotThrow = RotThrow - 180
            If RotThrow < -180 Then RotThrow = RotThrow + 180
            If p = 1 Then Angle2Vector PlayerBody(4).rotation, VectorX, VectorY
            If p = 2 Then Angle2Vector PlayerBody(10).rotation, VectorX, VectorY
            Item(Player(p).referencedtoid).xm = -Int(VectorX * 100)
            Item(Player(p).referencedtoid).ym = -Int(VectorY * 100)
            Player(p).animstate = 1
            Item(Player(p).referencedtoid).referencedtoid = 0
            Item(Player(p).referencedtoid).referencedtotype = 0
            Player(p).referencedtotype = 0
            Player(p).referencedtoid = 0
        End If
    Next








    'online capabilities
    If joinorhost <> 0 Then GoSub Online

    GoSub Render


    Line (_Width - 80, _Height - 80)-(_Width, _Height), _RGB32(255, 255, 255), BF

    If HudUpdate > 0 Then HudUpdate = HudUpdate - 1
    If HudUpdate = 0 Then GoSub HudUpdate

    _PutImage (_Width - 75, _Height - 75)-(_Width - 5, _Height - 5), BegsHud_Health
    If Player(1).invulnerability > 0 Then Player(1).invulnerability = Player(1).invulnerability - 1

    'Debug only
    Print "FPS: "; fps%
    Print "Player.x: "; Player(1).x
    Print "Player.y: "; Player(1).y
    'Print "Player.health: "; Player(1).health
    'Print "Player(1).crouchchange: "; Player(1).crouchchange



    If Delay > 0 Then Delay = Delay - 1
    If RayDisplayCounts > 0 Then RayDisplayCounts = RayDisplayCounts - 1
    If RayBestCounts > 0 Then RayBestCounts = RayBestCounts - 1: If RayBestCounts = 0 Then RayBiggest = 0
    If RayDisplayCounts > 0 Then Print "Ray travel: "; RayCounts
    If RayBestCounts > 0 Then Print " RayBiggest: "; RayBiggest
    RayCounts = 0
    If FreeCam = 0 Then
        If CameraYOffSetSpeed <> 0 Or CameraXOffSetSpeed <> 0 Or CameraYOffSet <> 0 Then CameraIsOffSet = 1
        If CameraIsOffSet = 1 Then
            For i = 1 To 3
                If CameraXOffSet > -CameraXOffSetSpeed * 2 And CameraXOffSet < CameraXOffSetSpeed * 2 Then If CameraXOffSetSpeed > 0 Then CameraXOffSetSpeed = CameraXOffSetSpeed - 1
                If CameraXOffSet > -CameraXOffSetSpeed * 2 And CameraXOffSet < CameraXOffSetSpeed * 2 Then If CameraXOffSetSpeed < 0 Then CameraXOffSetSpeed = CameraXOffSetSpeed + 1
                If CameraYOffSet > -CameraYOffSetSpeed * 2 And CameraYOffSet < CameraYOffSetSpeed * 2 Then If CameraYOffSetSpeed > 0 Then CameraYOffSetSpeed = CameraYOffSetSpeed - 1
                If CameraYOffSet > -CameraYOffSetSpeed * 2 And CameraYOffSet < CameraYOffSetSpeed * 2 Then If CameraYOffSetSpeed < 0 Then CameraYOffSetSpeed = CameraYOffSetSpeed + 1
            Next
            If CameraXOffSet > 0 Then CameraXOffSet = CameraXOffSet + CameraXOffSetSpeed: CameraXOffSetSpeed = CameraXOffSetSpeed - 1
            If CameraXOffSet < 0 Then CameraXOffSet = CameraXOffSet + CameraXOffSetSpeed: CameraXOffSetSpeed = CameraXOffSetSpeed + 1
            If CameraYOffSet > 0 Then CameraYOffSet = CameraYOffSet + CameraYOffSetSpeed: CameraYOffSetSpeed = CameraYOffSetSpeed - 1
            If CameraYOffSet < 0 Then CameraYOffSet = CameraYOffSet + CameraYOffSetSpeed: CameraYOffSetSpeed = CameraYOffSetSpeed + 1
            If CameraYOffSetSpeed = 0 And CameraXOffSetSpeed = 0 Then If CameraYOffSet = 0 And CameraXOffSet = 0 Then CameraIsOffSet = 0

        End If
    End If
    For j = 1 To 2
        Print "Player("; j; ").referencedtoid:"; Player(j).referencedtoid
        Print "Player("; j; ").referencedtotype:"; Player(j).referencedtotype

        Print "Item("; j; ").referencedtoid"; Item(j).referencedtoid
    Next
    Player(1).referencedtoid = -1
    Player(1).referencedtotype = 0
    If PlayerInWater = 1 And oxygen >= 0 Then oxygen = oxygen - 2
    If PlayerInWater = 0 And oxygen < 2000 Then oxygen = oxygen + 2
    For i = 1 To 5
        If ParticleSummon >= ParticleMax Then ParticleSummon = 2
        ParticleSummon = ParticleSummon + 1
        Part(ParticleSummon).x = (Int(Rnd * (_Width + 80))) - 40 + Player(1).x
        Part(ParticleSummon).y = Int(Rnd * 20) - 10 + (Player(1).y - _Width / 2)
        Part(ParticleSummon).ym = 10
        Part(ParticleSummon).dead = 0
        Part(ParticleSummon).age = 50
        Part(ParticleSummon).gravity = 1
    Next
    Print "oxygen: "; oxygen
    Print "Particles: "; particlesused
    _Display
Loop






Textures:
_Dest 0
For i = 1 To BlockID
    If MapBlocks(i).texture <> 0 Then
        txtapplyx = MapBlocks(i).x1 - Texture(txtid).originalsizex
        txtapplyy = MapBlocks(i).y1
        txtid = MapBlocks(i).texture
        Do
            txtapplyx = txtapplyx + Texture(txtid).originalsizex
            If txtapplyx > MapBlocks(i).x2 Then txtapplyx = MapBlocks(i).x1: txtapplyy = txtapplyy + Texture(txtid).originalsizey
            If txtapplyy > MapBlocks(i).y2 Then Exit Do
            If txtapplyx + Texture(txtid).originalsizex > MapBlocks(i).x2 Then txtapplyx = MapBlocks(i).x2
            If txtapplyy + Texture(txtid).originalsizey > MapBlocks(i).y2 Then txtapplyy = MapBlocks(i).y2
            _PutImage (Int(txtapplyx) + CameraX, Int(txtapplyy) + CameraY)-(Int(txtapplyx + Texture(txtid).originalsizex) + CameraX, Int(txtapplyy + Texture(txtid).originalsizey) + CameraY), TexturesImg(txtid)
        Loop

    End If
Next
Return












CheckonScreenForCollision:



Return



HudUpdate:
_Dest BegsHud_Health
Line (16, 16)-(111, 111), _RGBA32(0, 0, 0, 128), BF
Line (0, 128 - (Player(1).health * 1.28))-(128, 128), _RGB32(236, 76, 119), BF
_PutImage (0, 0)-(128, 128), BegsImg_FaceMask

If oxygen <= 1999 Then
    _Dest BegsHud_WaterMask1
    Cls
    _SetAlpha 0, _RGB32(0, 0, 0), BegsHud_WaterMask1
    Line (0, 0)-(_Width, _Height), _RGBA32(WaterColorR, WaterColorG, WaterColorB, WaterColorA), BF
    _PutImage (0, 0)-(_Width, _Height), BegsHud_WaterMask ', BegsHud_WaterMask1, (wateranimation, Int(oxygen * 0.064))-(wateranimation + 32, Int(oxygen * 0.064) + 32)
    _SetAlpha 0, _RGB32(255, 0, 191), BegsHud_WaterMask1
    '_ClearColor _RGB32(255, 0, 191), BegsHud_WaterMask1

    _Dest BegsHud_Health
End If

If oxygen < 2000 Then
    wateranimation = wateranimation + 2
    If wateranimation >= 220 Then wateranimation = wateranimation - 220
    _PutImage (0, 0)-(128, 128), BegsHud_WaterMask1, BegsHud_Health, (wateranimation, 38 - Int(oxygen * 0.032))-(wateranimation + 32, 38 - Int(oxygen * 0.032) + 32)
End If

_Dest 0
HudUpdate = 8

Return






Playerphysics:
If Player(1).xm < -500 Then Player(1).xm = -500
If Player(1).xm > 500 Then Player(1).xm = 500
If Player(1).ym < -800 Then Player(1).ym = -800
If Player(1).ym > 500 Then Player(1).ym = 500
If Player(1).xm < 0 Then Player(1).xm = Player(1).xm + 1
If Player(1).xm > 0 Then Player(1).xm = Player(1).xm - 1
If Player(1).touchingy1 > 0 Then Player(1).touchingy1 = Player(1).touchingy1 - 1
If Player(1).touchingy2 > 0 Then Player(1).touchingy2 = Player(1).touchingy2 - 1
If Player(1).touchingx1 > 0 Then Player(1).touchingx1 = Player(1).touchingx1 - 1
If Player(1).touchingx2 > 0 Then Player(1).touchingx2 = Player(1).touchingx2 - 1
If Player(1).crouchchange > 120 Then Death = 1
If Player(1).crouchchange < -60 Then Player(1).crouchchange = -60
If Noclip = 0 Then Player(1).ym = Player(1).ym + Player(1).gravity
Player(1).gravity = GravityDEF
Player(1).jumppower = -110
Player(1).x = Player(1).x + (Player(1).xm / 10)
Player(1).y = Player(1).y + (Player(1).ym / 10)
' Wet Particles

If PlayerInWater = 0 And oxygen < 2000 Then
    ParticleSummon = ParticleSummon + 1
    Part(ParticleSummon).ym = Int(Rnd * 10)
    Part(ParticleSummon).xm = Int(Rnd * 32)
    Part(ParticleSummon).x = Player(1).x1 + (Int(Rnd * Player(1).sizex * 2))
    Part(ParticleSummon).y = Player(1).y1 + (Int(Rnd * Player(1).sizey * 2))
    Part(ParticleSummon).gravity = 0.2
    Part(ParticleSummon).age = 150
    Part(ParticleSummon).dead = 0

End If
Return

ParticleLogic:
particlesused = 0
For p = 2 To ParticleMax
    If Part(p).dead = 0 Then
        particlesused = particlesused + 1
        If Part(p).x + CameraX < 0 Then Part(p).x = Part(p).x + _Width + 5
        If Part(p).x + CameraX > _Width Then Part(p).x = Part(p).x - _Width - 5
        If Part(p).y < Player(1).y - _Height Then Part(p).y = Part(p).y + _Height + 20

        Part(p).age = Part(p).age - 1
        If Part(p).age <= 0 Then Part(p).dead = 1
        Part(p).ym = Part(p).ym + Part(p).gravity
        For i = 1 To MapBlocksMax
            If MapBlocks(i).collide = 1 Then If ParticleCollide(Part(p), MapBlocks(i)) Then Part(p).ym = 0: Part(p).xm = 0: Part(p).dead = 1
        Next
        Part(p).y = Part(p).y + Part(p).ym / 2
        Part(p).x = Part(p).x + Part(p).xm / 10
        Line (Part(p).x - 1 + CameraX, Part(p).y - 3 + CameraY)-(Part(p).x + 1 + CameraX, Part(p).y + 1 + CameraY), _RGB32(0, 128, 128), BF
    End If
Next
Return










CheckInBetween:

RayReach = 0
dx = 0
dy = 0
dx = Player(1).x - Player(1).xb: dy = Player(1).y - Player(1).yb
Ray.x = Player(1).xb
Ray.y = Player(1).yb
Ray.angle = ATan2(dy, dx) ' Angle in radians
Ray.angle = (Ray.angle * 180 / PI) + 90
If Ray.angle > 180 Then Ray.angle = Ray.angle - 180
Ray.xvector = Sin(Ray.angle * PIDIV180)
Ray.yvector = -Cos(Ray.angle * PIDIV180)
Do
    If Ray.x + 1 >= Player(1).x - 1 Then If Ray.x - 1 <= Player(1).x + 1 Then If Ray.y + 1 >= Player(1).y - 1 Then If Ray.y - 1 <= Player(1).y + 1 Then RayReach = 1
    RayCounts = RayCounts + 1
    Ray.x = Ray.x - Ray.xvector
    Ray.y = Ray.y - Ray.yvector
    GoSub Playerxys

    For i = 1 To MapBlocksMax
        If MapsCollide(Player(1), MapBlocks(i)) Then
            If MapBlocks(i).state = 1 And _KeyDown(119) Then Player(1).ym = Player(1).ym - 8: If Player(1).ym < -25 Then Player(1).ym = Player(1).ym + 8.5 'Ladder
            If MapBlocks(i).state = 2 Then PlayerDeath = 2 ' Kill Block
            If MapBlocks(i).state = 4 And _KeyDown(119) Then Player(1).ym = Player(1).ym - 2: If Player(1).ym < -10 Then Player(1).ym = Player(1).ym + 2 ' Water
            If MapBlocks(i).state = 4 Then Player(1).gravity = .5: Player(1).jumppower = -50: PlayerInWater = 1: WaterColorR = MapBlocks(i).colorR: WaterColorG = MapBlocks(i).colorG: WaterColorB = MapBlocks(i).colorB: WaterColorA = MapBlocks(i).colorA 'Water
            If MapBlocks(i).collide = 1 Then
                If MapCollide(Player(1), MapBlocks(i)) Then
                    RayReach = 1
                End If
            End If
        End If
    Next

    If EntsCollide(Player(1), Player(2)) Then
        If EntCollide(Player(1), Player(2)) Then
            RayReach = 1
        End If
    End If

    For e = 1 To EntitiesID
        If EntsCollide(Player(1), Entity(e)) Then
            If EntCollide(Player(1), Entity(e)) Then
                If Entity(e).types <> -1 Then result = EntityHurtKnockBack(Player(1), Entity(e).x, Entity(e).y, 90, 10)
            End If
        End If
    Next




    If RayCounts > 100 Then RayReach = 1
    If RayReach = 1 Then GoSub Playerxys
Loop While RayReach = 0
RayDisplayCounts = 60
If RayBiggest < RayCounts Then
    RayBestCounts = 240
    RayBiggest = RayCounts
End If

If Part(1).age >= 64 Then Part(1).age = 62
'If Part(1).age <= 0 Then
'Player(1).referencedtoid = -1
'Player(1).referencedtotype = 0
'End i
For i = 1 To TriggerID
    If Player(1).referencedtotype = 0 And Trigger(i).types = 1 Then
        If TriggerCollide(Player(1), Trigger(i)) Then
            If Trigger(i).types = 1 Then
                Player(1).referencedtoid = i
                Player(1).referencedtotype = 1
                Part(1).x = Trigger(i).x
                Part(1).y = Trigger(i).y
                If Part(1).age <= 64 Then Part(1).age = Part(1).age + 8
            End If
            Exit For
        End If
    End If
Next

For i = 1 To ItemsMax
    If i <> Player(1).referencedtoid Then
        If EntsCollide(Player(1), Item(i)) Then
            If Item(i).playecanpickup = 1 Then
                If _KeyDown(101) Then
                    Player(1).referencedtoid = i
                    Player(1).referencedtotype = 2
                End If
                Part(1).x = Item(i).x
                Part(1).y = Item(i).y
                If Part(1).age <= 64 Then Part(1).age = Part(1).age + 8
            End If
        End If
    End If
Next



Return














'Dialog work
DialogStart:
Dialog.text1 = Trigger(Player(1).referencedtoid).text
Dialog.text1size = Len(Dialog.text1)
Dialog.text2 = " "
Dialog.targetx = Trigger(Player(1).referencedtoid).x
Dialog.targety = Trigger(Player(1).referencedtoid).y
Dialog.setdelaypl = Trigger(Player(1).referencedtoid).setdelaypl
Dialog.delaypl = 6
Dialog.lettercord = 0
ChatOnScreen = 1
Begsfont2& = _LoadFont(Begsfont$, 35, "")
thx2 = _PrintWidth(Dialog.text1)
thy2 = _FontHeight(Begsfont2&)
DialogImage = _NewImage(Dialog.boxsizex, thy2 * 10, 32) 'Dialog.boxsizey
_Dest DialogImage: Line (0, 0)-(_Width, _Height), _RGB32(255, 255, 255), BF: _Dest 0
Return

Dialog:
If Dialog.lettercord < Dialog.text1size + 1 Then
    If Dialog.delaypl = 0 Then
        Dialog.lettercord = Dialog.lettercord + 1
        Dialog.text2 = Dialog.text2 + Mid$(Dialog.text1, Dialog.lettercord, 1)
        If Not _KeyDown(101) Then Dialog.delaypl = Dialog.setdelaypl
        If _KeyDown(101) Then Dialog.delaypl = Int(Dialog.setdelaypl / 2)
        If Not _KeyDown(101) Then Sound 37, .1, .1, 0, 2: Sound 160, .2, .1, 0, 2
        If _KeyDown(101) Then Sound 67, .1, .1, 0, 2: Sound 190, .2, .1, 0, 2

    End If
    If Dialog.delaypl > 0 Then Dialog.delaypl = Dialog.delaypl - 1
Else
    If ChatOnScreen = 1 Then ChatOnScreen = 40
End If
Print ChatOnScreen

If Dialog.delaypl = 0 Then
    _Dest DialogImage: _Font Begsfont2&: View Print 1 To 4: Color Black, White: Print Dialog.text2:
    _Dest 0
    _Source 0
End If



Return

Render:
If CameraShake = 1 Then CameraYOffSet = 0: CameraXOffSet = 0
CameraYB = CameraY
CameraXB = CameraX
CameraY = -Player(1).y + _Height / 2
CameraX = -Player(1).x + _Width / 2
CameraYOffSet = Int(CameraYOffSet + CameraYOffSetSpeed / 10)
CameraXOffSet = Int(CameraXOffSet + CameraXOffSetSpeed / 10)
If FreeCam = 1 Then
    CameraYOffSet = CameraYOffSet + CameraY - CameraYB
    CameraXOffSet = CameraXOffSet + CameraX - CameraXB
End If
CameraY = CameraY - CameraYOffSet
CameraX = CameraX - CameraXOffSet
For i = 1 To BlockID
    Line (Int(MapBlocks(i).x1 + CameraX), Int(MapBlocks(i).y1 + CameraY))-(Int(MapBlocks(i).x2 + CameraX), Int(MapBlocks(i).y2 + CameraY)), _RGBA32(MapBlocks(i).colorR, MapBlocks(i).colorG, MapBlocks(i).colorB, MapBlocks(i).colorA), BF

    '_MapTriangle (0, 0)-(32, 0)-(32, 32), Txt_Mat_Begs To(Int(MapBlocks(i).x1 + CameraX), Int(MapBlocks(i).y1 + CameraY))-(Int(MapBlocks(i).x2 + CameraX), Int(MapBlocks(i).y1 + CameraY))-(Int(MapBlocks(i).x2 + CameraX), Int(MapBlocks(i).y2 + CameraY))
    '_MapTriangle (0, 0)-(0, 32)-(32, 32), Txt_Mat_Begs To(Int(MapBlocks(i).x1 + CameraX), Int(MapBlocks(i).y1 + CameraY))-(Int(MapBlocks(i).x1 + CameraX), Int(MapBlocks(i).y2 + CameraY))-(Int(MapBlocks(i).x2 + CameraX), Int(MapBlocks(i).y2 + CameraY))
Next
For e = 1 To EntitiesID
    Line (Int(Entity(e).x1 + CameraX), Int(Entity(e).y1 + CameraY))-(Int(Entity(e).x2 + CameraX), Int(Entity(e).y2 + CameraY)), _RGB32(255, 0, 0), BF
Next
For y = 1 To ItemsMax
    Line (Item(y).x1 + CameraX, Item(y).y1 + CameraY)-(Item(y).x2 + CameraX, Item(y).y2 + CameraY), _RGBA32(64, 64, 128, 200), BF
Next
For t = 1 To TriggerID
    Line (Int(Trigger(t).x1) + CameraX, Int(Trigger(t).y1) + CameraY)-(Int(Trigger(t).x2) + CameraX, Int(Trigger(t).y2) + CameraY), _RGBA32(255, 255, 0, 32), BF
    Line (Int(Trigger(t).x1) + CameraX, Int(Trigger(t).y1) + CameraY)-(Int(Trigger(t).x) + CameraX, Int(Trigger(t).y) + CameraY), _RGBA32(255, 255, 0, 64)
    Line (Int(Trigger(t).x2) + CameraX, Int(Trigger(t).y1) + CameraY)-(Int(Trigger(t).x) + CameraX, Int(Trigger(t).y) + CameraY), _RGBA32(255, 255, 0, 64)
    Line (Int(Trigger(t).x1) + CameraX, Int(Trigger(t).y2) + CameraY)-(Int(Trigger(t).x) + CameraX, Int(Trigger(t).y) + CameraY), _RGBA32(255, 255, 0, 64)
    Line (Int(Trigger(t).x2) + CameraX, Int(Trigger(t).y2) + CameraY)-(Int(Trigger(t).x) + CameraX, Int(Trigger(t).y) + CameraY), _RGBA32(255, 255, 0, 64)
Next
If Part(1).age > 1 Then _PutImage (Part(1).x + CameraX - (Part(1).age / 4), Part(1).y + CameraY - (Part(1).age / 4))-(Part(1).x + CameraX + (Part(1).age / 4), Part(1).y + CameraY + (Part(1).age / 4)), Part1_EKeyLogo
GoSub Textures
'rendering players
_PutImage ((Player(1).x + CameraX) - (thx) / 2.5, (Player(1).y1 + CameraY - thy) - 10), NickNameP1, 0, (0, 0)-(thx, thy)
_PutImage ((Player(2).x + CameraX) - (thxP2) / 2.5, (Player(2).y1 + CameraY - thy) - 10), NickNameP2, 0, (0, 0)-(thxP2, thy)


GoSub ParticleLogic





'distance
dx = Dialog.targetx + CameraX - Dialog.arrowx: dy = Dialog.targety + CameraY - Dialog.arrowy
Ray.x = Dialog.arrowx
Ray.y = Dialog.arrowy
Ray.angle = ATan2(dy, dx) ' Angle in radians
Ray.angle = (Ray.angle * 180 / PI) + 90
If Ray.angle > 180 Then Ray.angle = Ray.angle - 180
Ray.xvector = Sin(Ray.angle * PIDIV180)
Ray.yvector = -Cos(Ray.angle * PIDIV180)


' Chatting feature




Player(1).x1 = Player(1).xs - CameraXOffSet - (Player(1).sizex + Player(1).crouchchange / 4)
Player(1).x2 = Player(1).xs - CameraXOffSet + (Player(1).sizex + Player(1).crouchchange / 4)
Player(1).y1 = Player(1).ys - CameraYOffSet - (Player(1).sizey - Player(1).crouchchange)
Player(1).y2 = Player(1).ys - CameraYOffSet + Player(1).sizey
Player(2).x1 = Player(2).x1 + CameraX
Player(2).x2 = Player(2).x2 + CameraX
Player(2).y1 = Player(2).y1 + CameraY
Player(2).y2 = Player(2).y2 + CameraY


Line (Int(Player(1).x1), Int(Player(1).y1))-(Int(Player(1).x2), Int(Player(1).y2)), _RGBA32(255, 255, 255, 64), BF
Line (Int(Player(2).x1), Int(Player(2).y1))-(Int(Player(2).x2), Int(Player(2).y2)), _RGBA32(128, 128, 255, 64), BF

If RenderBegsModel = 1 Then GoSub RenderingBegs

CameraY = CameraY + CameraYOffSet
CameraX = CameraX + CameraXOffSet

'Hud
If ChatOnScreen > 0 Then
    GoSub Dialog
    Line (bx1, by1)-(bx2, by2), _RGB32(128, 255, 255), BF
    '_PutImage (7, 467)-(812, 592), DialogImage, 0
    _PutImage (7, 467)-(7 + _Width(DialogImage), 467 + _Height(DialogImage)), DialogImage, 0
    _MapTriangle (0, 0)-(0, 0)-(32, 128), Img_ChatPointer To(Dialog.arrowx - Dialog.arrowsize, Dialog.arrowy)-(Dialog.arrowx + Dialog.arrowsize, Dialog.arrowy)-(Dialog.arrowx - Ray.xvector * 50, Dialog.arrowy - Ray.yvector * 50)
End If

Return



'Including stuff
'$Include:'externalfuncs/begs platformer/alaska.bi''
'$Include:'externalfuncs/begs platformer/rendering.bi''
'$Include:'externalfuncs/begs platformer/controlstuff.bi''
'$Include:'externalfuncs/begs platformer/physics.bi''
PlayerHoldingItem:

Return


ItemStuff:
For y = 1 To ItemsMax
    If Item(y).referencedtotype = 0 Then
        Item(y).ym = Item(y).ym + Item(y).gravity
        Item(y).yb = Item(y).y
        Item(y).xb = Item(y).x
        Item(y).x = Item(y).x + (Item(y).xm / 10)
        Item(y).y = Item(y).y + (Item(y).ym / 10)
        If Item(y).xm < 0 And Item(y).touchingy2 <> 0 Then Item(y).xm = Item(y).xm + 1
        If Item(y).xm > 0 And Item(y).touchingy2 <> 0 Then Item(y).xm = Item(y).xm - 1
        If Item(y).touchingy1 > 0 Then Item(y).touchingy1 = Item(y).touchingy1 - 1
        If Item(y).touchingy2 > 0 Then Item(y).touchingy2 = Item(y).touchingy2 - 1
        If Item(y).touchingx1 > 0 Then Item(y).touchingx1 = Item(y).touchingx1 - 1
        If Item(y).touchingx2 > 0 Then Item(y).touchingx2 = Item(y).touchingx2 - 1
    End If

    If Item(y).referencedtotype = 1 Then
        Item(y).x = Player(Item(y).referencedtoid).x
        Item(y).y = Player(Item(y).referencedtoid).y
        Item(y).xm = 0
        Item(y).ym = 0
        Part(1).x = Item(y).x
        Part(1).y = Item(y).y
        Part(1).age = 16

        Player(Item(y).referencedtoid).referencedtotype = 2
        Player(Item(y).referencedtoid).referencedtoid = y

        Print "Item("; y; "): Im referenced!"
        'If Item(y).referencedtoid = 1 Then

        If Item(y).referencedtoid = 1 Then pbp = 0
        If Item(y).referencedtoid = 2 Then pbp = 6

        For k = 0 To 1
            VectorX = 0
            VectorY = 0
            Angle2Vector PlayerBody(pbp + 4 + k).rotation, VectorX, VectorY
            Item(y).x = Player(Item(y).referencedtoid).x1 + Player(Item(y).referencedtoid).xm / 10 + (PlayerBody(pbp + 4 + k).xrelative - VectorX * 58)
            Item(y).y = Player(Item(y).referencedtoid).y1 + Player(Item(y).referencedtoid).ym / 10 + (PlayerBody(pbp + 4 + k).yrelative - VectorY * 58)

        Next
    End If
    'End If
    Item(y).x1 = Item(y).x - Item(y).sizex
    Item(y).x2 = Item(y).x + Item(y).sizex
    Item(y).y1 = Item(y).y - Item(y).sizey
    Item(y).y2 = Item(y).y + Item(y).sizey

    a = CheckInBetweenEnts(Item(y), y, 2)

    'Print "Item("; y; ").ym: "; Item(y).ym
    'Print "Item("; y; ").xm: "; Item(y).xm


    'rendering

Next
Return

EntitiesPhyis:
For e = 1 To EntitiesID

    Entity(e).ym = Entity(e).ym + GravityDEF
    Entity(e).yb = Entity(e).y
    Entity(e).xb = Entity(e).x
    Entity(e).x = Entity(e).x + (Entity(e).xm / 10)
    Entity(e).y = Entity(e).y + (Entity(e).ym / 10)
    If Entity(e).touchingy1 > 0 Then Entity(e).touchingy1 = Entity(e).touchingy1 - 1
    If Entity(e).touchingy2 > 0 Then Entity(e).touchingy2 = Entity(e).touchingy2 - 1
    If Entity(e).touchingx1 > 0 Then Entity(e).touchingx1 = Entity(e).touchingx1 - 1
    If Entity(e).touchingx2 > 0 Then Entity(e).touchingx2 = Entity(e).touchingx2 - 1
    a = CheckInBetweenEnts(Entity(e), e, 1)

    If Entity(e).crouchchange > 0 Then
        Entity(e).crouchchange = Entity(e).crouchchange - 1
    End If

    If Entity(e).crouchchange < 0 Then Entity(e).crouchchange = Entity(e).crouchchange + 1
    If Entity(e).crouchchange > 0 And Entity(e).touchingy1 = 0 Then Entity(e).crouchchange = Entity(e).crouchchange - 1


    GoSub EntityAI
Next
Return

EntityAI:
If Entity(e).aitype = 0 Then
    If Entity(e).touchingx1 = 1 Then Entity(e).xm = -20
    If Entity(e).touchingx2 = 1 Then Entity(e).xm = 20
End If
Return




CheckInBetweenEnt:
RayReach = 0
dx = 0
dy = 0
dx = Entity(e).x - Entity(e).xb: dy = Entity(e).y - Entity(e).yb
Ray.x = Entity(e).xb
Ray.y = Entity(e).yb
Ray.angle = ATan2(dy, dx) ' Angle in radians
Ray.angle = (Ray.angle * 180 / PI) + 90
If Ray.angle > 180 Then Ray.angle = Ray.angle - 180
Ray.xvector = Sin(Ray.angle * PIDIV180)
Ray.yvector = -Cos(Ray.angle * PIDIV180)
Do
    If Ray.x + 1 >= Entity(e).x - 1 Then If Ray.x - 1 <= Entity(e).x + 1 Then If Ray.y + 1 >= Entity(e).y - 1 Then If Ray.y - 1 <= Entity(e).y + 1 Then RayReach = 1
    RayCounts = RayCounts + 1
    Ray.x = Ray.x - Ray.xvector
    Ray.y = Ray.y - Ray.yvector
    Entity(e).x1 = Entity(e).x - (Entity(e).sizex + Entity(e).crouchchange / 2)
    Entity(e).x2 = Entity(e).x + (Entity(e).sizex + Entity(e).crouchchange / 2)
    Entity(e).y1 = Entity(e).y - (Entity(e).sizey - Entity(e).crouchchange)
    Entity(e).y2 = Entity(e).y + Entity(e).sizey

    For e2 = 1 To EntitiesID
        If e <> e2 Then
            If EntsCollide(Entity(e), Entity(e2)) Then
                If EntCollide(Entity(e), Entity(e2)) Then
                End If
            End If
        End If
    Next

    For i = 1 To MapBlocksMax
        If MapsCollide(Entity(e), MapBlocks(i)) Then
            If MapBlocks(i).collide = 1 Then
                If MapCollide(Entity(e), MapBlocks(i)) Then
                End If
            End If
        End If
    Next


    If RayCounts > 50 Then RayReach = 1
    If RayReach = 1 Then
        Entity(e).x1 = Entity(e).x - (Entity(e).sizex + Entity(e).crouchchange / 2)
        Entity(e).x2 = Entity(e).x + (Entity(e).sizex + Entity(e).crouchchange / 2)
        Entity(e).y1 = Entity(e).y - (Entity(e).sizey - Entity(e).crouchchange)
        Entity(e).y2 = Entity(e).y + Entity(e).sizey
    End If
Loop While RayReach = 0
Return





Entitiesxyz:
For e = 1 To EntitiesID
    Entity(e).x1 = Entity(e).x - (Entity(e).sizex + Entity(e).crouchchange / 2)
    Entity(e).x2 = Entity(e).x + (Entity(e).sizex + Entity(e).crouchchange / 2)
    Entity(e).y1 = Entity(e).y - (Entity(e).sizey - Entity(e).crouchchange)
    Entity(e).y2 = Entity(e).y + Entity(e).sizey
Next
Return








BegsAnimations:
'Player(p).animstate = 1
o = 1
For i = 2 To 5
    o = -o

    'PlayerBody(pbp + i).animtype = 0
    If PlayerBody(pbp + i).animtype = 0 Then
        trash = WaveMember(pbp + i, o, p)
    End If

Next
Return
'PlayerBody Parts:
'2, 3 - legs
'4, 5 - arms

RenderingBegs:
For p = 1 To 2
    If p = 1 Then pbp = 0
    If p = 2 Then pbp = 6
    If p = 1 Then
        If Player(p).animstate = 2 Then
            PlayerBody(pbp + 4).animtype = 2
            PlayerBody(pbp + 5).animtype = 2
        End If
        If Player(p).animstate = 1 Then
            PlayerBody(pbp + 4).animtype = 0
            PlayerBody(pbp + 5).animtype = 0
        End If
    End If




    PlayerBody(pbp + 1).rotation = Player(p).crouchchange * 1.4
    If Player(p).crouchchange > 65 Then
        PlayerBody(pbp + 2).rotation = PlayerBody(pbp + 2).rotation - Player(p).crouchchange * 2
        PlayerBody(pbp + 3).rotation = PlayerBody(pbp + 3).rotation + Player(p).crouchchange * 2
        PlayerBody(pbp + 4).rotation = PlayerBody(pbp + 4).rotation - Player(p).crouchchange * 2
        PlayerBody(pbp + 5).rotation = PlayerBody(pbp + 5).rotation + Player(p).crouchchange * 2
    End If

    PlayerBody(pbp + 1).xrelative = PlayerBody(pbp + 1).xrelativestatic + Player(p).crouchchange / 1.8
    PlayerBody(pbp + 1).yrelative = PlayerBody(pbp + 1).yrelativestatic - Player(p).crouchchange / 6
    If Player(1).health < 0 Then
        Player(1).crouchchange = 90
        PlayerBody(pbp + 1).yrelative = 45
        PlayerBody(pbp + 1).xrelative = PlayerBody(pbp + 1).xrelativestatic + Player(1).sizex * 2
        For j = 1 To 5
            PlayerBody(pbp + j).rotation = 90
        Next
    End If
    For i = 2 To 6
        If PlayerBody(pbp + i).rotation > 180 Then PlayerBody(pbp + i).rotation = PlayerBody(pbp + i).rotation - 180
        VectorX = 0
        VectorY = 0
        Angle2Vector PlayerBody(pbp + 1).rotation, VectorX, VectorY
        If i = 2 Or i = 3 Then
            PlayerBody(pbp + i).xrelative = PlayerBody(pbp + 1).xrelative + VectorX * -52
            PlayerBody(pbp + i).yrelative = PlayerBody(pbp + 1).yrelative + VectorY * -52
        End If
        If i = 4 Or i = 5 Then
            PlayerBody(pbp + i).xrelative = PlayerBody(pbp + 1).xrelative + VectorX * 2
            PlayerBody(pbp + i).yrelative = PlayerBody(pbp + 1).yrelative + VectorY * 2
        End If
        If i = 6 Then
            PlayerBody(pbp + i).xrelative = PlayerBody(pbp + 1).xrelative + VectorX * 8
            PlayerBody(pbp + i).yrelative = PlayerBody(pbp + 1).yrelative + VectorY * 8
        End If
    Next


    If p = 1 And Player(1).health > -1 Then GoSub BegsHead


    If PlayerBody(pbp + 4).animtype = 2 Then
        PlayerBody(pbp + 4).rotation = PlayerBody(pbp + 6).rotation - 180
    End If
    If PlayerBody(pbp + 5).animtype = 2 Then
        PlayerBody(pbp + 5).rotation = PlayerBody(pbp + 6).rotation - 170
    End If



    For i = 1 To 6
        If i = 2 Or i = 3 Then
            RotoZoom PlayerBody(pbp + i).xrelative + Player(p).x1, PlayerBody(pbp + i).yrelative + Player(p).y1, BegsImg_BodyMember, 1, PlayerBody(pbp + i).rotation
        End If
        If i = 1 Or i = 4 Or i = 5 Then
            RotoZoom PlayerBody(pbp + i).xrelative + Player(p).x1, PlayerBody(pbp + i).yrelative + Player(p).y1, BegsImg_BodyMember, 1, PlayerBody(pbp + i).rotation
        End If
        If i = 6 Then
            If PlayerBody(pbp + 6).rotation < 0 And PlayerBody(pbp + 6).rotation > -180 Then
                RotoZoom PlayerBody(pbp + i).xrelative + Player(p).x1, PlayerBody(pbp + i).yrelative + Player(p).y1, BegsImg_Head2, 1, PlayerBody(pbp + i).rotation + 90
                If joinorhost = 1 And p = 1 Then RotoZoom PlayerBody(pbp + i).xrelative + Player(p).x1, PlayerBody(pbp + i).yrelative + Player(p).y1, BegsImg_Crown2, 1, PlayerBody(pbp + i).rotation + 90
                If joinorhost = 2 And p = 2 Then RotoZoom PlayerBody(pbp + i).xrelative + Player(p).x1, PlayerBody(pbp + i).yrelative + Player(p).y1, BegsImg_Crown2, 1, PlayerBody(pbp + i).rotation + 90
            Else
                RotoZoom PlayerBody(pbp + i).xrelative + Player(p).x1, PlayerBody(pbp + i).yrelative + Player(p).y1, BegsImg_Head1, 1, PlayerBody(pbp + i).rotation - 90
                If joinorhost = 1 And p = 1 Then RotoZoom PlayerBody(pbp + i).xrelative + Player(p).x1, PlayerBody(pbp + i).yrelative + Player(p).y1, BegsImg_Crown1, 1, PlayerBody(pbp + i).rotation - 90
                If joinorhost = 2 And p = 2 Then RotoZoom PlayerBody(pbp + i).xrelative + Player(p).x1, PlayerBody(pbp + i).yrelative + Player(p).y1, BegsImg_Crown1, 1, PlayerBody(pbp + i).rotation - 90
            End If
        End If

    Next
    If p = 1 Then GoSub BegsAnimations

Next
Return

BegsHead:
dx = Player(1).x - Mousex + CameraX: dy = (Player(1).y - PlayerBody(6).yrelative) - Mousey + CameraY
PlayerBody(6).rotation = ATan2(dy, dx) ' Angle in radians
PlayerBody(6).rotation = (PlayerBody(6).rotation * 180 / PI) + 90
If PlayerBody(6).rotation > 180 Then PlayerBody(6).rotation = PlayerBody(6).rotation - 180
Return




















'Way 0 is reserved for Players
'Way 1 is reserved for entities
'Way 2 is reserved for items
'Way 3 is reserved for breakfast after 11 am






Function CheckInBetweenEnts (Entity As Entity, i As Integer, way As Integer)
    RayReach = 0: dx = 0: dy = 0
    dx = Entity.x - Entity.xb: dy = Entity.y - Entity.yb
    Ray.x = Entity.xb
    Ray.y = Entity.yb
    Ray.angle = ATan2(dy, dx) ' Angle in radians
    Ray.angle = (Ray.angle * 180 / PI) + 90
    If Ray.angle > 180 Then Ray.angle = Ray.angle - 180
    Ray.xvector = Sin(Ray.angle * PIDIV180)
    Ray.yvector = -Cos(Ray.angle * PIDIV180)
    Do
        If Ray.x + 1 >= Entity.x - 1 Then If Ray.x - 1 <= Entity.x + 1 Then If Ray.y + 1 >= Entity.y - 1 Then If Ray.y - 1 <= Entity.y + 1 Then RayReach = 1
        RayCounts = RayCounts + 1
        Ray.x = Ray.x - Ray.xvector
        Ray.y = Ray.y - Ray.yvector
        If way = 1 Then 'Adjust X1,X2,Y1,Y2
            If Entity.hard = 0 Then
                Entity.x1 = Entity.x - (Entity.sizex + Entity.crouchchange / 2): Entity.x2 = Entity.x + (Entity.sizex + Entity.crouchchange / 2): Entity.y1 = Entity.y - (Entity.sizey - Entity.crouchchange): Entity.y2 = Entity.y + Entity.sizey
            End If
        End If

        For e2 = 1 To EntitiesID
            If way = 1 Then If i <> e2 Then
                    If EntsCollide(Entity, Entity(e2)) Then
                        If EntCollide(Entity, Entity(e2)) Then
                        End If
                    End If
            End If: End If
        Next

        For i2 = 1 To BlockID
            If MapsCollide(Entity, MapBlocks(i2)) Then
                If MapBlocks(i2).collide = 1 Then
                    If MapCollide(Entity, MapBlocks(i2)) Then
                    End If
                End If
            End If
        Next


        If RayCounts > 20 Then RayReach = 1
        If RayReach = 1 Then
            If way = 1 Then 'Adjust X1,X2,Y1,Y2
                Entity.x1 = Entity.x - (Entity.sizex + Entity.crouchchange / 2): Entity.x2 = Entity.x + (Entity.sizex + Entity.crouchchange / 2): Entity.y1 = Entity.y - (Entity.sizey - Entity.crouchchange): Entity.y2 = Entity.y + Entity.sizey
            End If
        End If
    Loop While RayReach = 0

End Function


Function EntityHurtKnockBack (Entity As Entity, hurtsourcex As Long, hurtsourcey As Long, force As Double, damage As Double)
    dx = Entity.x - hurtsourcex: dy = Entity.y - hurtsourcey
    Ray.x = hurtsourcex
    Ray.y = hurtsourcey
    Ray.angle = ATan2(dy, dx) ' Angle in radians
    Ray.angle = (Ray.angle * 180 / PI) + 90
    If Ray.angle > 180 Then Ray.angle = Ray.angle - 180
    Ray.xvector = Sin(Ray.angle * PIDIV180)
    Ray.yvector = -Cos(Ray.angle * PIDIV180)
    Entity.xm = Entity.xm - Ray.xvector * force
    Entity.ym = Entity.ym - Ray.yvector * force
    Entity.y = Entity.y - 5
    df = Entity.health - damage
    If Entity.health > -1 Then _SndPlay BegsAud_Hurt
    If Entity.health > -1 And df < -1 Then _SndPlay BegsAud_Death
    If Entity.invulnerability = 0 Then Entity.health = Entity.health - damage: Entity.invulnerability = 15
End Function


Function MapCollide (Entity As Entity, Map As MAP)
    MapCollide = 0
    If Entity.y2 >= Map.y1 And Entity.x2 >= Map.x1 And Entity.x1 <= Map.x2 And Entity.y1 + (Entity.sizex * 2 - 5) <= Map.y2 Then 'Collide step
        df = Entity.y + Entity.sizey - Map.y1

        If df >= 10 And df <= 45 Then
            Entity.yb = Entity.y
            Entity.y = Map.y1 - 10 - Entity.sizey
            If Entity.xm > 0 Then Entity.x = Entity.x + 1
            If Entity.xm < 0 Then Entity.x = Entity.x - 1
            Entity.touchingy2 = 6
            Entity.ym = -500
        End If
        If Entity.types = 1 Then
            Entity.x1 = Entity.x - Entity.sizex: Entity.x2 = Entity.x + Entity.sizex: Entity.y1 = Entity.y - Entity.sizey: Entity.y2 = Entity.y + Entity.sizey
        End If

        If Entity.types <> -1 Then
            If Entity.hard = 0 Then
                Entity.x1 = Entity.x - (Entity.sizex + Entity.crouchchange / 2): Entity.x2 = Entity.x + (Entity.sizex + Entity.crouchchange / 2): Entity.y1 = Entity.y - (Entity.sizey - Entity.crouchchange): Entity.y2 = Entity.y + Entity.sizey
            End If
        End If
    End If


    If Entity.y2 >= Map.y1 And Entity.x2 >= Map.x1 And Entity.x1 <= Map.x2 And Entity.y1 + (Entity.sizex * 2) <= Map.y2 Then 'Collide Down
        If Entity.types = -1 Then If Entity.ym > 150 Then CameraYOffSetSpeed = CameraYOffSetSpeed + Int(Entity.ym / 14): CameraIsOffSet = 1
        df = Entity.y + Entity.sizey - Map.y1
        If Entity.ym > 80 Then Entity.crouchchange = Entity.crouchchange + Entity.ym / 4
        If df <= 20 Then Entity.y = Map.y1 - Entity.sizey
        'Entity.y = Map.y1 - Entity.sizey
        Entity.touchingy2 = 5
        If Map.state = 3 Then
            Entity.ym = (Entity.ym * -1.2): Entity.y = Entity.y - 5
            Entity.jump = 1
        End If
        If Map.state <> 3 Then Entity.ym = 1
    End If


    If Entity.x2 >= Map.x1 And Entity.x1 + (Entity.sizex * 2 + Entity.crouchchange / 2) + 1 <= Map.x2 And Entity.y2 - 5 >= Map.y1 And Entity.y1 + 5 <= Map.y2 Then 'Collide Right
        If Entity.types = -1 Then If Entity.touchingy2 <> 6 Then If Entity.xm > 50 Then CameraXOffSetSpeed = CameraXOffSetSpeed + Int(Entity.xm / 14): CameraIsOffSet = 1
        If Entity.touchingy2 <> 6 Then Entity.xm = -5
        Entity.touchingx1 = 5

        If Entity.touchingy1 = 0 Then Entity.crouchchange = Entity.crouchchange - 3
    End If

    If Entity.x1 - 1 <= Map.x2 And Entity.x2 - (Entity.sizex * 2 - Entity.crouchchange / 2) - 1 >= Map.x1 And Entity.y2 - 5 >= Map.y1 And Entity.y1 + 5 <= Map.y2 Then 'Collide Left
        If Entity.types = -1 Then If Entity.touchingy2 <> 6 Then If Entity.xm < -50 Then CameraXOffSetSpeed = CameraXOffSetSpeed + Int(Entity.xm / 14): CameraIsOffSet = 1
        If Entity.touchingy2 <> 6 Then Entity.xm = 5
        Entity.touchingx2 = 5

        If Entity.touchingy1 = 0 Then Entity.crouchchange = Entity.crouchchange - 3
    End If

    If Entity.y1 <= Map.y2 And Entity.x2 - 5 >= Map.x1 And Entity.x1 + 5 <= Map.x2 And Entity.y2 - (Entity.sizex * 2 - Entity.crouchchange + 5) >= Map.y1 Then 'Collide Up
        Entity.ym = 10 + Map.speedmovey * 20
        df = Entity.y1 - Map.y2
        If Not df < 0 Then Entity.y = (Map.y2 + Entity.sizey - Entity.crouchchange)
        Entity.touchingy1 = 10
        If _KeyDown(100306) And Entity.crouchchange < 20 Then Entity.crouchchange = Entity.crouchchange + 1: Entity.ym = Entity.ym - 10
        If Map.speedmovey > 0 And Entity.touchingy2 > 0 Then Entity.crouchchange = Entity.crouchchange + Map.speedmovey * 4
    End If

    If Map.state = 5 Then 'Moving
        Entity.x = Entity.x + Map.speedmovex
        If Entity.touchingy1 = 0 Then
            Entity.y = Entity.y + Map.speedmovey
        End If
    End If
    MapCollide = -1
End Function


Function EntCollide (Entity As Entity, Entity2 As Entity)
    EntCollide = 0
    If Entity.y2 >= Entity2.y1 And Entity.x2 >= Entity2.x1 And Entity.x1 <= Entity2.x2 And Entity.y1 + (Entity.sizex * 2 - 5) <= Entity2.y2 Then 'Collide step
        df = Entity.y + Entity.sizey - Entity2.y1

        If df >= 10 And df <= 45 Then
            Entity.yb = Entity.y
            Entity.y = Entity2.y1 - 5 - Entity.sizey
            If Entity.xm > 0 Then Entity.x = Entity.x + 1
            If Entity.xm < 0 Then Entity.x = Entity.x - 1
            Entity.touchingy2 = 6
            Entity.y2 = Entity2.y1 - 1
        End If

    End If

    If Entity.y2 >= Entity2.y1 And Entity.x2 >= Entity2.x1 And Entity.x1 <= Entity2.x2 And Entity.y1 + (Entity.sizex * 2) <= Entity2.y2 Then 'Collide Down
        If Entity.ym > 150 Then CameraYOffSetSpeed = CameraYOffSetSpeed + Int(Entity.ym / 14): CameraIsOffSet = 1
        df = Entity.y + Entity.sizey - Entity2.y1
        If Entity.ym > 80 Then Entity.crouchchange = Entity.crouchchange + Entity.ym / 4
        If df <= 20 Then Entity.y = Entity2.y1 - Entity.sizey
        If Entity.crouchchange = 62 Then
            Entity2.y1 = Entity.y1

        End If
        Entity.touchingy2 = 5
        Entity.ym = 1
    End If

    If Entity.x2 >= Entity2.x1 And Entity.x1 + (Entity.sizex * 2 + Entity.crouchchange / 2) + 1 <= Entity2.x2 And Entity.y2 - 5 >= Entity2.y1 And Entity.y1 + 5 <= Entity2.y2 Then 'Collide Right
        If Entity.touchingy2 <> 6 Then If Entity.xm > 50 Then CameraXOffSetSpeed = CameraXOffSetSpeed + Int(Entity.xm / 14): CameraIsOffSet = 1
        If Entity.touchingy2 <> 6 Then Entity.xm = -5
        Entity.touchingx1 = 5
        If Entity.touchingy1 = 0 Then Entity.crouchchange = Entity.crouchchange - 3
    End If

    If Entity.x1 - 1 <= Entity2.x2 And Entity.x2 - (Entity.sizex * 2 - Entity.crouchchange / 2) - 1 >= Entity2.x1 And Entity.y2 - 5 >= Entity2.y1 And Entity.y1 + 5 <= Entity2.y2 Then 'Collide Left
        If Entity.touchingy2 <> 6 Then If Entity.xm < -50 Then CameraXOffSetSpeed = CameraXOffSetSpeed + Int(Entity.xm / 14): CameraIsOffSet = 1
        If Entity.touchingy2 <> 6 Then Entity.xm = 5
        Entity.touchingx2 = 5


        If Entity.touchingy1 = 0 Then Entity.crouchchange = Entity.crouchchange - 3
    End If



    If Entity.y1 <= Entity2.y2 And Entity.x2 - 5 >= Entity2.x1 And Entity.x1 + 5 <= Entity2.x2 And Entity.y2 - (Entity.sizex * 2 - Entity.crouchchange + 5) >= Entity2.y1 Then 'Collide Up

        df = Entity.y1 - Entity2.y2
        If Not df < 0 Then Entity.y = (Entity2.y2 + Entity.sizey - Entity.crouchchange)
        Entity.touchingy1 = 10
        If _KeyDown(100306) And Entity.crouchchange < 20 Then Entity.crouchchange = Entity.crouchchange + 1: Entity.ym = Entity.ym - 10
    End If

    EntCollide = -1
End Function





Function WaveMember (i As Integer, modifier As Integer, p As Integer)
    PlayerBody(i).state = PlayerBody(i).state + Player(p).xm / 400
    If PlayerBody(i).state > 1 Then PlayerBody(i).state = -1: PlayerBody(i).state2 = 0
    If PlayerBody(i).state < -1 Then PlayerBody(i).state = 1: PlayerBody(i).state2 = 0

    If Player(p).xm = 0 And PlayerBody(i).state > 0 Then PlayerBody(i).state = PlayerBody(i).state - .1
    If Player(p).xm = 0 And PlayerBody(i).state < 0 Then PlayerBody(i).state = PlayerBody(i).state + .1
    If Player(p).xm = 0 And PlayerBody(i).state > -0.15 And PlayerBody(i).state < 0.15 And PlayerBody(i).state2 = 0 Then PlayerBody(i).state = 0: PlayerBody(i).state2 = (Int(Rnd * 100) / 1000)
    PlayerBody(i).rotation = (Sin(PlayerBody(i).state + PlayerBody(i).state2) * 67) * modifier
    WaveMember = -1
End Function


Sub LoadMap
    If Not _FileExists(MAP$) Then
        _MessageBox "File not found", (MapNameCreate$ + ".bhmap doesnt exist!"), "error"
        errors = 1
        MapNameCreate$ = ""
    End If
    If errors = 0 Then
        Open MAP$ For Input As #1
        Input #1, trash
        Input #1, trash
        Input #1, trash
        Input #1, BlockID
        Input #1, EntitiesID
        'Input #1, ItemsID
        Input #1, TriggerID
        For i = 1 To BlockID
            Input #1, trash$
            Input #1, MapBlocks(i).x1
            Input #1, MapBlocks(i).y1
            Input #1, MapBlocks(i).x2
            Input #1, MapBlocks(i).y2
            Input #1, MapBlocks(i).x
            Input #1, MapBlocks(i).y
            Input #1, MapBlocks(i).xm
            Input #1, MapBlocks(i).ym
            Input #1, MapBlocks(i).frame
            Input #1, MapBlocks(i).state
            Input #1, MapBlocks(i).texture
            Input #1, MapBlocks(i).collide
            Input #1, MapBlocks(i).physics
            Input #1, MapBlocks(i).weight
            Input #1, MapBlocks(i).colorR
            Input #1, MapBlocks(i).colorG
            Input #1, MapBlocks(i).colorB
            Input #1, MapBlocks(i).colorA
            Input #1, MapBlocks(i).xmove
            Input #1, MapBlocks(i).ymove
            Input #1, MapBlocks(i).speedmovex
            Input #1, MapBlocks(i).speedmovey
            'Input #1, MapBlocks(i).texturestyle
        Next
        If EntitiesID > 0 Then
            For e = 1 To EntitiesID
                Input #1, trash$
                Input #1, Entity(e).x
                Input #1, Entity(e).sizex
                Input #1, Entity(e).sizey
                Input #1, Entity(e).y
                Input #1, Entity(e).xm: Entity(e).xm = 10
                Input #1, Entity(e).ym
                Input #1, Entity(e).types
                Input #1, a ' Entity(i).weight
                Input #1, a ' Entity(i).wallgobackAI
                Input #1, a ' Entity(i).groundgobackAI
                Input #1, a ' Entity(i).jumpAI
                Input #1, Entity(e).health
                Input #1, a ' Entity(i).state
                Input #1, a ' Entity(i).animframe
                Input #1, Entity(e).crouchchange
                If Entity(e).types = -1 Then
                    Player(1).x = Entity(e).x
                    Player(1).y = Entity(e).y
                End If
            Next
        End If

        For i = 1 To TriggerID
            If Trigger(i).types <> 0.1 Then
                Input #1, trash$
                Input #1, Trigger(i).x1
                Input #1, Trigger(i).y1
                Input #1, Trigger(i).x2
                Input #1, Trigger(i).y2
                Input #1, Trigger(i).x
                Input #1, Trigger(i).y
                Input #1, Trigger(i).types
                Input #1, Trigger(i).outputtoid
                Input #1, Trigger(i).inputfromid
                Input #1, Trigger(i).text
                Input #1, Trigger(i).setdelaypl
            End If
        Next

        Close #1
    End If
End Sub

'$Include:'externalfuncs/begs platformer/funcs.bm''



