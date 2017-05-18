
local testMap = require "testMap"

local horses

function love.load()
	-- Load map
	loadMap()
end

function loadMap()
	map = testMap.layers[1].data
	roomWidth = testMap.width
	roomHeight = testMap.height
end

function love.keypressed(key)
	-- Exit test
	if key == "escape" then
		love.event.quit()
	end
end

function love.update(dt)

--	map:update(dt)
end

function love.draw()
	love.graphics.setColor(0,111,111)
	love.graphics.rectangle("fill",0,0,1000,1000)

	for x = 0, roomWidth-1 do
		for y = 0, roomHeight-1 do
			if(map[1+x+y*25]>0) then
				if((x+y)%2 > 0) then
					love.graphics.setColor(0,0,0)
				else
					love.graphics.setColor(255,255,255)
				end

				love.graphics.rectangle("fill", x*32, y*32, 31, 31)
				if map[1+x+y*25]==3 then
					love.graphics.setColor(0,100,255)
					love.graphics.circle("fill", 16+x*32, 16+y*32, 10)
				elseif map[1+x+y*25]==10 then
					love.graphics.setColor(255,0,0)
					love.graphics.circle("fill", 16+x*32, 16+y*32, 10)
				end
			end
		--	love.graphics.print(map[x+y*20] ,x*20,y*20)
		end
	end
end

function CanHorseMoveToPos(posX,posY,horseX,horseY,map)
	local dist
--	for x = 0, 24 do
--		for y = 0, 14 do
			if map[1+posX+posY*testMap.width]>0 then
				if x ~= horseX and y ~= horseX then
					dist = math.abs( x-horseX)
					dist = dist + math.abs( y-horseY)
					if(dist == 3) then
						return true
					end
				end
			end
--		end
--	end
	return true
end