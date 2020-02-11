--Displays the player's score before transitioning back to PlayState
TallyState = Class{__includes = BaseState}

local medals = {
    love.graphics.newImage('gold.png'),
    love.graphics.newImage('silver.png'),
    love.graphics.newImage('bronze.png')
}
--Entering the tally state, expect to receive the numbered tally 
--from the play state so the game knows what to render to the State
function TallyState:enter(params)
    self.tally = params.tally
end

function TallyState:update(dt)
--Go back to play if enter is hit
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TallyState:render()
--Render the numbered tally to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Gameover', 0, 64, Super_Width, 'center')

    if self.tally > 2 and self.tally <= 4 then 
        love.graphics.draw(medals[2], Super_Width/2 - medals[2]:getWidth()/2, Super_Height/2 + 30)
    elseif self.tally >= 5 then 
        love.graphics.draw(medals[1], Super_Width/2 - medals[1]:getWidth()/2, Super_Height/2 + 30)
    else 
        love.graphics.draw(medals[3], Super_Width/2 - medals[3]:getWidth()/2, Super_Height/2 + 30)
    end

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Tally: ' .. tostring(self.tally), 0, 100, Super_Width, 'center')

    love.graphics.printf('Hit Enter to Play Again', 0, 160, Super_Width, 'center')
end