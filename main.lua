
local testMap = require "testMap"

local selectedPiece={}

function love.load()
	-- Load map
	loadMap()
end

function loadMap()
	currMap = testMap.layers[1].data
	roomWidth = testMap.width
	roomHeight = testMap.height
	for x = 0, 24 do		
		for y = 0, 14 do
			if GetMapPiece(x,y) ==10 then
				selectedPiece.x = x
				selectedPiece.y = y
			end
		end
	end
end

function GetMapPiece(x,y)
	return currMap[(1+x+y*testMap.width)]
end

function SetMapPiece(x,y,piece)
	currMap[(1+x+y*testMap.width)] = piece
end

function love.mousepressed( mouseX, mouseY, button, istouch )
	local GridPosX = math.floor(mouseX/32)
	local GridPosY = math.floor(mouseY/32)
	if CanHorseMoveToPos( GridPosX,GridPosY,
		selectedPiece.x,selectedPiece.y,currMap) then
		SetMapPiece(selectedPiece.x,selectedPiece.y,0)
		SetMapPiece(GridPosX,GridPosY,10)
		selectedPiece.x = GridPosX
		selectedPiece.y = GridPosY
	end
end

function love.keypressed(key)
	-- Exit test
	if key == "escape" then
		love.event.quit()
	end
end



function love.draw()
	love.graphics.setColor(0,111,111)
	love.graphics.rectangle("fill",0,0,1000,1000)

	for x = 0, roomWidth-1 do
		for y = 0, roomHeight-1 do
			if(GetMapPiece(x,y)>0) then
				if((x+y)%2 > 0) then
					love.graphics.setColor(0,0,0)
				else
					love.graphics.setColor(255,255,255)
				end

				love.graphics.rectangle("fill", x*32, y*32, 31, 31)
				if GetMapPiece(x,y)==3 then
					love.graphics.setColor(0,100,255)
					love.graphics.circle("fill", 16+x*32, 16+y*32, 10)
				elseif GetMapPiece(x,y)==10 then
					love.graphics.setColor(255,0,0)
					love.graphics.circle("fill", 16+x*32, 16+y*32, 10)
				end
			end
		end
	end
end

function CanHorseMoveToPos(posX,posY,horseX,horseY,map)
	local dist
	if GetMapPiece(posX,posY) ~= nil and GetMapPiece(posX,posY) > 0 then
		if x ~= horseX and y ~= horseX then
			dist = math.abs( posX-horseX)
			dist = dist + math.abs( posY-horseY)
			if(dist == 3) then
				return true
			end
		end
	end
	return false
end