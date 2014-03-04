require("lib/AnAL")

love.graphics.setDefaultFilter("nearest", "nearest", 1)
playerGraphic = love.graphics.newImage("img/fappy_dong_spritesheet.png")

player = {
    spriteAnim = newAnimation(playerGraphic, 17, 12, 0.1, 0),

    x=love.graphics.getWidth()/5,
    y=love.graphics.getHeight()/2,
    width = playerGraphic:getWidth(),
    height = playerGraphic:getHeight(),

    preGameTop = love.graphics.getHeight()/2 - 18,
    preGameBottom = love.graphics.getHeight()/2 + 18,
    preGameMoveUp = true,
    preGameMoveDown = false,

    gravity = 9.81
}

function player:preGameMovement()
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

function player:update(dt)
  player.spriteAnim:update(dt)

  if globalState == States.NotPlaying then
    player:preGameMovement()
  end
end

function player:draw()
  player.spriteAnim:draw(player.x, player.y, 0, SF, SF)
end
