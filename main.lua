-- Scores
local scorePlayer1 = 0
local scorePlayer2 = 0

-- Time
local timer = 30

-- Game End
local gameEnded = false

-- Paddles
local paddle = {
    x = 20,
    y = love.graphics.getHeight() / 2 - 50,
    width = 10,
    height = 100,
    speed = 300
}

local opponent = {
    x = love.graphics.getWidth() - 30,
    y = love.graphics.getHeight() / 2 - 50,
    width = 10,
    height = 100,
    speed = 300
}

-- Ball
local ball = {
    x = love.graphics.getWidth() / 2,
    y = love.graphics.getHeight() / 2,
    radius = 10,
    speedX = 200,
    speedY = 200
}

-- Scoreboard Font
local scoreboardFont = love.graphics.newFont(30)

-- Reset Ball
function resetBall()
    ball.x = love.graphics.getWidth() / 2
    ball.y = love.graphics.getHeight() / 2
    ball.speedX = 200
    ball.speedY = 200
end

-- Time Check
function checkGameEnd()
    if timer <= 0 then
        gameEnded = true
        timer = 0
    end
end

function love.load()
    love.window.setTitle("Pong Game")
    love.window.setMode(800, 600, {
        resizable = false,
        fullscreen = false
    })

    checkGameEnd()
    resetBall()
end


function love.keypressed(key)
    if key == "space" then
        if not gameStarted and not gameEnded then
            gameStarted = true
            ball.speedX = 200
            ball.speedY = 200
        elseif gameEnded then
            gameStarted = false
            gameEnded = false
            scorePlayer1 = 0
            scorePlayer2 = 0
            timer = 30
            resetBall()
        end
    end
end

    



function love.update(dt)
    

-- P1 Movement
    if love.keyboard.isDown("w") and paddle.y > 0 then
        paddle.y = paddle.y - paddle.speed * dt
    elseif love.keyboard.isDown("s") and paddle.y < love.graphics.getHeight() - paddle.height then
        paddle.y = paddle.y + paddle.speed * dt
    end

    -- P2 Movement
    if love.keyboard.isDown("up") and opponent.y > 0 then
        opponent.y = opponent.y - opponent.speed * dt
    elseif love.keyboard.isDown("down") and opponent.y < love.graphics.getHeight() - opponent.height then
        opponent.y = opponent.y + opponent.speed * dt
    end

    
    if gameStarted and not gameEnded then
        ball.x = ball.x + ball.speedX * dt
        ball.y = ball.y + ball.speedY * dt

        -- Ball x Paddles
        if ball.x - ball.radius < paddle.x + paddle.width and
           ball.y + ball.radius > paddle.y and
           ball.y - ball.radius < paddle.y + paddle.height then
            ball.speedX = -ball.speedX
        elseif ball.x + ball.radius > opponent.x and
               ball.y + ball.radius > opponent.y and
               ball.y - ball.radius < opponent.y + opponent.height then
            ball.speedX = -ball.speedX
        end

        -- Ball x Edges
        if ball.y - ball.radius < 0 or ball.y + ball.radius > love.graphics.getHeight() then
            ball.speedY = -ball.speedY
        end

        -- P2 Scores
        if ball.x - ball.radius < 0 then
            scorePlayer2 = scorePlayer2 + 1
            resetBall()
        end

        -- P1 Scores
        if ball.x + ball.radius > love.graphics.getWidth() then
            scorePlayer1 = scorePlayer1 + 1
            resetBall()
        end
    elseif not gameStarted and not gameEnded then
        

        ball.speedX = 0
        ball.speedY = 0
    end

    -- Update Time
    if not gameEnded and gameStarted then
        timer = timer - dt
        if timer <= 0 then
            timer = 0
            gameEnded = true
        end
    end
end
function love.draw()
    -- Background
    love.graphics.setColor(0.1, 0.1, 0.1)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())

    
    if not gameEnded then
        love.graphics.setColor(1, 1, 1)
        love.graphics.circle("fill", ball.x, ball.y, ball.radius)
        love.graphics.rectangle("fill", paddle.x, paddle.y, paddle.width, paddle.height)
        love.graphics.rectangle("fill", opponent.x, opponent.y, opponent.width, opponent.height)
    end

    -- Scoreboard and Time
    love.graphics.setFont(scoreboardFont)
    love.graphics.setColor(1, 1, 1)
    local scoreWidth = scoreboardFont:getWidth(scorePlayer1) -- Oyuncu 1 skoru genişliği
    local timeWidth = scoreboardFont:getWidth(math.floor(timer)) -- Süre genişliği
    local scoreHeight = scoreboardFont:getHeight() -- Skor yüksekliği

    local scoreboardX = love.graphics.getWidth() / 2 - (scoreWidth + timeWidth) / 2
    local scoreboardY = 20

    local scorePlayer1X = scoreboardX
    local timeX = scoreboardX + scoreWidth + 40
    local scorePlayer2X = timeX + timeWidth + 40

    love.graphics.print(scorePlayer1, scorePlayer1X, scoreboardY)
    love.graphics.print(math.floor(timer), timeX, scoreboardY)
    love.graphics.print(scorePlayer2, scorePlayer2X, scoreboardY)

    -- Winner Screen
    if gameEnded then
        love.graphics.setColor(1, 1, 1)
        local winnerText
        if scorePlayer1 > scorePlayer2 then
            winnerText = "Player 1 Wins"
        elseif scorePlayer2 > scorePlayer1 then
            winnerText = "Player 2 Wins"
        else
            winnerText = "DRAW"
        end

        local winnerWidth = scoreboardFont:getWidth(winnerText)
        local winnerHeight = scoreboardFont:getHeight()

        love.graphics.print(winnerText, love.graphics.getWidth() / 2 - winnerWidth / 2, love.graphics.getHeight() / 2 - winnerHeight / 2)
    else
        
	-- Start Instructions
        if not gameStarted then
            love.graphics.setColor(1, 1, 1)
            local startText = "Press SPACE to Start"
            local startWidth = scoreboardFont:getWidth(startText)
            local startHeight = scoreboardFont:getHeight()

            love.graphics.print(startText, love.graphics.getWidth() / 2 - startWidth / 2, love.graphics.getHeight() / 2 - startHeight / 2)
        end
    end
end

