local inspect = require 'inspect'


local gamera = require 'gamera'

-- game variables (entities)
local world, player, target, cam1, cam2

-- auxiliary functions
local isDown = love.keyboard.isDown

local function makeZero(x,minX,maxX)
  if x > maxX or x < minX then return x end
  return 0
end

-- world functions
local function drawWorld()
  local w = world.w / world.columns
  local h = world.h / world.rows
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

-- target functions
local function updateTarget(dt)
  target.x, target.y = cam1:toWorld(love.mouse.getPosition())
end

local function drawTarget()
  love.graphics.setColor(255,255,0)
  love.graphics.circle("fill", target.x, target.y, 40)
end

-- player functions
local function updatePlayer(dt)
  local dx,dy = makeZero(target.x - player.x, -5,5),
                makeZero(target.y - player.y, -5,5)
  player.x = player.x + 2 * dx * dt
  player.y = player.y + 2 * dy * dt
end

local function drawPlayer()
  love.graphics.setColor(0,255,0)
  love.graphics.rectangle('fill',
                          player.x - player.w / 2,
                          player.y - player.h / 2,
                          player.w,
                          player.h)
end

-- camera functions
local function updateCameras(dt)
  cam1:setPosition(player.x, player.y)

  local scaleFactor = isDown('z') and -0.8 or (isDown('x') and 0.8 or 0)
  cam1:setScale(cam1:getScale() + scaleFactor * dt)

  local angleFactor = isDown('a') and -0.8 or (isDown('s') and 0.8 or 0)
  cam1:setAngle(cam1:getAngle() + angleFactor * dt)
end

-- main love functions

function love.load()
  world  = { w = 5000, h = 3000, rows = 10, columns = 20 }
  target = { x = 500,  y = 500 }
  player = { x = 200,  y = 200, w = 100, h = 100 }

  cam1 = gamera.new(0, 0, world.w, world.h)
  cam1:setWindow(10,10,520,580)

  cam2 = gamera.new(0,0, world.w, world.h)
  cam2:setWindow(540,10,250,180)
  cam2:setScale(0)
  cam2:setPosition(world.w/2, world.h/2)
end

function love.update(dt)
  updatePlayer(dt)
  updateCameras(dt)
  updateTarget(dt)
end

function love.draw()
  cam1:draw(function(l,t,w,h)
    drawWorld()
    drawPlayer()
    drawTarget()
  end)

  cam2:draw(function(l,t,w,h)
    drawWorld()
    drawPlayer()
    drawTarget()
  end)

  love.graphics.setColor(255,255,255)
  love.graphics.rectangle('line', cam1:getWindow())
  love.graphics.rectangle('line', cam2:getWindow())
end

-- exit with esc
function love.keypressed(key)
  if key == 'escape' then love.event.quit() end
  if key == 'v' then
    print(inspect({cam1=cam1, cam2=cam2}))
  end
end
