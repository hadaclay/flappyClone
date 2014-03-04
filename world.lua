world = {}

function world:drawGround()
  love.graphics.draw(groundGraphic, groundPosX,
                     love.graphics.getHeight() - groundHeight - 10, 0, SF, SF)

  love.graphics.draw(groundGraphic, groundPosX + groundWidth,
                       love.graphics.getHeight() - groundHeight - 10, 0, SF, SF)

  groundPosX = groundPosX - 5 -- Scroll left

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

