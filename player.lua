require("lib/AnAL") -- Animation library
require("lib/BoundingBox")

love.graphics.setDefaultFilter("nearest", "nearest", 1)
playerGraphic = love.graphics.newImage("img/fappy_dong_spritesheet.png")
playerAnim    = newAnimation(playerGraphic, 17, 12, 0.1, 0)
SF = 4

player = {
  -- Sprite Variables
  x=love.graphics.getWidth()/5,
  y=love.graphics.getHeight()/2,
  width = playerGraphic:getWidth(),
  height = playerGraphic:getHeight(),
  rotation = 0,

  -- Pre-game variables
  preGameTop = love.graphics.getHeight()/2 - 30,
  preGameBottom = love.graphics.getHeight()/2 + 10,
  preGameMoveUp = true,
  preGameMoveDown = false,
  upDownSpeed = 1,

  -- Gameplay variables
  score = 0,
  highestScore = 0,
  velocity = 0,
  gravity = 0.5,
  flapPower = 10,
}

-- Handle player keypresses
function love.keypressed(key, isrepeat)
  if key == " " then
    if globalState == States.NotPlaying then globalState = States.Playing end

    -- Flap
    if globalState == States.Playing then
      player.velocity = 0
      player.velocity = player.velocity - player.flapPower
      flapSound:play()
    end
  end
end

-- Before game starts move player up and down
function player:preGameMovement()
  if player.preGameMoveUp == true then
    player.y = player.y - player.upDownSpeed
    if player.y <= player.preGameTop then
      player.preGameMoveUp = false
      player.preGameMoveDown = true
    end
  elseif player.preGameMoveDown == true then
    player.y = player.y + player.upDownSpeed
    if player.y >= player.preGameBottom then
      player.preGameMoveDown = false
      player.preGameMoveUp = true
    end
  end
end

function player:gameMovement()
  deathHeight = world.groundTop - (player.height * SF)

  player.velocity = player.velocity + player.gravity
  player.y = player.y + player.velocity

  -- Stop from going too high
  if player.y <= 0 then
    player.y = 0
    player.velocity = 0
  end

  -- Check for ground collision
  if player.y + (player.height * SF) >= world.groundTop then
    hurtSound:play()
    globalState = States.Death
  end
end

function player:death()
  playerAnim:stop()

  if player.score > player.highestScore then
    player.highestScore = player.score
  end

  if player.y >= deathHeight then
    player.y = deathHeight
    player.velocity = 0
  end

  player.velocity = player.velocity + player.gravity
  player.y = player.y + player.velocity

  --player.y = deathHeight
  --player.velocity = 0

  if love.keyboard.isDown("r") then
    playerAnim:play()
    player.y = love.graphics.getHeight() / 2

    player.score = 0

    globalState = States.NotPlaying
  end
end

function player:update(dt)
  playerAnim:update(dt)

  if globalState == States.NotPlaying then player:preGameMovement() end
  if globalState == States.Playing then player:gameMovement() end
  if globalState == States.Death then player:death() end
end

function player:draw()
  if globalState == States.NotPlaying then
    local beginWidth = gameFont:getWidth("Press Space to Begin")
    drawText("Press Space to Begin", love.graphics.getWidth()/2 - beginWidth/2, love.graphics.getHeight() / 4)
  end

  if globalState == States.Death then
    local restartWidth = gameFont:getWidth("Press R to Restart")
    drawText("Press R to Restart", love.graphics.getWidth()/2 - restartWidth/2,
            love.graphics.getHeight() / 4)
  end

  playerAnim:draw(player.x, player.y, player.rotation, SF, SF)
end
