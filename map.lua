
function loadMap(mapPath)
	currMap ={}
	currMap[0] = mapPath.layers[1].data
	mapIndex =0
	mapEndIndex= 0
	roomWidth = mapPath.width
	roomHeight = mapPath.height
end

function DidPlayerCompleteLevel()
	for x = 0, roomWidth-1 do
		for y = 0, roomHeight-1 do
			if GetMapPiece(x,y) == 2 then
				return false
			end
		end
	end
	return true
end

function EndLevel()

end

function GetMapPiece(x,y)
	return GetCurrMap()[(1+x+y*testMap.width)]
end

function GetCurrMap()
	return currMap[mapIndex]
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

function SetMapPiece(x,y,piece)
	GetCurrMap()[(1+x+y*roomWidth)] = piece
end

function NewField()
	currMap[mapIndex+1] = {}
	mapEndIndex = mapIndex+1
	for x = 0, roomWidth-1 do
		for y = 0, roomHeight-1 do
			currMap[mapIndex+1][(1+x+y*roomWidth)] = currMap[mapIndex][(1+x+y*roomWidth)]
		end
	end
end

function EnemyTurn()
	local currMapPiece
	for x = 0, roomWidth-1 do
		for y = 0, roomHeight-1 do
			currMapPiece = GetMapPiece(x,y)
			if IsBlackPiece(currMapPiece) then

			end
		end
	end
end

function MovePieceToPos(piece,x,y)
	NewField()
	mapIndex = mapIndex+1
	SetMapPiece(x,y,piece.type)
	SetMapPiece(selectedPiece.x,selectedPiece.y,0)
	selectedPiece.x = x
	selectedPiece.y = y
end

function DrawHighlight(xPos,yPos, color) 
	love.graphics.setColor(color)
	love.graphics.rectangle("fill", xPos*32, yPos*32, 32, 32)
end


function Undo()
	if mapIndex > 0 then
		mapIndex = mapIndex-1
	end
end

function Redo()
	if mapEndIndex > mapIndex then
		mapIndex = mapIndex+1
	end
end


function Reset()
	mapIndex = 0
end

function DrawMap(map)
	for x = 0, roomWidth-1 do
		for y = 0, roomHeight-1 do

			if(IsNotEmptySpace(x,y)) then
				if((x+y)%2 > 0) then
					love.graphics.setColor(Color_Chess1)
				else
					love.graphics.setColor(Color_Chess2)
				end

				local piece = GetMapPiece(x,y)

				love.graphics.rectangle("fill", x*32, y*32, 32, 32)


				if selectedPiece ~= nil then

					if selectedPiece.type == PIECE_WHITE_KNIGHT and 
					CanHorseMoveToPos(x,y,selectedPiece.x,selectedPiece.y,GetCurrMap()) then 
						if CanHorseMoveToPos(x,y,selectedPiece.x,selectedPiece.y,GetCurrMap()) then
							DrawHighlight(x,y,Color_Highlight)
						end
					elseif selectedPiece.type == PIECE_WHITE_KING then 
						if CanKingMoveToPos(x,y,selectedPiece.x,selectedPiece.y,GetCurrMap()) then
							DrawHighlight(x,y,Color_Highlight)
						end
					elseif selectedPiece.type == PIECE_WHITE_QUEEN then 
						if CanQueenMoveToPos(x,y,selectedPiece.x,selectedPiece.y,GetCurrMap()) then
							DrawHighlight(x,y,Color_Highlight)
						end
					elseif selectedPiece.type == PIECE_WHITE_BISHOP then 
						if CanBishopMoveToPos(x,y,selectedPiece.x,selectedPiece.y,GetCurrMap()) then
							DrawHighlight(x,y,Color_Highlight)
						end
					elseif selectedPiece.type == PIECE_WHITE_ROOK then 
						if CanRookMoveToPos(x,y,selectedPiece.x,selectedPiece.y,GetCurrMap()) then
							DrawHighlight(x,y,Color_Highlight)
						end
					elseif selectedPiece.type == PIECE_WHITE_PAWN then 
						if CanPawnMoveToPos(x,y,selectedPiece.x,selectedPiece.y,GetCurrMap()) then
							DrawHighlight(x,y,Color_Highlight)
						end
					end

			--		DrawHighlight(x,y,)
				end

				if piece==PIECE_PICKUP then
					love.graphics.setColor(0,100,255)
					love.graphics.circle("fill", 16+x*32, 16+y*32, 10)
				elseif piece > 2 then
					love.graphics.setColor(255,255,255)
					local drawQuad =love.graphics.newQuad(((piece-1)%6)*32, math.floor((piece-1)/6)*32, 32, 32, GetTileset():getDimensions())
					love.graphics.draw(GetTileset(),drawQuad,x*32,y*32)
				end

				if selectedPiece ~= nil then
					if selectedPiece.x == x and selectedPiece.y == y then
						local offset = 2+0.75*math.cos(4*love.timer.getTime())
						local offset2 = 2+0.75*math.cos(4*love.timer.getTime()+0.5)
						love.graphics.setColor(Color_SelectedPiece)
						love.graphics.setLineWidth(2)
						love.graphics.rectangle("line", x*32+offset, y*32+offset, 32-offset*2,32-offset*2)
						love.graphics.rectangle("line", x*32+offset2, y*32+offset2, 32-offset2*2,32-offset2*2)
					end
				end
			end
		end
	end


end