world = {}

function world:load() -- Variables for ground scrolling
  groundWidth = groundGraphic:getWidth() * SF
  groundHeight = groundGraphic:getHeight()
  groundTop = love.graphics.getHeight() - groundHeight - 10

  groundPosX = 0
end

function world:drawGround()
  -- Scrolls ground to the left
  love.graphics.draw(groundGraphic, groundPosX, groundTop, 0, SF, SF)
  love.graphics.draw(groundGraphic, groundPosX + groundWidth,groundTop,0,SF,SF)

  -- Stop scrolling if dead
  if globalState == States.Death then groundPosX = groundPosX
  else groundPosX = groundPosX - 5 -- Scroll left
  end

  -- Infinite scrolling
  if groundPosX <= -groundWidth then groundPosX = 0 end
end

function world:draw()
  love.graphics.draw(bgGraphic, 0, 0, 0, SF, SF)
  world:drawGround()

  if globalState == States.NotPlaying then
    love.graphics.draw(logoGraphic,
                love.graphics.getWidth() / 2 - logoGraphic:getWidth() * 4 / 2,
                15, 0, SF, SF)
  end
end
