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
  velocity = 0,
  gravity = 0.5,
  flapPower = 9,
}

-- Handle player keypresses
function love.keypressed(key, isrepeat)
  if key == " " then
    if globalState == States.NotPlaying then globalState = States.Playing end

    -- Flap
    if globalState == States.Playing then
      player.velocity = 0
      player.velocity = player.velocity - player.flapPower
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
    globalState = States.Death
  end
end

function player:death()
  player.y = deathHeight
  player.velocity = 0

  playerAnim:stop()

  if love.keyboard.isDown("r") then
    playerAnim:play()
    player.y = love.graphics.getHeight() / 2

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
    drawText("Press Space to Begin", 165, love.graphics.getHeight() / 4)
  end

  if globalState == States.Death then
    drawText("Press R to Restart", 165, love.graphics.getHeight() / 4)
  end

  playerAnim:draw(player.x, player.y, player.rotation, SF, SF)
end
