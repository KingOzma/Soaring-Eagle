--The state where the countdown appears visually in the game.

CountdownState = Class{__includes = BaseState}

--Allows for 1 second to countdown
Countdown_Time = 0.75

function CountdownState:init()
    self.count = 3
    self.timer = 0
end

--Track the amount of time that passed and decreases the count. When the timer reaches 0,
-- the game will transition to PlayState
function CountdownState:update(dt)
    self.timer = self.timer + dt

    if self.timer > Countdown_Time then
        self.timer = self.timer % Countdown_Time
        self.count = self.count - 1

        if self.count == 0 then
            gStateMachine:change('play')
        end
    end
end

function CountdownState:render()
    love.graphics.setFont(bigFont)
    love.graphics.printf(tostring(self.count), 0, 120, Super_Width, 'center')
end