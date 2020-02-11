push = require 'push'

Class = require 'class'

require 'Eagle'
require 'Tube' 
require 'TubePair'

require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/TallyState'
require 'states/TitleScreenState'

--Screen dimensions
Box_Width = 1280
Box_Height = 720
--Emulated resolution dimensions
Super_Width = 512
Super_Height = 288

local backdrop = love.graphics.newImage('backdrop.png')
local backdropScroll = 0

local floor= love.graphics.newImage('floor.png')
local floorScroll = 0

local Backdrop_Scroll_Speed = 30
local Floor_Scroll_Speed = 60

local Backdrop_Looping_Point = 413

local gamePaused = false

function love.load()
        love.graphics.setDefaultFilter('nearest', 'nearest')
--Seed the RNG
        math.randomseed(os.time())
--Window title
        love.window.setTitle('Soaring Eagle')
--Intitalize fonts
        littleFont = love.graphics.newFont('font.ttf', 8)
        mediumFont = love.graphics.newFont('flappy.ttf', 14)
        flappyFont = love.graphics.newFont('flappy.ttf', 28)
        bigFont = love.graphics.newFont('font.ttf', 56)
        love.graphics.setFont(flappyFont)
--Intitalize sounds
        sounds = {
            ['flap'] = love.audio.newSource('flap.wav', 'static'),
            ['blast'] = love.audio.newSource('blast.wav', 'static'),
            ['injured'] = love.audio.newSource('injured.wav', 'static'),
            ['tally'] = love.audio.newSource('tally.wav', 'static'),

--https://freesound.org/people/Tristan_Lohengrin/sounds/343835/
            ['music'] = love.audio.newSource('343835__tristan-lohengrin__happy-8bit-loop-01.wav', 'static')
        }
--Kick off music
        sounds['music']:setLooping(true)
        sounds['music']:play()
--Initalized emulated resolution
        push:setupScreen(Super_Width, Super_Height, Box_Width, Box_Height,{
            vsync = true,
            fullscreen = false,
            resizable = true
        })
--Intitalize State Machine with all state-returning functions
        gStateMachine = StateMachine {
            ['title'] = function() return TitleScreenState() end,
            ['countdown'] = function() return CountdownState() end,
            ['play'] = function() return PlayState() end,
            ['tally'] = function() return TallyState() end
        }
        gStateMachine:change('title')
--Initalize input table
        love.keyboard.keysPressed = {}
--Initalize mouse input table
        love.mouse.buttonsPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
--Added to the table of keys pressed in the frame.
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
    if key == 'p' then
        gamePaused = not gamePaused

        if gamePaused then
            sounds['music']:pause()
        else 
            sounds['music']:play()
        end
    end
end

--LÖVE2D callback fired each time a mouse button is pressed; 
--gives us the X and Y of the mouse, as well as the button in question.
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

--Equivalent to our keyboard function from before, but for the mouse buttons.
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end


function love.update(dt)
    if not gamePaused then
        backdropScroll = (backdropScroll + Backdrop_Scroll_Speed * dt) % Backdrop_Looping_Point
        floorScroll = (floorScroll + Floor_Scroll_Speed * dt) % Super_Width
        gStateMachine:update(dt)
    end

        love.keyboard.keysPressed = {}
        love.mouse.buttonsPressed = {}
    end

function love.draw()
    push:start()

    love.graphics.draw(backdrop, -backdropScroll, 0)
    gStateMachine:render()
    love.graphics.draw(floor, -floorScroll, Super_Height - 16)

    push:finish()
end