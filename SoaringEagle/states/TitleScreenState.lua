--Starting screen of the game, shown during starup.
TitleScreenState = Class{__includes = BaseState}

function TitleScreenState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        gStateMachine:change('countdown')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Soaring Eagle', 0, 64, Super_Width, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Hit Enter', 0, 100, Super_Width, 'center')
end