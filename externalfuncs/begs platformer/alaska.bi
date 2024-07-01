'This file will store small gosubs that will rarely need to be edited.


Online:
playerput(1) = Player(1).x
playerput(2) = Player(1).y
playerput(3) = Player(1).xm
playerput(4) = Player(1).ym
playerput(5) = Player(1).jump
playerput(6) = Player(1).crouchchange
playerput(7) = Player(1).sizex
playerput(8) = Player(1).sizey
playerput(9) = Player(1).xm
playerput(10) = Player(1).ym
playerput(11) = PlayerBody(1).rotation
playerput(12) = PlayerBody(2).rotation
playerput(13) = PlayerBody(3).rotation
playerput(14) = PlayerBody(4).rotation
playerput(15) = PlayerBody(5).rotation
playerput(16) = PlayerBody(6).rotation
playerput(17) = Player(1).referencedtotype
playerput(18) = Player(1).referencedtoid
playerput(19) = Player(1).interaction
Put connection&, 5, playerput()
For i = 1 To 2
    Get connection&, 5, playerget()
Next
Player(2).x = playerget(1)
Player(2).y = playerget(2)
Player(2).xm = playerget(3)
Player(2).ym = playerget(4)
Player(2).jump = playerget(5)
Player(2).crouchchange = playerget(6)
Player(2).sizex = playerget(7)
Player(2).sizey = playerget(8)
Player(2).xm = playerget(9)
Player(2).ym = playerget(10)
PlayerBody(7).rotation = playerget(11) 
PlayerBody(8).rotation = playerget(12)  
PlayerBody(9).rotation = playerget(13)  
PlayerBody(10).rotation = playerget(14)  
PlayerBody(11).rotation = playerget(15)  
PlayerBody(12).rotation = playerget(16)  
Player(2).referencedtotype = playerget(17)
Player(2).referencedtoid = playerget(18)
if Player(2).referencedtotype = 2 then
Item(Player(2).referencedtoid).referencedtoid = 2 
Item(Player(2).referencedtoid).referencedtotype = 1
end if
Player(2).interaction = playerget(19)


Playerxys:
For i = 1 To PlayerMax
    Player(i).x1 = Player(i).x - (Player(i).sizex + Player(i).crouchchange / 4)
    Player(i).x2 = Player(i).x + (Player(i).sizex + Player(i).crouchchange / 4)
    Player(i).y1 = Player(i).y - (Player(i).sizey - Player(i).crouchchange)
    Player(i).y2 = Player(i).y + Player(i).sizey
Next
Return

MapBlockPhysics:
For i = 1 To MapBlocksMax
    If MapBlocks(i).state = 5 Then
    End If
Next
Return





'RENDERING BEGS AND BEGS HEAD WAS HERE!
