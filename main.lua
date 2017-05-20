
local testMap = require "testMap"

local selectedPiece 
local tileset
function love.load()
	tileset = love.graphics.newImage("gfx/Tileset.png")
	horseQuad = love.graphics.newQuad(96, 32, 32, 32, tileset:getDimensions())
	-- Load map
	loadMap(testMap)
end

function loadMap(map)
	currMap = map.layers[1].data
	roomWidth = map.width
	roomHeight = map.height
end

function SelectPiece(x,y)
	if GetMapPiece(x,y) >6 and GetMapPiece(x,y) <13 then
		selectedPiece = {}
		selectedPiece.type = GetMapPiece(x,y) 
		selectedPiece.x =x
		selectedPiece.y =y
	end
	return nil
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
	if selectedPiece == nil then
		SelectPiece(GridPosX,GridPosY)
	elseif CanHorseMoveToPos( GridPosX,GridPosY,
		selectedPiece.x ,selectedPiece.y ,currMap) then
		print(GridPosY)
		print(selectedPiece.y)
		SetMapPiece(selectedPiece.x,selectedPiece.y,0)
		SetMapPiece(GridPosX,GridPosY,10)
		selectedPiece.x = GridPosX
		selectedPiece.y = GridPosY
	else
		selectedPiece = nil 
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

				love.graphics.rectangle("fill", x*32, y*32, 32, 32)
				if GetMapPiece(x,y)==3 then
					love.graphics.setColor(0,100,255)
					love.graphics.circle("fill", 16+x*32, 16+y*32, 10)
				elseif GetMapPiece(x,y)==10 then
					love.graphics.setColor(255,255,255)
					love.graphics.draw(tileset,horseQuad,x*32,y*32)

--					love.graphics.circle("fill", 16+x*32, 16+y*32, 10)
				end
				if selectedPiece ~= nil then
					if CanHorseMoveToPos(x,y,selectedPiece.x,selectedPiece.y,currMap) then
						love.graphics.setColor(255,255,0,122)
						love.graphics.rectangle("fill", x*32, y*32, 32, 32)
					end
				end
			end
		end
	end
	local mouseX,mouseY  = love.mouse.getPosition()
	love.graphics.setColor(0,0,0)
	if selectedPiece ~= nil then
		love.graphics.print(selectedPiece.x,10,10)
		love.graphics.print(selectedPiece.y,30,10)
	end
	love.graphics.print(math.floor(mouseX/32),10,40)
	love.graphics.print(math.floor(mouseY/32),30,40)
end

function CanHorseMoveToPos(posX,posY,horseX,horseY,map)
	local dist
	if GetMapPiece(posX,posY) ~= nil and GetMapPiece(posX,posY) > 0 then

		if posX ~= horseX and posY ~= horseY then
			dist = math.abs( posX-horseX)
			dist = dist + math.abs( posY-horseY)
			if(dist == 3) then
				return true
			end
		end
	end
	return false
end