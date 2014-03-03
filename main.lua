require("lib/AnAL")

States = {Loading = 1, NotPlaying = 2, Playing = 3, Lose = 4}
globalState = nil

function love.load()
  globalState = States.Loading
  love.graphics.setDefaultFilter("linear", "nearest", 1)

  -- Load Graphics
  SF = 4 -- Scale Factor for gfx
  logoGraphic = love.graphics.newImage("img/fappyDong Logo.png")
  bgGraphic = love.graphics.newImage("img/bg.png")
  groundGraphic = love.graphics.newImage("img/ground.png")
  pipeGraphic = love.graphics.newImage("img/pipe_condom.png")
  pipeFlipGraphic = love.graphics.newImage("img/pipe_condom_flip.png")
  playerGraphic = love.graphics.newImage("img/fappy_dong_spritesheet.png")

  -- Load Sound
  flapSound = love.sound.newSoundData("sfx/flap.wav")
  hurtSound = love.sound.newSoundData("sfx/hurt.wav")

  player = {
    spriteAnim = newAnimation(playerGraphic, 17, 12, 0, 3),

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

  groundWidth = groundGraphic:getWidth() * SF
  groundHeight = groundGraphic:getHeight()
  groundPosX = 0

  globalState = States.NotPlaying
end

function love.update(dt)
  player.spriteAnim:update(dt)

  if globalState == States.NotPlaying then
    preGameMovement()
  end

end

function love.draw()
  love.graphics.draw(bgGraphic, 0, 0, 0, SF, SF)
  drawGround()

  love.graphics.draw(logoGraphic,
                love.graphics.getWidth() / 2 - logoGraphic:getWidth() * 4 / 2,
                15, 0, SF, SF)

  player.spriteAnim:draw(player.x, player.y, 0, SF, SF)
end

function drawGround()
  love.graphics.draw(groundGraphic, groundPosX,
                     love.graphics.getHeight() - groundHeight - 10, 0, SF, SF)

  love.graphics.draw(groundGraphic, groundPosX + groundWidth,
                       love.graphics.getHeight() - groundHeight - 10, 0, SF, SF)

  groundPosX = groundPosX - 5 -- Scroll left

  if groundPosX <= -groundWidth then groundPosX = 0 end
end

function preGameMovement()
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
