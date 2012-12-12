
local gamera = {}

-- Private attributes and methods

local gameraMt = {__index = gamera}
local max, abs = math.max, math.abs


local function checkNumber(value, name)
  if type(value) ~= 'number' then
    error(name .. " must be a number (was: " .. tostring(value) .. ")")
  end
end

local function checkPositiveNumber(value, name)
  if type(value) ~= 'number' or value <=0 then
    error(name .. " must be a positive number (was: " .. tostring(value) ..")")
  end
end

local function checkAABB(l,t,w,h)
  checkNumber(l, "l")
  checkNumber(t, "t")
  checkPositiveNumber(w, "w")
  checkPositiveNumber(h, "h")
end

local function clamp(x, minX, maxX)
  assert(maxX >= minX)
  return x < minX and minX or (x>maxX and maxX or x)
end

local function clampPosition(self)
  local wl,wt,ww,wh = self.wl, self.wt, self.ww, self.wh
  local _,_,w,h = self:getVisible()
  local w2,h2 = w*0.5, h*0.5

  self.x, self.y = clamp(self.x, wl + w2, wl + ww - w2),
                   clamp(self.y, wt + h2, wt + wh - h2)
end

local function clampScale(self)
  local _,_,w,h = self:getVisible()
  local minX, minY = w/self.ww, h/self.wh
  self.scale       = max(minX, minY, self.scale)
end

-- Public interface

function gamera.new(l,t,w,h)

  local sw,sh = love.graphics.getWidth(), love.graphics.getHeight()

  local cam = setmetatable({
    x=0, y=0,
    scale=1, invScale=1,
    angle=0, sin=math.sin(0), cos=math.cos(0),
    l=0, t=0, w=sw, h=sh, w2=sw/2, h2=sh/2
  }, gameraMt)
  cam:setWorld(l,t,w,h)
  return cam
end

function gamera:setWorld(l,t,w,h)
  checkAABB(l,t,w,h)
  self.wl, self.wt, self.ww, self.wh = l,t,w,h
  clampPosition(self)
end

function gamera:setWindow(l,t,w,h)
  checkAABB(l,t,w,h)
  self.l, self.t, self.w, self.h, self.w2, self.h2 = l,t,w,h, w*0.5, h*0.5
  clampPosition(self)
end

function gamera:setPosition(x,y)
  checkNumber(x, "x")
  checkNumber(y, "y")

  self.x, self.y = x,y
  clampPosition(self)
end

function gamera:setScale(scale)
  checkNumber(scale, "scale")

  self.scale = scale
  clampScale(self)
  self.invScale = 1/self.scale

  clampPosition(self)
end

function gamera:setAngle(angle)
  checkNumber(angle, "angle")
  self.angle = angle
  self.cos, self.sin = math.cos(angle), math.sin(angle)

  clampPosition(self)
end

function gamera:getWorld()
  return self.wl, self.wt, self.ww, self.wh
end

function gamera:getWindow()
  return self.l, self.t, self.w, self.h
end

function gamera:getPosition()
  return self.x, self.y
end

function gamera:getScale()
  return self.scale
end

function gamera:getAngle()
  return self.angle
end

function gamera:getVisible()
  local invScale, sin, cos = self.invScale, abs(self.sin), abs(self.cos)
  local w,h = self.w * invScale, self.h * invScale
  local w,h = cos*w + sin*h, sin*w + cos*h
  return self.x - w*0.5, self.y - h*0.5, w, h
end

function gamera:draw(f)
  love.graphics.setScissor(self:getWindow())

  love.graphics.push()
    local invScale = self.invScale
    love.graphics.scale(self.scale)

    love.graphics.translate((self.w2 + self.l) * invScale, (self.h2+self.t) * invScale)
    love.graphics.rotate(-self.angle)
    love.graphics.translate(-self.x, -self.y)

    f(self:getVisible())

  love.graphics.pop()

  love.graphics.setScissor()
end

function gamera:toWorld(x,y)
  local invScale, sin, cos = self.invScale, self.sin, self.cos
  x,y = (x - self.w2 - self.l) * invScale, (y - self.h2 - self.t) * invScale
  x,y = cos*x - sin*y, sin*x + cos*y
  return x + self.x, y + self.y
end

return gamera




