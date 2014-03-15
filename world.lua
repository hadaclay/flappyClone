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
  groundPosX = 0,      -- Used for ground scrolling

  scrollSpeed = 5,
  pipeXDistance = 400, -- Distance between pipes
  pipeYDistance = 150, -- Distance between top and bottom pipe
  pipeYMin = -570,     -- The highest a top pipe can be
  pipeYMax = -390,     -- and the lowest
}

-- 1st Pipe
pipe1x1 = 450
pipe1x2 = pipe1x1
pipe1y1 = math.random(world.pipeYMax, world.pipeYMin)
pipe1y2 = pipe1y1 + (pipeGraphic:getHeight() * SF) + world.pipeYDistance

-- 2nd Pipe
pipe2x1 = pipe1x1 + world.pipeXDistance
pipe2x2 = pipe2x1
pipe2y1 = math.random(world.pipeYMax, world.pipeYMin)
pipe2y2 = pipe2y1 + (pipeGraphic:getHeight() * SF) + world.pipeYDistance

-- 3rd Pipe
pipe3x1 = pipe2x1 + world.pipeXDistance
pipe3x2 = pipe3x1
pipe3y1 = math.random(world.pipeYMax, world.pipeYMin)
pipe3y2 = pipe3y1 + (pipeGraphic:getHeight() * SF) + world.pipeYDistance

-- Update and draw pipes
function world:spawnPipes()
  pipe1x1 = pipe1x1 - world.scrollSpeed
  pipe1x2 = pipe1x2 - world.scrollSpeed

  pipe2x1 = pipe2x1 - world.scrollSpeed
  pipe2x2 = pipe2x2 - world.scrollSpeed

  pipe3x1 = pipe3x1 - world.scrollSpeed
  pipe3x2 = pipe3x2 - world.scrollSpeed

  -- If Pipes go out of bounds, move past last pipe
  if pipe1x1 < 0 - pipeGraphic:getWidth() * SF then
    pipe1x1 = pipe3x1 + world.pipeXDistance
    pipe1x2 = pipe3x2 + world.pipeXDistance
    pipe1y1 = math.random(world.pipeYMax, world.pipeYMin)
    pipe1y2 = pipe1y1 + (pipeGraphic:getHeight() * SF) + world.pipeYDistance
  end

  if pipe2x1 < 0 - pipeGraphic:getWidth() * SF then
    pipe2x1 = pipe1x1 + world.pipeXDistance
    pipe2x2 = pipe1x2 + world.pipeXDistance
    pipe2y1 = math.random(world.pipeYMax, world.pipeYMin)
    pipe2y2 = pipe2y1 + (pipeGraphic:getHeight() * SF) + world.pipeYDistance
  end

  if pipe3x1 < 0 - pipeGraphic:getWidth() * SF then
    pipe3x1 = pipe2x1 + world.pipeXDistance
    pipe3x2 = pipe2x2 + world.pipeXDistance
    pipe3y1 = math.random(world.pipeYMax, world.pipeYMin)
    pipe3y2 = pipe3y1 + (pipeGraphic:getHeight() * SF) + world.pipeYDistance
  end
end

function world:update(dt)
  if globalState == States.Playing then world:spawnPipes() end
end

function world:draw()
  love.graphics.draw(bgGraphic, 0, 0, 0, SF, SF)
  if globalState == States.Playing then
    love.graphics.draw(pipeFlipGraphic, pipe1x1, pipe1y1, 0, SF, SF)
    love.graphics.draw(pipeGraphic, pipe1x2, pipe1y2, 0, SF, SF)

    love.graphics.draw(pipeFlipGraphic, pipe2x1, pipe2y1, 0 ,SF, SF)
    love.graphics.draw(pipeGraphic, pipe2x2, pipe2y2, 0 ,SF, SF)

    love.graphics.draw(pipeFlipGraphic, pipe3x1, pipe3y1, 0 ,SF, SF)
    love.graphics.draw(pipeGraphic, pipe3x2, pipe3y2, 0 ,SF, SF)
  end
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
  else world.groundPosX = world.groundPosX - world.scrollSpeed -- Scroll left
  end

  -- Infinite scrolling
  if world.groundPosX <= -world.groundWidth then world.groundPosX = 0 end
end
