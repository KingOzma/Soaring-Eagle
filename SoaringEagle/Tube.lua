--Represents the tubes that randomly spawn. The tubes can stick out a random distance from top or bottom.
--When the player hits one of the tubes, the game is over. 
--The bird doesn't move through the screen, but the tubes themselves scroll through the game to give the illusion.
Tube = Class{}

local Tube_Image = love.graphics.newImage('tube.png')

function Tube:init(orientation, y)
    self.x = Super_Width + 64
    self.y = y

    self.width = Tube_Width
    self.height = Tube_Height

    self.orientation = orientation
end

function Tube:update(dt)
    
end

function Tube:render()
    love.graphics.draw(Tube_Image, self.x, 
    (self.orientation == 'top' and self.y + Tube_Height or self.y),
    0, 1, self.orientation == 'top' and -1 or 1)
end