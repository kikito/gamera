
local gamera = {}

-- Private attributes and methods

local world, window, position, scale

local function max(a,b)
  return a > b and a or b
end

local function checkNumber(value, name)
  if type(value) ~= 'number' then error(name .. " must be a number") end
end

local function checkPositiveNumber(value, name)
  if type(value) ~= 'number' or value <=0 then
    error(name .. " must be a postive number")
  end
end

local function checkAABB(l,t,w,h)
  checkNumber(l, "l")
  checkNumber(t, "t")
  checkPositiveNumber(w, "w")
  checkPositiveNumber(h, "h")
end

local function clamp(x, minX, maxX)
  if maxX < minX then return (minX-maxX)*.5 end
  return x < minX and minX or (x>maxX and maxX or x)
end

local function clampPosition()
  local wl,wt,ww,wh = world.l, world.t, world.w, world.h
  local w2,h2 = window.w*0.5/scale, window.h*0.5/scale

  position.x, position.y = clamp(position.x, wl + w2, wl + ww - w2),
                           clamp(position.y, wt + h2, wt + wh - h2)
end


-- Public interface

function gamera.setWorld(l,t,w,h)
  checkAABB(l,t,w,h)
  world.l, world.t, world.w, world.h = l,t,w,h
  clampPosition()
end

function gamera.setWindow(l,t,w,h)
  checkAABB(l,t,w,h)
  window.l, window.t, window.w, window.h = l,t,w,h
  clampPosition()
end

function gamera.setPosition(x,y)
  checkNumber(x, "x")
  checkNumber(y, "y")

  position.x, position.y = x,y
  clampPosition()
end

function gamera.setScale(newScale)
  checkPositiveNumber(newScale, "newScale")
  local minX, minY = window.w/world.w, window.h/world.h

  scale = math.max(minX, minY, newScale)

  clampPosition()
end

function gamera.getWorld()
  return world.l, world.t, world.w, world.h
end

function gamera.getWindow()
  return window.l, window.t, window.w, window.h
end

function gamera.getPosition()
  return position.x, position.y
end

function gamera.getScale()
  return scale
end

function gamera.getVisible()
  local w,h   = window.w, window.h
  local w2,h2 = w/(2*scale), h/(2*scale)

  return position.x - w2, position.y - h2, w/scale, h/scale
end

function gamera.draw(f)
  love.graphics.setScissor(gamera.getWindow())

  love.graphics.push()

    love.graphics.scale(scale, scale)
    love.graphics.translate( window.w/(2*scale) + window.l - position.x,
                             window.h/(2*scale) + window.t - position.y)
    f(gamera.getVisible())

  love.graphics.pop()

  love.graphics.setScissor()
end

function gamera.toWorld(x,y)
  return (x - window.w/2) / scale + position.x - window.l,
         (y - window.h/2) / scale + position.y - window.t
end

function gamera.reset()
  world    = {}
  window   = {l=0,t=0, w=love.graphics.getWidth(), h=love.graphics.getHeight()}
  position = {x = window.w/2, y = window.h/2}
  scale    = 1
end

gamera.reset()

return gamera




