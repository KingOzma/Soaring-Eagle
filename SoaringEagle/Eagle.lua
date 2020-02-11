Eagle = Class{}

local Pressure = 20

function Eagle:init()
    -- load eagle image from disk and assign its width and height
    self.image = love.graphics.newImage('eagle.png')
    self.x = Super_Width / 2 - 8
    self.y = Super_Height / 2 - 8

    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.dy = 0
end

--AABB collision that expects a tube, which will have an X and Y and reference global tube width and height values.
function Eagle:collides(tube)
--The 2's are left and top offsets.
--The 4's are right and bottom offsets.
--Both the offsets are used to shrink the bounding box to give the player a little bit of leeway with the collision.
    if (self.x + 2) + (self.width - 4) >= tube.x and self.x + 2 <= tube.x + Tube_Width then
        if (self.y + 2) + (self.height - 4) >= tube.y and self.y + 2 <= tube.y + Tube_Height then
            return true
        end
    end

    return false
end

function Eagle:update(dt)
    self.dy = self.dy + Pressure * dt

    if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
        self.dy = -5
        sounds['flap']:play()
    end

    self.y = self.y + self.dy
end

function Eagle:render()
    love.graphics.draw(self.image, self.x, self.y)
end