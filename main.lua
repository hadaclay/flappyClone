require("world")
require("player")

States = {Loading = 1, NotPlaying = 2, Playing = 3, Lose = 4}
globalState = nil

function love.load()
  -- FPS Regulation
  min_dt = 1/60
  next_time = love.timer.getTime()

  globalState = States.Loading
  love.graphics.setDefaultFilter("nearest", "nearest", 1)

  -- Load Graphics
  SF = 4 -- Scale Factor for graphics
  logoGraphic     = love.graphics.newImage("img/fappyDong Logo.png")
  bgGraphic       = love.graphics.newImage("img/bg.png")
  groundGraphic   = love.graphics.newImage("img/ground.png")
  pipeGraphic     = love.graphics.newImage("img/pipe_condom.png")
  pipeFlipGraphic = love.graphics.newImage("img/pipe_condom_flip.png")

  -- Load Sound
  flapSound = love.sound.newSoundData("sfx/flap.wav")
  hurtSound = love.sound.newSoundData("sfx/hurt.wav")

  world:load()

  globalState = States.NotPlaying
end

function love.update(dt)
  next_time = next_time + min_dt

  player:update(dt)
end

function love.draw()
  world:draw()
  player:draw()

  local cur_time = love.timer.getTime()
  if next_time <= cur_time then
    next_time = cur_time
    return
  end
  love.timer.sleep(next_time - cur_time)
end
