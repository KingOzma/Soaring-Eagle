--The PlayState is where the player controls the Eagle and dodges tubes. If the player hits one of the tubes,
-- the game will transtion to GameOver and go back to the main menu.

PlayState = Class{__includes = BaseState}

Tube_Speed = 60
Tube_Width = 70
Tube_Height = 288

Eagle_Width = 34
Eagle_Height = 24

local brink = 2

function PlayState:init()
    self.eagle = Eagle()
    self.tubePairs = {}
    self.timer = 0
    self.tally = 0

--Initializes the last recorded Y value for the space planement between tubes to base other spaces off of.
    self.lastY = -Tube_Height + math.random(80) + 20
end

function PlayState:update(dt)
--updates the time for tube spawning
    self.timer = self.timer + dt

--Spawns a new tube every second and a half
    if self.timer > brink then
        brink = 2 + math.random(-5, 5)/10
--Modifies the last Y coordinate placed, so the tube spacing aren't too far apart.
--Tube spacing can be higher than 10 pixels below the top edge of the screen,
--and no lower than a space length (90 pixels) from the bottom
        local y = math.max(-Tube_Height + 10,
            math.min(self.lastY + math.random(-20, 20), Super_Height - 90 - Tube_Height))
        self.lastY = y
--Add a new tube pair at the end of the screen at the new Y      
        table.insert(self.tubePairs, TubePair(y))
--Resets timer
        self.timer = 0
    end
--For every pair of tubes..
    for t, pair in pairs(self.tubePairs) do
--Tallies a point if the tube has gone past the eagle to the left all the way
--Ignores it if it's already been added to the tally
        if not pair.tallied then
            if pair.x + Tube_Width < self.eagle.x then
                self.tally = self.tally + 1
                pair.tallied = true
                sounds['tally']:play()
            end
        end
--Update position of pairings
        pair:update(dt)
    end
--Need this second loop, rather than deleting the previous loop, because
--modifying the table in-place without explicit kets will result in skipping the
--next tube, since all implicit kets are automatically shifted 
--down after a table removal
    for t, pair in pairs(self.tubePairs) do
        if pair.remove then
            table.remove(self.tubePairs, t)
        end
    end
--Simple collision between eagle and all tubes in pairs
    for t, pair in pairs(self.tubePairs) do
        for p, tube in pairs(pair.tubes) do
            if self.eagle:collides(tube) then
                sounds['blast']:play()
                sounds['injured']:play()

                gStateMachine:change('tally',{
                    tally = self.tally
                })
            end
        end
    end
--Updates eagle based on pressure and input
    self.eagle:update(dt)

--Resets if the eagle hits the ground
    if self.eagle.y > Super_Height - 15 then
        sounds['blast']:play()
        sounds['injured']:play()

        gStateMachine:change('tally',{
            tally = self.tally
        })
    end
end

function PlayState:render()
    for t, pair in pairs(self.tubePairs) do
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Tally:' .. tostring(self.tally), 8, 8)

    self.eagle:render()
end

--Called when this stat is transitioned to from another state.
function PlayState:enter()
--if we're comming from death, restart scrolling
    scrolling = true
end

--Called when this state changes to another state
function PlayState:exit()
--Stops scrolling for the death/tally screen
    scrolling = false
end