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
  groundHeight = groundGraphic:getHeight() * SF,
  groundTop = love.graphics.getHeight() - groundGraphic:getHeight() - 10,
  groundPosX = 0,      -- Used for ground scrolling

  scrollSpeed = 5,
  pipeWidth = pipeGraphic:getWidth(),
  pipeHeight = pipeGraphic:getHeight() * SF,
  pipeXDistance = 400, -- Distance between pipes
  pipeYDistance = 150, -- Distance between top and bottom pipe
  pipeYMin = -570,     -- The highest a top pipe can be
  pipeYMax = -390,     -- and the lowest
}

-- 1st Pipe
pipe1x1 = 450
pipe1x2 = pipe1x1
pipe1y1 = math.random(world.pipeYMax, world.pipeYMin)
pipe1y2 = pipe1y1 + world.pipeHeight + world.pipeYDistance
pipe1ScoreRectX = pipe1x1 + world.pipeWidth
pipe1ScoreRectY = pipe1y1 + world.pipeHeight

-- 2nd Pipe
pipe2x1 = pipe1x1 + world.pipeXDistance
pipe2x2 = pipe2x1
pipe2y1 = math.random(world.pipeYMax, world.pipeYMin)
pipe2y2 = pipe2y1 + world.pipeHeight + world.pipeYDistance
pipe2ScoreRectX = pipe2x1 + world.pipeWidth
pipe2ScoreRectY = pipe2y1 + world.pipeHeight

-- 3rd Pipe
pipe3x1 = pipe2x1 + world.pipeXDistance
pipe3x2 = pipe3x1
pipe3y1 = math.random(world.pipeYMax, world.pipeYMin)
pipe3y2 = pipe3y1 + world.pipeHeight + world.pipeYDistance
pipe3ScoreRectX = pipe3x1 + world.pipeWidth
pipe3ScoreRectY = pipe3y1 + world.pipeHeight

-- Update and draw pipes
function world:spawnPipes()
  pipe1x1 = pipe1x1 - world.scrollSpeed
  pipe1x2 = pipe1x2 - world.scrollSpeed
  pipe1ScoreRectX = pipe1ScoreRectX - world.scrollSpeed

  pipe2x1 = pipe2x1 - world.scrollSpeed
  pipe2x2 = pipe2x2 - world.scrollSpeed
  pipe2ScoreRectX = pipe2ScoreRectX - world.scrollSpeed

  pipe3x1 = pipe3x1 - world.scrollSpeed
  pipe3x2 = pipe3x2 - world.scrollSpeed
  pipe3ScoreRectX = pipe3ScoreRectX - world.scrollSpeed

  -- If Pipes go out of bounds, move past last pipe
  if pipe1x1 < 0 - pipeGraphic:getWidth() * SF then
    pipe1x1 = pipe3x1 + world.pipeXDistance
    pipe1x2 = pipe3x2 + world.pipeXDistance
    pipe1y1 = math.random(world.pipeYMax, world.pipeYMin)
    pipe1y2 = pipe1y1 + (pipeGraphic:getHeight() * SF) + world.pipeYDistance
    pipe1ScoreRectX = pipe1x1 + world.pipeWidth
    pipe1ScoreRectY = pipe1y1 + world.pipeHeight
  end

  if pipe2x1 < 0 - pipeGraphic:getWidth() * SF then
    pipe2x1 = pipe1x1 + world.pipeXDistance
    pipe2x2 = pipe1x2 + world.pipeXDistance
    pipe2y1 = math.random(world.pipeYMax, world.pipeYMin)
    pipe2y2 = pipe2y1 + (pipeGraphic:getHeight() * SF) + world.pipeYDistance
    pipe2ScoreRectX = pipe2x1 + world.pipeWidth
    pipe2ScoreRectY = pipe2y1 + world.pipeHeight
  end

  if pipe3x1 < 0 - pipeGraphic:getWidth() * SF then
    pipe3x1 = pipe2x1 + world.pipeXDistance
    pipe3x2 = pipe2x2 + world.pipeXDistance
    pipe3y1 = math.random(world.pipeYMax, world.pipeYMin)
    pipe3y2 = pipe3y1 + (pipeGraphic:getHeight() * SF) + world.pipeYDistance
    pipe3ScoreRectX = pipe3x1 + world.pipeWidth
    pipe3ScoreRectY = pipe3y1 + world.pipeHeight
  end
end

