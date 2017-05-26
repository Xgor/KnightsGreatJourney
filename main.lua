require "pieces"
require "map"
testMap = require "testMap"

Color_Background = {0,0,0, 255}
Color_Chess1 = {245,222,179, 255}
Color_Chess2 = {210,105,30, 255}
Color_Highlight = {255,0,255,177}
Color_SelectedPiece = {0,0,0,155}

--local selectedPiece 
local tileset
function love.load()
	tileset = love.graphics.newImage("gfx/Tileset.png")
	whiteHorse = love.graphics.newQuad(96, 32, 32, 32, tileset:getDimensions())
	whiteKing = love.graphics.newQuad(0, 32, 32, 32, tileset:getDimensions())
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
				selectedPiece = MovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil 
			end
		elseif selectedPiece.type == PIECE_WHITE_KING then 
			if CanKingMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
				selectedPiece = MovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil 
			end
		elseif selectedPiece.type == PIECE_WHITE_QUEEN then 
			if CanQueenMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
				selectedPiece = MovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil 
			end
		elseif selectedPiece.type == PIECE_WHITE_BISHOP then 
			if CanBishopMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
				selectedPiece = MovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil
			end
		elseif selectedPiece.type == PIECE_WHITE_ROOK then 
			if CanRookMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
				selectedPiece = MovePieceToPos(selectedPiece,GridPosX,GridPosY)
			else
				selectedPiece = nil
			end
		elseif selectedPiece.type == PIECE_WHITE_PAWN then 
			if CanPawnMoveToPos( GridPosX,GridPosY,
				selectedPiece.x ,selectedPiece.y ,GetCurrMap()) then
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
	love.graphics.setColor(0,0,0)
	love.graphics.print(mapIndex,30,40)
	
end

