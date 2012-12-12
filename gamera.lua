
local gamera = {}

-- Private attributes and methods

local gameraMt = {__index = gamera}
local lg = love.graphics
local sin,cos,max = math.sin, math.cos, math.max


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
  local scale = self.scale
  local wl,wt,ww,wh = self.wl, self.wt, self.ww, self.wh
  local w2,h2 = self.w2/scale, self.h2/scale

  self.x, self.y = clamp(self.x, wl + w2, wl + ww - w2),
                   clamp(self.y, wt + h2, wt + wh - h2)
end

local function clampScale(self)
  local minX, minY = self.w/self.ww, self.h/self.wh
  self.scale       = max(minX, minY, self.scale)
end


-- Public interface

function gamera.new(l,t,w,h)

  local cam = setmetatable({ x=0, y=0, scale=1, angle=0, l=0, t=0, w=lg.getWidth(), h=lg.getHeight() }, gameraMt)
  cam.w2, cam.h2 = cam.w * 0.5, cam.h * 0.5
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
  clampPosition(self)
end

function gamera:setAngle(angle)
  checkNumber(angle, "angle")
  self.angle = angle

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
  local scale = self.scale
  local w2,h2 = self.w2/scale, self.h2/scale

  return self.x - w2, self.y - h2, self.w/scale, self.h/scale
end

function gamera:draw(f)
  love.graphics.setScissor(self:getWindow())

  love.graphics.push()
    local scale = self.scale
    love.graphics.scale(scale)

    love.graphics.translate((self.w2 + self.l)/scale, (self.h2+self.t)/scale)
    love.graphics.rotate(-self.angle)
    love.graphics.translate(-self.x, -self.y)

    f(self:getVisible())

  love.graphics.pop()

  love.graphics.setScissor()
end

function gamera:toWorld(x,y)
  local angle, scale = self.angle, self.scale
  local c, s         = cos(angle), sin(angle)
  x,y = (x - self.w2 - self.l)/scale, (y - self.h2 - self.t)/scale
  x,y = c*x - s*y, s*x + c*y
  return x + self.x, y + self.y
end

return gamera