function world:resetPipes()
  -- 1st Pipe
  pipe1x1 = 450
  pipe1x2 = pipe1x1
  pipe1y1 = math.random(world.pipeYMax, world.pipeYMin)
  pipe1y2 = pipe1y1 + world.pipeHeight + world.pipeYDistance
  pipe1ScoreRectX = pipe1x1 + world.pipeWidth
  pipe1ScoreRectY = pipe1y1 + world.pipeHeight

  -- 2nd Pipe
  pipe2x1 = pipe1x1 + world.pipeXDistance
  pipe2x2 = pipe2x1
  pipe2y1 = math.random(world.pipeYMax, world.pipeYMin)
  pipe2y2 = pipe2y1 + world.pipeHeight + world.pipeYDistance
  pipe2ScoreRectX = pipe2x1 + world.pipeWidth
  pipe2ScoreRectY = pipe2y1 + world.pipeHeight

  -- 3rd Pipe
  pipe3x1 = pipe2x1 + world.pipeXDistance
  pipe3x2 = pipe3x1
  pipe3y1 = math.random(world.pipeYMax, world.pipeYMin)
  pipe3y2 = pipe3y1 + world.pipeHeight + world.pipeYDistance
  pipe3ScoreRectX = pipe3x1 + world.pipeWidth
  pipe3ScoreRectY = pipe3y1 + world.pipeHeight
end

function world:updateCollision()
  -- Player collision with pipes
  -- 1st Pipe
  if CheckCollision(player.x, player.y, player.width, player.height * SF,
               pipe1x1, pipe1y1, world.pipeWidth, world.pipeHeight - 5) then
    globalState = States.Death
    player.score = 0
  elseif CheckCollision(player.x, player.y, player.width, player.height * SF,
               pipe1x2, pipe1y2, world.pipeWidth, world.pipeHeight + 5) then
    globalState = States.Death
    player.score = 0

  -- If player passes between pipes, increment score
  elseif CheckCollision(player.x, player.y, player.width / 10, player.height * SF,
               pipe1ScoreRectX, pipe1ScoreRectY, 1, world.pipeYDistance) then
    player.score = player.score + 1
  end

  -- 2nd pipe
  if CheckCollision(player.x, player.y, player.width, player.height * SF,
               pipe2x1, pipe2y1, world.pipeWidth, world.pipeHeight - 5) then
    globalState = States.Death
    player.score = 0
  elseif CheckCollision(player.x, player.y, player.width, player.height * SF,
               pipe2x2, pipe2y2, world.pipeWidth, world.pipeHeight + 5) then
    globalState = States.Death
    player.score = 0

  -- If player passes between pipes, increment score
  elseif CheckCollision(player.x, player.y, player.width / 10, player.height * SF,
               pipe2ScoreRectX, pipe2ScoreRectY, 1, world.pipeYDistance) then
    player.score = player.score + 1
  end

  -- 3rd pipe
  if CheckCollision(player.x, player.y, player.width, player.height * SF,
               pipe3x1, pipe3y1, world.pipeWidth, world.pipeHeight - 5) then
    globalState = States.Death
    player.score = 0
  elseif CheckCollision(player.x, player.y, player.width, player.height * SF,
               pipe3x2, pipe3y2, world.pipeWidth, world.pipeHeight + 5) then
    globalState = States.Death
    player.score = 0

  -- If player passes between pipes, increment score
  elseif CheckCollision(player.x, player.y, player.width / 10, player.height * SF,
               pipe3ScoreRectX, pipe3ScoreRectY, 1, world.pipeYDistance) then
    player.score = player.score + 1
  end
end

function world:update(dt)
  if globalState == States.Playing then
    world:spawnPipes()
    world:updateCollision()
  end

  if globalState == States.NotPlaying then
    world:resetPipes()
  end
end

function drawDebugRect(x, y, w, h)
  love.graphics.setColor(255, 0, 0, 255)
  love.graphics.rectangle("fill", x, y, w, h)
  love.graphics.reset()
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

    drawText(player.score,love.graphics.getWidth()/2,love.graphics.getHeight()/4)
  end

  if globalState == States.Death then
    love.graphics.draw(pipeFlipGraphic, pipe1x1, pipe1y1, 0, SF, SF)
    love.graphics.draw(pipeGraphic, pipe1x2, pipe1y2, 0, SF, SF)

    love.graphics.draw(pipeFlipGraphic, pipe2x1, pipe2y1, 0 ,SF, SF)
    love.graphics.draw(pipeGraphic, pipe2x2, pipe2y2, 0 ,SF, SF)

    love.graphics.draw(pipeFlipGraphic, pipe3x1, pipe3y1, 0 ,SF, SF)
    love.graphics.draw(pipeGraphic, pipe3x2, pipe3y2, 0 ,SF, SF)

    drawText("Score: " .. player.score, love.graphics.getWidth() / 2 - 70,
             love.graphics.getHeight() / 4 + 36)
    drawText("High Score: "..player.highestScore, love.graphics.getWidth() / 3 - 5,
             love.graphics.getHeight() / 4 + 72)
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
