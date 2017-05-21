require "pieces"
local testMap = require "testMap"

Color_Chess1 = {245,222,179, 255}
Color_Chess2 = {210,105,30, 255}
Color_Highlight = {255,0,255,155}

--local selectedPiece 
local tileset
function love.load()
	tileset = love.graphics.newImage("gfx/Tileset.png")
	whiteHorse = love.graphics.newQuad(96, 32, 32, 32, tileset:getDimensions())
	whiteKing = love.graphics.newQuad(0, 32, 32, 32, tileset:getDimensions())
	-- Load map
	loadMap(testMap)
end

function loadMap(map)
	currMap = map.layers[1].data
	roomWidth = map.width
	roomHeight = map.height
end

function SelectPiece(x,y)
	if IsWhitePiece(GetMapPiece(x,y)) then
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
	else 
		if selectedPiece.type == PIECE_WHITE_KNIGHT then 
			if CanHorseMoveToPos( GridPosX,GridPosY,
			selectedPiece.x ,selectedPiece.y ,currMap) then
				selectedPiece = MovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil 
			end
		elseif selectedPiece.type == PIECE_WHITE_KING then 
			if CanKingMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,currMap) then
				selectedPiece = MovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil 
			end
		else
			selectedPiece = nil 
		end

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

			if(IsNotEmptySpace(x,y)) then
				if((x+y)%2 > 0) then
					love.graphics.setColor(Color_Chess1)
				else
					love.graphics.setColor(Color_Chess2)
				end

				love.graphics.rectangle("fill", x*32, y*32, 32, 32)
				if GetMapPiece(x,y)==3 then
					love.graphics.setColor(0,100,255)
					love.graphics.circle("fill", 16+x*32, 16+y*32, 10)
				elseif GetMapPiece(x,y)==PIECE_WHITE_KING then
					love.graphics.setColor(255,255,255)
					love.graphics.draw(tileset,whiteKing,x*32,y*32)
				elseif GetMapPiece(x,y)==PIECE_WHITE_KNIGHT then
					love.graphics.setColor(255,255,255)
					love.graphics.draw(tileset,whiteHorse,x*32,y*32)

--					love.graphics.circle("fill", 16+x*32, 16+y*32, 10)
				end
				if selectedPiece ~= nil then
					if selectedPiece.type == PIECE_WHITE_KNIGHT then 
						if CanHorseMoveToPos(x,y,selectedPiece.x,selectedPiece.y,currMap) then
							love.graphics.setColor(Color_Highlight)
							love.graphics.rectangle("fill", x*32, y*32, 32, 32)
						end
					elseif selectedPiece.type == PIECE_WHITE_KING then 
						if CanKingMoveToPos(x,y,selectedPiece.x,selectedPiece.y,currMap) then
							love.graphics.setColor(Color_Highlight)
							love.graphics.rectangle("fill", x*32, y*32, 32, 32)
						end
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