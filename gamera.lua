
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
  local sx,sy = scale.x, scale.y
  local w2,h2 = window.w*0.5/sx, window.h*0.5/sy

  position.x, position.y = clamp(position.x, wl + w2, wl + ww - w2),
                           clamp(position.y, wt + h2, wt + wh - h2)
end


-- Public interface

function gamera.setWorld(l,t,w,h)
  checkAABB(l,t,w,h)
  world.l, world.t, world.w, world.h = l,t,w,h
end

function gamera.getWorld()
  return world.l, world.t, world.w, world.h
end

function gamera.setWindow(l,t,w,h)
  checkAABB(l,t,w,h)
  window.l, window.t, window.w, window.h = l,t,w,h
end

function gamera.getWindow()
  return window.l, window.t, window.w, window.h
end

function gamera.getVisible()
  local w,h = window.w, window.h
  local sx,sy = scale.x, scale.y

  local w2,h2 = w*0.5/sx, h*0.5/sy

  return position.x - w2, position.y - h2, w/sx, h/sy
end

function gamera.setPosition(x,y)
  checkNumber(x, "x")
  checkNumber(y, "y")

  position.x, position.y = x,y
  clampPosition()
end

function gamera.getPosition()
  return position.x, position.y
end

function gamera.setScale(sx, sy)
  checkPositiveNumber(sx, "sx")
  sy = sy or sx
  checkPositiveNumber(sy, "sy")
  local minX, minY = window.w/world.w, window.h/world.h

  scale.x, scale.y = max(minX, sx), max(minY, sy)

  clampPosition()
end

function gamera.getScale()
  return scale.x, scale.y
end

function gamera.draw(f)
  love.graphics.setScissor(gamera.getWindow())
  love.graphics.push()
    love.graphics.translate(window.l, window.t)
    love.graphics.push()
      local l,t,w,h = gamera.getVisible()
      love.graphics.translate(-l,-t)
      love.graphics.scale(scale.x, scale.y)
      f(l,t,w,h)

    love.graphics.pop()
  love.graphics.pop()
  love.graphics.setScissor()
end

function gamera.reset()
  world    = {}
  window   = {l=0,t=0, w=love.graphics.getWidth(), h=love.graphics.getHeight()}
  position = {x = window.w/2, y = window.h/2}
  scale    = {x=1, y=1}
end


gamera.reset()

return gamera




