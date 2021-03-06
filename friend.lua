
local util = require 'util'

----------------------------------------

local state
local focused = true
local bgm
local sounds = {}
local keyp = {}
local joyb = {}
local hasJoy = false
local joyThreshold = 0.333

local frames = 0
local startTime = love.timer.getMicroTime()

local xscale = math.floor(love.graphics.getWidth() / 320)
local yscale = math.floor(love.graphics.getHeight() / 240)

local font
local fontset = [=[ !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_`abcdefghijklmnopqrstuvwxyz{|}~]=]

----------------------------------------

function love.focus(f)
  focused = f
end

function love.joystickpressed(j, b)
  joyb[b] = 0
end

function love.joystickreleased(j, b)
  joyb[b] = nil
end

function love.keypressed(k, u)
  print("pressed", k)
  keyp[k] = 0
  if k == "f10" then
    love.event.push("q")
  end
end

function love.keyreleased(k)
  keyp[k] = nil
end

function love.mousepressed(x, y, b)
end

function love.mousereleased(x, y, b)
end

function love.quit()
  local endTime = love.timer.getMicroTime( )
  print( "Time: "..(endTime-startTime) )
end

function love.draw()
  love.graphics.scale( xscale, yscale )
  state:draw()
end

local function updateKeys()
  for k, v in pairs(keyp) do
    keyp[k] = v+1
  end
end

local function updateJoy()
  if not hasJoy then return end

  for k, v in pairs(joyb) do
    joyb[k] = v+1
  end

  local x, y = love.joystick.getAxes(0)

  if y < -joyThreshold then
    joyb["up"] = joyb["up"] or 1
    joyb["down"] = nil
  elseif y > joyThreshold then
    joyb["down"] = joyb["down"] or 1
    joyb["up"] = nil
  else
    joyb["up"] = nil
    joyb["down"] = nil
  end

  if x < -joyThreshold then
    joyb["left"] = joyb["left"] or 1
    joyb["right"] = nil
  elseif x > joyThreshold then
    joyb["right"] = joyb["right"] or 1
    joyb["left"] = nil
  else
    joyb["left"] = nil
    joyb["right"] = nil
  end
end

function love.update(dt)
  updateKeys()
  updateJoy()

  if focused then
    if dt > 0.4 then dt = 0.4 end
    state:update(dt)
  end
end

function love.load()
  math.randomseed( os.time() )
  love.graphics.setColorMode("modulate")
  love.graphics.setBlendMode("alpha")
  hasJoy = (love.joystick.getNumJoysticks()>=1) and (love.joystick.isOpen(0))

  local fontimage = love.graphics.newImage("wayfont.png")
  fontimage:setFilter("nearest", "nearest")
  font = love.graphics.newImageFont(fontimage, fontset)
  font:setLineHeight( fontimage:getHeight()-1 )

end

----------------------------------------
local friend = {}
----------------------------------------

function friend.setState(s)
  if state and state.exit then state:exit() end
  state = s
  if state and state.enter then state:enter() end
end

function friend.playMod( mod )
  friend.stopMod()
  bgm = love.audio.newSource(mod, "stream")
  bgm:setLooping( true )
  bgm:setVolume(0.2)
  love.audio.play(bgm)
end

function friend.stopMod()
  if not bgm then return end
  love.audio.stop(bgm)
  bgm = nil
end

function friend.key(s)
  return keyp[s]
end

function friend.joy(s)
  return joyb[s]
end

function friend.pressed(s)
  if keyp[s] then return keyp[s] end
  if joyb[s] then return joyb[s] end
  return false
end

function friend.font()
  return font
end

----------------------------------------
return friend
----------------------------------------

