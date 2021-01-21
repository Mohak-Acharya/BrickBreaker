
push = require 'push'


Class = require 'class'

require 'Paddle'
require 'brick'
require 'Ball'

local brick_x=0
local brick_y=0
local bricks = {}

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

function love.load()
   
    love.graphics.setDefaultFilter('nearest', 'nearest')

    love.window.setTitle('Pong Single Player')

    math.randomseed(os.time())

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    sounds = {
        ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['game_lost'] = love.audio.newSource('sounds/smb_mariodie.wav', 'static'),
        ['win'] = love.audio.newSource('sounds/win.wav','static')
    }
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true,
        canvas = false
    })

    player1 = Paddle(VIRTUAL_WIDTH/2-40, VIRTUAL_HEIGHT-15, 80, 5)

    
  	for j = 1,5
  	do
    for i = 1,8
	do 
   		 table.insert(bricks, brick(brick_x,brick_y))
   		 brick_x = brick_x + 55
	end
	brick_x = 0
	brick_y = brick_y + 15
	end
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    
    winningPlayer = 0

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end
local a =0 
function love.update(dt)
	a=0
	for k,v in pairs(bricks) do
		if v.exist == false
			then	a = a + 1
		end
	end
	if a == 40
		then
			gameState = 'done'
	end
    if gameState == 'serve' then
        
        ball.dy = math.random(2) and math.random(100,180) or -math.random(100,180)
        ball.dx = math.random(2) and math.random(100,180) or -math.random(100,180)
    elseif gameState == 'play' then
        
        if ball:collides(player1) then
        	ball.y = player1.y - 10
            ball.dy = -ball.dy * 1.03
            

            if ball.dy < 0 then
                ball.dy = -math.random(120, 180)
            else
                ball.dy = math.random(120, 180)
            end

            sounds['paddle_hit']:play()
        end
        

        if ball.y <= 0 then
            ball.y = 0
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end

        if ball.x <= 0 then
            ball.x = 0
            ball.dx = -ball.dx
            sounds['wall_hit']:play()
        end
        if ball.x >= VIRTUAL_WIDTH-2 then
            ball.x = VIRTUAL_WIDTH-2
            ball.dx = -ball.dx
            sounds['wall_hit']:play()
        end
       
            
        if ball.y>=VIRTUAL_HEIGHT-2 then
                
            gameState = 'lose' 
            ball:reset()
        end
    end      
       
   

   
    if love.keyboard.isDown('left') then
        player1.dx = -PADDLE_SPEED
    elseif love.keyboard.isDown('right') then
        player1.dx = PADDLE_SPEED
    else
        player1.dx = 0
    end
    for a,b in pairs(bricks) 
    do
    b:collision(b,ball.x,ball.y)
   	end
    
    if gameState == 'play' then
        ball:update(dt)
    end

    player1:update(dt)
end
    


function love.keypressed(key)
    
    if key == 'escape' then
        
        love.event.quit()
    
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' or gameState == 'lose' then
            gameState = 'serve'
        elseif gameState == 'serve' then
            gameState = 'play'
        elseif gameState == 'done' then
            
            gameState = 'serve'

            ball:reset()
           
        end
    end
end

local count =0
local wincount =0  

function love.draw()
    
    push:start()

    love.graphics.clear(40, 45, 52, 255)
    
    
    if gameState == 'start' then
        count =0
        wincount =0
        love.graphics.setFont(smallFont)
        love.graphics.printf('Welcome to Pong!', 0, 80, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to begin!', 0, 90, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'serve' then
       count =0
       wincount =0
        love.graphics.setFont(smallFont)
        
        love.graphics.printf('Press Enter to begin!', 0, 90, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'lose' then
    	if count == 0 then
    		sounds['game_lost']:play()
    		count = count + 1
    	end
    	wincount =0
    	for k,v in pairs(bricks) do
    		v.exist=true
    	end
       love.graphics.printf('You Lost! Try AGAIN! Press Enter to continue', 0, 90, VIRTUAL_WIDTH, 'center')

    elseif gameState == 'done' then
    	if wincount == 0 then
    		sounds['win']:play()
    		wincount = wincount + 1
    	end
        count =0
        love.graphics.setFont(largeFont)

        love.graphics.printf('You WIN!', 0, 90, VIRTUAL_WIDTH, 'center')
    
    end
    for a,b in pairs(bricks) 
	do 
		 
   		 b:render()
   		
	end
    
   
    
    player1:render()
    ball:render()
    push:finish()
end



