brick = Class{}

local BRICK_IMAGE = love.graphics.newImage('brick.jpg')

function brick:init(x, y)
    self.x = x
    self.y = y
    self.timer = 0
    self.exist = true

    self.width = 382
    self.height = 64
end

function brick:update(dt)
	if self.exist == false 
		then
    	self.timer = self.timer + dt
	end
end

function brick:collision(self, ball_x, ball_y)
	if ball_x + 2 >= self.x and ball_x + 2 <= self.x + 50 and ((ball_y - self.y <= 2 and ball_y - self.y >= 0) or (ball_y - self.y >= -2 and ball_y - self.y <=0) )
		then
			if self.exist == true then
				sounds['wall_hit']:play()
			end	
			self.exist = false
	end
end 	


function brick:render()
	if(self.exist == true) then
    love.graphics.draw(BRICK_IMAGE, self.x, self.y)
	end
end

