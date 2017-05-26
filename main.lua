require "pieces"
require "map"
testMap = require "testMap"
testMap2 = require "testMap2"
testMap3 = require "testMap3"
testMap4 = require "testMap4"

Color_Background = {0,0,0, 255}
Color_Chess1 = {245,222,179, 255}
Color_Chess2 = {210,105,30, 255}
Color_Highlight = {255,0,255,177}
Color_SelectedPiece = {0,0,0,155}

--local selectedPiece 
local tileset
function love.load()
	tileset = love.graphics.newImage("gfx/Tileset.png")
	currLevel = 1
	-- Load map
	loadMap(testMap)
end

function GetTileset()
	return tileset
end

function love.mousepressed( mouseX, mouseY, button, istouch )
	local GridPosX = math.floor(mouseX/32)
	local GridPosY = math.floor(mouseY/32)
	if selectedPiece == nil then
		SelectPiece(GridPosX,GridPosY)
	else 
		if selectedPiece.type == PIECE_WHITE_KNIGHT then 
			if CanHorseMoveToPos( GridPosX,GridPosY,
			selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
				PlayerMovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil 
			end
		elseif selectedPiece.type == PIECE_WHITE_KING then 
			if CanKingMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
				PlayerMovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil 
			end
		elseif selectedPiece.type == PIECE_WHITE_QUEEN then 
			if CanQueenMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
				selectedPiece = PlayerMovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil 
			end
		elseif selectedPiece.type == PIECE_WHITE_BISHOP then 
			if CanBishopMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
				PlayerMovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil
			end
		elseif selectedPiece.type == PIECE_WHITE_ROOK then 
			if CanRookMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
				PlayerMovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil
			end
		elseif selectedPiece.type == PIECE_WHITE_PAWN then 
			if CanPawnMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
				PlayerMovePieceToPos(selectedPiece,GridPosX,GridPosY)
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
	if key == "z" then
		Undo()
	end
	if key == "x" then
		Redo()
	end
	if key == "r" then
		Reset()
	end
end

function love.draw()
	love.graphics.clear(Color_Background)

	DrawMap(currMap)
	
	local mouseX,mouseY  = love.mouse.getPosition()
	local mouseMapX = math.floor(mouseX/32)
	local mouseMapY = math.floor(mouseY/32)
	love.graphics.setColor(255,255,255)
	if IsBlackPiece( GetMapPiece(mouseMapX,mouseMapY) ) then
		love.graphics.print("true",30,40)
	else
		love.graphics.print("false",30,40)
	end
	
end

