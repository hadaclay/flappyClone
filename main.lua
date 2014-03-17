require("world")
require("player")

States = {Loading = 1, NotPlaying = 2, Playing = 3, Death = 4}
globalState = nil

function love.load()
  -- Seed RNG
  math.randomseed(os.time())

  -- FPS Regulation
  min_dt = 1/60
  next_time = love.timer.getTime()

  globalState = States.Loading
  love.graphics.setDefaultFilter("nearest", "nearest", 1)

  -- Load Graphics and font
  SF = 4 -- Graphics scale factor

  gameFont = love.graphics.newFont("img/ataurus.ttf", 36)

  -- Load Sound
  flapSound = love.sound.newSoundData("sfx/flap.ogg")
  hurtSound = love.sound.newSoundData("sfx/hurt.ogg")

  globalState = States.NotPlaying
end

function love.update(dt)
  next_time = next_time + min_dt

  if globalState == States.NotPlaying then
    if love.keyboard.isDown(" ") then globalState = States.Playing end
  end

  player:update(dt)
  world:update(dt)
end

function love.draw()
  love.graphics.setFont(gameFont)
  world:draw()
  player:draw()

  local cur_time = love.timer.getTime()
  if next_time <= cur_time then
    next_time = cur_time
    return
  end
  love.timer.sleep(next_time - cur_time)
end

function drawText(text, x, y) -- For Debugging
  love.graphics.setColor(250, 250, 250, 255)
  love.graphics.print(text, x, y)
  love.graphics.reset()
end
