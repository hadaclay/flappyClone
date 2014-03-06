require("lib/AnAL")

love.graphics.setDefaultFilter("nearest", "nearest", 1)
playerGraphic = love.graphics.newImage("img/fappy_dong_spritesheet.png")
SF = 4

player = {
    spriteAnim = newAnimation(playerGraphic, 17, 12, 0.1, 0),
    SF = 4,

    -- Sprite Variables
    x=love.graphics.getWidth()/5,
    y=love.graphics.getHeight()/2,
    width = playerGraphic:getWidth(),
    height = playerGraphic:getHeight(),
    rotation = 0,

    -- Before game starts move player up and down
    preGameTop = love.graphics.getHeight()/2 - 18,
    preGameBottom = love.graphics.getHeight()/2 + 18,
    preGameMoveUp = true,
    preGameMoveDown = false,

    velocity = 0,
    gravity = 9.81 / 3,
}

function player:preGameMovement()
  if love.keyboard.isDown(" ") then globalState = States.Playing end

  if player.preGameMoveUp == true then
    player.y = player.y - 1
    if player.y == player.preGameTop then
      player.preGameMoveUp = false
      player.preGameMoveDown = true
    end
  elseif player.preGameMoveDown == true then
      player.y = player.y + 1
      if player.y == player.preGameBottom then
        player.preGameMoveDown = false
        player.preGameMoveUp = true
      end
  end
end

function player:gameMovement()
  deathHeight = groundTop - (player.height * SF)

  player.velocity = player.velocity + player.gravity
  player.y = player.y + player.velocity

  if player.y >= groundTop then globalState = States.Death end
end

function player:death()
  player.y = deathHeight
  player.gravity = 0
  player.velocity = 0

  player.spriteAnim:stop()

  if love.keyboard.isDown("r") then
    player.spriteAnim:play()
    player.y = love.graphics.getHeight() / 2
    player.gravity = 9.81 / 3

    globalState = States.NotPlaying
  end
end

function player:update(dt)
  player.spriteAnim:update(dt)

  if globalState == States.NotPlaying then player:preGameMovement() end
  if globalState == States.Playing then player:gameMovement() end
  if globalState == States.Death then player:death() end

end

function player:draw()
  player.spriteAnim:draw(player.x, player.y, player.rotation, SF, SF)
end
