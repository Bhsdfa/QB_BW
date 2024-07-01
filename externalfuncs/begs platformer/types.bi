Type MAP
    x1 As Long
    x2 As Long
    y1 As Long
    y2 As Long
    x As Long
    y As Long
    xb As Long
    yb As Long
    xm As Integer
    ym As Integer
    touchy As Integer
    touchx As Integer
    frame As Integer
    state As Integer
    friction As Integer
    texture As Integer
    collide As Integer
    physics As Integer
    weight As Integer
    colorR As Integer
    colorG As Integer
    colorB As Integer
    colorA As Integer
    xmove As Integer
    ymove As Integer
    speedmovex As Integer
    speedmovey As Integer
    xmovetrash As Integer
    ymovetrash As Integer
End Type

Type PlayerMembers
    id As Integer
    xrelative As Long
    yrelative As Long
    xrelativestatic As Long
    yrelativestatic As Long
    vectoroffset As Integer
    rotation As Single
    rotation2 As Single
    render As Integer
    state As Double
    state2 As Double
    size As Integer
    animtype As Integer
End Type

Type Control
    JUMP As Integer
    CROUCH As Integer
    USE As Integer
    THROW As Integer
    L As Integer
    R As Integer
    BT As Integer
    START As Integer
    SELECTJOY As Integer
    HORIZONTAL As Double
    VERTICAL As Integer
    HORIZONTAL2 As Integer
    VERTICAL2 As Integer
End Type

Type Entity
    types As Integer
    x As Double
    y As Double
    xs As Double
    ys As Double
    sizex As Double
    sizey As Double
    xm As Double
    ym As Double
    x1 As Double
    x2 As Double
    y1 As Double
    y2 As Double
    touchingx1 As Integer
    touchingx2 As Integer
    touchingy1 As Integer
    touchingy2 As Integer
    jump As Integer
    jumppower As Double
    health As Integer
    crouchchange As Double
    xb As Long
    yb As Long
    gravity As Double
    animstate As Integer
    aitype As Integer
    invulnerability As Integer
    playecanpickup As Integer
    referencedtoid As Integer
    referencedtotype As Integer
    hard As Integer
    interaction As Integer
End Type

Type Ray
    x As Double
    y As Double
    angle As Double
    xvector As Double
    yvector As Double
End Type

