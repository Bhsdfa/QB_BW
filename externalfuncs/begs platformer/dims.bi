
Dim Shared CameraY As Long
Dim Shared CameraX As Long
Dim Shared CameraXOffSet As Double
Dim Shared CameraYOffSet As Double
Dim Shared CameraXOffSetSpeed As Double
Dim Shared CameraYOffSetSpeed As Double
Dim Shared CameraIsOffSet As Integer
Dim Shared ScreenToMove
Dim Shared MapBlocksMax
Dim Shared PlayerMax
Dim Shared EntityMax
Dim Shared Delay
Dim Shared GravityDEF
Dim Shared BlockID
Dim Shared ItemsMax
Dim Shared EntitiesID
Dim Shared ItemsID
Dim Shared Joy As Control
Dim Shared Ray As Ray
Dim Shared MapNameCreate$
Dim playerput(32)
Dim playerget(32)
Dim Mapsender(21)
Dim Mapreceiver(21)
Dim Shared joinorhost

Const PI = 3.1415926
Const PIDIV180 = PI / 180
Const PlayersMax = 2
connectiondelays = 15
ScreenToMove = 200
MapBlocksMax = 800
PlayerMax = 2
EntityMax = 100
ItemsMax = 20
GravityDEF = 5


Dim Shared MapBlocks(MapBlocksMax) As MAP
Dim Shared Player(PlayerMax) As Entity
Dim Shared Entity(EntityMax) As Entity
Dim Shared Item(ItemsMax) As Entity
Dim Shared PlayerBody(12) As PlayerMembers


PlayerBody(1).xrelativestatic = 30: PlayerBody(1).yrelativestatic = 46: PlayerBody(1).size = 1: PlayerBody(1).rotation = 0
PlayerBody(7).xrelativestatic = 30: PlayerBody(7).yrelativestatic = 46: PlayerBody(7).size = 1: PlayerBody(7).rotation = 0
For i = 1 To PlayerMax
    Player(i).sizex = 32
    Player(i).sizey = 70
    Player(i).crouchchange = 0
    Player(i).xs = _Width / 2
    Player(i).ys = _Height / 2
Next
For i = 2 To 5
    PlayerBody(i).state = 0
Next

