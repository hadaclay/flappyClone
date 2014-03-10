require("lib/AnAL") -- Animation library

love.graphics.setDefaultFilter("nearest", "nearest", 1)
playerGraphic = love.graphics.newImage("img/fappy_dong_spritesheet.png")
SF = 4

player = {
  -- Sprite Variables
  x=love.graphics.getWidth()/5,
  y=love.graphics.getHeight()/2,
  width = playerGraphic:getWidth() * SF,
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
    end
  end
end

function player:load()
  playerAnim = newAnimation(playerGraphic, 17, 12, 0.1, 0)
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
  deathHeight = groundTop - (player.height * SF) -- Temporary, no collision.

  player.velocity = player.velocity + player.gravity
  player.y = player.y + player.velocity

  -- Stop from going too high
  if player.y <= 0 then player.velocity = 0 end

  -- Check for ground collision
  if player.y + (player.height * SF) >= groundTop then
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

function drawText(text, x, y)
  love.graphics.setColor(250, 250, 250, 255)
  love.graphics.print(text, x, y)
  love.graphics.reset()
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
