local gamera = require 'gamera'

-- player data/functions

local player = {
  x       = 100,
  y       = 100,
  width   = 50,
  height  = 75,
  speed   = 400
}

local isDown = love.keyboard.isDown

local function movePlayer(dt)
  local dx = isDown('left') and -1 or (isDown('right') and 1 or 0)
  local dy = isDown('up') and -1 or (isDown('down') and 1 or 0)
  player.x = player.x + dx * dt * player.speed
  player.y = player.y + dy * dt * player.speed
end

local function drawPlayer()
  love.graphics.rectangle('line',
                          player.x - player.width / 2,
                          player.y - player.height / 2,
                          player.width,
                          player.height)
end

-- world data & functions

local world = {
  width   = 5000,
  height  = 3000,
  rows    = 10,
  columns = 20
}

local function drawWorld()
  local columnWidth = world.width / world.columns
  for x=1, world.columns do
    love.graphics.line(x*columnWidth, 0, x*columnWidth, world.height)
  end
  local rowHeight = world.height / world.rows
  for y=1, world.rows do
    love.graphics.line(0, y*rowHeight, world.width, y*rowHeight)
  end
end

-- main love functions

function love.load()
  -- adapt gamera to the dimensions that the world has
  gamera.setBoundary(0, 0, world.width, world.height)
end

function love.update(dt)
  movePlayer(dt)
end

function love.draw()
  -- center the view on the player first
  gamera.lookAt(player.x, player.y)
  -- then draw camera-dependent stuff, including the player
  gamera.draw(function(l,t,w,h)
    drawPlayer()
    drawWorld()
  end)
  -- this is outside of gamera.draw so it is not affected by the scroll
  love.graphics.print("gamera demo. Move with arrows, exit with esc.", 10, 10)
end

-- exit with esc
function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
end
