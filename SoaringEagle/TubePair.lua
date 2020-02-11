--Represents a oair of tubes that stick together as they scroll, providing an opening 
--for the player to flap through in order to score a point.
TubePair = Class{}

local Space_Height = 90

function TubePair:init(y)
--Flag to hold whether this pair had been tallied
    self.tallied = false
--Initalize tubes past the end of the screen
    self.x = Super_Width + 32
--y value is for the top-most tube; spacing is vertical shift of the second lower tube.
    self.y = y
--Instantiate two tubes that belong to this pair
    self.tubes = {
        ['upper'] = Tube('top', self.y),
        ['lower'] = Tube('bottom', self.y + Tube_Height + Space_Height)
    }
--Whether this tube pair is ready to be removed from the scene.
    self.remove = false

end

function TubePair:update(dt)
--Remove the tube from the scene if it's beyond the left edge of the screen,
--else move it from right to left
    if self.x > -Tube_Width then
        self.x = self.x - Tube_Speed * dt
        self.tubes['lower'].x = self.x
        self.tubes['upper'].x = self.x
    else
        self.remove = true
    end
end

function TubePair:render()
    for t, tube in pairs(self.tubes) do
        tube:render()
    end
end