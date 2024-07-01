'control stuff

KeyboardInput: ' Detect key presses
if Player(1).health > -1 then
Player(1).interaction = 0
If _KeyDown(119) Then Joy.VERTICAL = -1
If _KeyDown(115) Then Joy.VERTICAL = 1
If _KeyDown(97) Then Joy.HORIZONTAL = -1
If _KeyDown(100) Then Joy.HORIZONTAL = 1
If _KeyDown(32) Then Joy.JUMP = 1
If _KeyDown(100306) Then Joy.CROUCH = 1
If _keydown(101) then Player(1).interaction = 1
If _mousebutton(1) = -1 then Player(1).interaction = 2
                             end if
If _KeyDown(9) And Delay = 0 Then Beep: Delay = 15
If _KeyDown(111) And Delay = 0 Then
    RenderBegsModel = RenderBegsModel + 1: Delay = 10: If RenderBegsModel > 1 Then RenderBegsModel = 0
    If RenderBegsModel = 1 Then Sound 40, 1, .5, 0, 1: Sound 250, 1, .5, 0, 1
    If RenderBegsModel = 0 Then Sound 250, 1, .5, 0, 1: Sound 40, 1, .5, 0, 1
End If

If _KeyDown(20992) And Delay = 0 Then GoTo MapLoading: _NotifyPopup "Begs", "Game Restarted!", "info"

If _KeyDown(120) And Delay = 0 Then
    CameraShake = CameraShake + 1: Delay = 10: If CameraShake > 1 Then CameraShake = 0
    If CameraShake = 1 Then Sound 40, 1, .5, 0, 1: Sound 250, 1, .5, 0, 1
    If CameraShake = 0 Then Sound 250, 1, .5, 0, 1: Sound 40, 1, .5, 0, 1
End If

If _KeyDown(118) And Delay = 0 Then
    Noclip = Noclip + 1: Delay = 10: If Noclip > 1 Then Noclip = 0
    If Noclip = 1 Then Sound 40, 1, .5, 0, 1: Sound 250, 1, .5, 0, 1
    If Noclip = 0 Then Sound 250, 1, .5, 0, 1: Sound 40, 1, .5, 0, 1
End If
If _KeyDown(99) And Delay = 0 Then
    FreeCam = FreeCam + 1: Delay = 10: CameraXOffSetSpeed = 0: CameraYOffSetSpeed = 0: If FreeCam > 1 Then FreeCam = 0
    If FreeCam = 1 Then Sound 40, 1, .5, 0, 1: Sound 250, 1, .5, 0, 1
    If FreeCam = 0 Then Sound 250, 1, .5, 0, 1: Sound 40, 1, .5, 0, 1

End If
If _KeyDown(114) And Delay = 0 Then Player(1).x = 256: Player(1).y = 256: Player(1).xm = 0: Player(1).ym = 0: CameraX = -256: CameraY = -256: Delay = 10 : Player(1).health = 100
'FreeCam:
If FreeCam = 1 Then
    If _KeyDown(19200) Then CameraXOffSetSpeed = CameraXOffSetSpeed - 10
    If _KeyDown(19712) Then CameraXOffSetSpeed = CameraXOffSetSpeed + 10
    If _KeyDown(18432) Then CameraYOffSetSpeed = CameraYOffSetSpeed - 10
    If _KeyDown(20480) Then CameraYOffSetSpeed = CameraYOffSetSpeed + 10
    If CameraXOffSetSpeed > 0 Then CameraXOffSetSpeed = CameraXOffSetSpeed - 1
    If CameraXOffSetSpeed < 0 Then CameraXOffSetSpeed = CameraXOffSetSpeed + 1
    If CameraYOffSetSpeed > 0 Then CameraYOffSetSpeed = CameraYOffSetSpeed - 1
    If CameraYOffSetSpeed < 0 Then CameraYOffSetSpeed = CameraYOffSetSpeed + 1
    If CameraXOffSetSpeed > 150 Then CameraXOffSetSpeed = 150
    If CameraXOffSetSpeed < -150 Then CameraXOffSetSpeed = -150
    If CameraYOffSetSpeed > 150 Then CameraYOffSetSpeed = 150
    If CameraYOffSetSpeed < -150 Then CameraYOffSetSpeed = -150
End If

If CameraXOffSet > FreeCamMaxDistance Then CameraXOffSet = FreeCamMaxDistance
If CameraXOffSet < -FreeCamMaxDistance Then CameraXOffSet = -FreeCamMaxDistance
If CameraYOffSet > FreeCamMaxDistance Then CameraYOffSet = FreeCamMaxDistance
If CameraYOffSet < -FreeCamMaxDistance Then CameraYOffSet = -FreeCamMaxDistance

Return







InputToPlayer:
If Joy.JUMP = 1 And Player(1).touchingy2 > 0 And Player(1).touchingy1 = 0 Then If Player(1).crouchchange <= 20 Then Player(1).y = Player(1).y - 15: Player(1).ym = Player(1).jumppower: Player(1).touchingy2 = 0: Player(1).crouchchange = Player(1).crouchchange - 10
If Joy.JUMP = 1 And Player(1).touchingy2 > 0 And Player(1).touchingy1 = 0 Then If Player(1).crouchchange > 20 Then Player(1).y = Player(1).y - 10: Player(1).ym = Player(1).jumppower / 100 * (Player(1).crouchchange / 5): Player(1).touchingy2 = 0: Player(1).crouchchange = Player(1).crouchchange - 20
'If Joy.VERTICAL = -1 Then Player(1).ym = Player(1).ym - 4
If Joy.VERTICAL = 1 Then Player(1).ym = Player(1).ym + 4
If Joy.HORIZONTAL = -1 Then Player(1).xm = Player(1).xm - 4
If Joy.HORIZONTAL = 1 Then Player(1).xm = Player(1).xm + 4
If Joy.CROUCH = 1 And Player(1).touchingy1 = 0 Then
    If Player(1).crouchchange > 60 Then Player(1).crouchchange = 60
    Player(1).crouchchange = Player(1).crouchchange + 2
ElseIf Player(1).crouchchange > 0 Then
    Player(1).crouchchange = Player(1).crouchchange - 1
End If
If Joy.CROUCH = 0 Then
    If Player(1).crouchchange < 0 Then Player(1).crouchchange = Player(1).crouchchange + 1
    If Player(1).crouchchange > 0 And Player(1).touchingy1 = 0 Then Player(1).crouchchange = Player(1).crouchchange - 1
End If

Joy.JUMP = 0
Joy.VERTICAL = 0
Joy.HORIZONTAL = 0
Joy.CROUCH = 0
Return
