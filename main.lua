local gamera = require 'gamera'

-- world data & functions
local world = {
  width   = 5000,
  height  = 3000,
  rows    = 10,
  columns = 20
}


local function drawWorld()
  local w = world.width / world.columns
  local h = world.height / world.rows
  for y=0, world.rows-1 do
    for x=0, world.columns-1 do
      if (x + y) % 2 == 0 then
        love.graphics.setColor(155,155,155)
      else
        love.graphics.setColor(200,200,200)
      end
      love.graphics.rectangle("fill", x*w, y*h, w, h)
    end
  end
end

-- target data and functions
local target = {
  x = 500,
  y = 500
}

local function updateTarget(dt)
  target.x, target.y = gamera.toWorld(love.mouse.getPosition())
end

local function drawTarget()
  love.graphics.setColor(255,255,0)
  love.graphics.circle("fill", target.x, target.y, 40)
end

-- player data/functions

local player = {
  x         = 200,
  y         = 200,
  width     = 100,
  height    = 100
}

local isDown = love.keyboard.isDown

local function makeZero(x,minX,maxX)
  if x > maxX or x < minX then return x end
  return 0
end

local function updatePlayer(dt)
  local dx,dy = makeZero(target.x - player.x, -5,5),
                makeZero(target.y - player.y, -5,5)
  player.x = player.x + 2 * dx * dt
  player.y = player.y + 2 * dy * dt
end

local function drawPlayer()
  love.graphics.setColor(0,255,0)
  love.graphics.rectangle('fill',
                          player.x - player.width / 2,
                          player.y - player.height / 2,
                          player.width,
                          player.height)
end


-- camera functions
local scale = 1

local function updateCamera(dt)
  gamera.setPosition(player.x, player.y)

  local scaleFactor = isDown('z') and -0.8 or (isDown('x') and 0.8 or 0)
  local scale = gamera.getScale()
  gamera.setScale(scale + scaleFactor * dt)
end


-- target functions

-- main love functions

function love.load()
  gamera.setWorld(0, 0, world.width, world.height)
  gamera.setWindow(10,10,580,580)
end

function love.update(dt)
  updatePlayer(dt)
  updateCamera(dt)
  updateTarget(dt)
end

function love.draw()
  gamera.draw(function(l,t,w,h)
    drawWorld()
    drawPlayer()
    drawTarget()
  end)
end

-- exit with esc
function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
end
