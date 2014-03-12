-- Load world graphics
love.graphics.setDefaultFilter("nearest", "nearest", 1)
logoGraphic     = love.graphics.newImage("img/fappyDong Logo.png")
bgGraphic       = love.graphics.newImage("img/bg.png")
groundGraphic   = love.graphics.newImage("img/ground.png")
pipeGraphic     = love.graphics.newImage("img/pipe_condom.png")
pipeFlipGraphic = love.graphics.newImage("img/pipe_condom_flip.png")
SF = 4

world = {
  groundWidth = groundGraphic:getWidth() * SF,
  groundHeight = groundGraphic:getHeight(),
  groundTop = love.graphics.getHeight() - groundGraphic:getHeight() - 10,
  groundPosX = 0, -- Used for ground scrolling
}

groundCollisionRect = {x = 0, y = world.groundTop,
                         w = world.groundWidth, h = world.groundHeight}

function world:draw()
  love.graphics.draw(bgGraphic, 0, 0, 0, SF, SF)
  world:drawGround()

  if globalState == States.NotPlaying then
    love.graphics.draw(logoGraphic,
                love.graphics.getWidth() / 2 - logoGraphic:getWidth() * 4 / 2,
                15, 0, SF, SF)
  end
end

function world:drawGround()
  -- Scrolls ground to the left
  love.graphics.draw(groundGraphic, world.groundPosX, world.groundTop, 0, SF, SF)
  love.graphics.draw(groundGraphic, world.groundPosX + world.groundWidth,world.groundTop,0,SF,SF)

  -- Stop scrolling if dead
  if globalState == States.Death then world.groundPosX = world.groundPosX
  else world.groundPosX = world.groundPosX - 5 -- Scroll left
  end

  -- Infinite scrolling
  if world.groundPosX <= -world.groundWidth then world.groundPosX = 0 end
end
