
local gamera = {}

-- Private attributes and methods

local world, window, position

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

local function checkCoord(x,y)
  checkNumber(x, "x")
  checkNumber(y, "y")
end

local function clamp(x, min, max)
  if max < min then return (min-max)*.5 end
  return x < min and min or (x>max and max or x)
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
  local w2,h2 = w*0.5, h*0.5

  return position.x - w2, position.y - h2, w, h
end

function gamera.setPosition(x,y)
  checkCoord(x,y)

  local wl,wt,ww,wh = world.l, world.t, world.w, world.h
  local w2,h2 = window.w*0.5, window.h*0.5

  position.x, position.y = clamp(x, wl + w2, wl + ww - w2),
                           clamp(y, wt + h2, wt + wh - h2)
end

function gamera.getPosition()
  return position.x, position.y
end

function gamera.draw(f)
  love.graphics.setScissor(gamera.getWindow())
  love.graphics.push()
    love.graphics.translate(window.l, window.t)
    love.graphics.push()
      local l,t,w,h = gamera.getVisible()
      love.graphics.translate(-l,-t)
      f(l,t,w,h)

    love.graphics.pop()
  love.graphics.pop()
  love.graphics.setScissor()
end

function gamera.reset()
  world  = {}
  window = {l=0,t=0, w=love.graphics.getWidth(), h=love.graphics.getHeight()}
  position = {x = window.w/2, y = window.h/2}
end


gamera.reset()

return gamera




