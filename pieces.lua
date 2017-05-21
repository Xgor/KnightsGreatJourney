PIECE_WHITE_KING = 7
PIECE_WHITE_QUEEN = 8
PIECE_WHITE_BISHOP = 9
PIECE_WHITE_KNIGHT = 10
PIECE_WHITE_ROOK = 11
PIECE_WHITE_PAWN = 12
PIECE_BLACK_KING = 13
PIECE_BLACK_QUEEN = 14
PIECE_BLACK_BISHOP = 15
PIECE_BLACK_KNIGHT = 16
PIECE_BLACK_ROOK = 17
PIECE_BLACK_PAWN = 18


function IsWhitePiece(piece)
	
	return piece >= PIECE_WHITE_KING and piece < PIECE_BLACK_KING
end

function IsBlackPiece(piece)
	return PIECE_BLACK_KING >= 12
end

function IsNotEmptySpace(x,y)
	return GetMapPiece(x,y) > 0
end

function MovePieceToPos(piece,x,y)
	SetMapPiece(selectedPiece.x,selectedPiece.y,0)
	SetMapPiece(x,y,piece.type)
	piece.x = x
	piece.y = y
end

function CanPieceMoveToPos(posX,posY)
	local goalPiece = GetMapPiece(posX,posY)

	return goalPiece ~= nil and IsNotEmptySpace(posX,posY)
end

function CanPieceMoveToPos(posX,posY,isWhite)
	if isWhite then
		CanWhitePieceMoveToPos(posX,posY)
	else
		CanBlackPieceMoveToPos(posX,posY)
	end
end

function CanWhitePieceMoveToPos(posX,posY)
	local goalPiece = GetMapPiece(posX,posY)
	return CanPieceMoveToPos(posX,posY) and not IsWhitePiece(goalPiece)
end

function CanBlackPieceMoveToPos(posX,posY)
	local goalPiece = GetMapPiece(posX,posY)

	return CanPieceMoveToPos(posX,posY) and not IsBlackPiece(goalPiece)
end



function CanHorseMoveToPos(posX,posY,horseX,horseY,isWhite)
	local dist


	if CanPieceMoveToPos(posX,posY,isWhite) then

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

function CanKingMoveToPos(posX,posY,kingX,kingY,isWhite)
	if CanPieceMoveToPos(posX,posY,isWhite) then
		if math.abs(posX-kingX) <2 and math.abs(posY-kingY) <2 then
			return true
		end
	end
	return false
end

function CanRookMoveToPos(posX,posY,kingX,kingY,isWhite)
	if CanPieceMoveToPos(posX,posY,isWhite) then
		if posX == kingX then
			local xStart, xEnd

			if math.abs(posX -kingX) < 2 then
				return true
			end
			if posX < kingX then
				xCheck = posX+1
				xEnd = kingX-1
			else
				xCheck = kingX
				xEnd = posX-1
			end
			for x=xStart,xEnd do
				if not CanPieceMoveToPos(x,posY) then
					return false
				end
			end
			return true
		elseif posY == kingY then
			local yStart, yEnd

			if math.abs(posY -kingY) < 2 then
				return true
			end
			if posY < kingY then
				yCheck = posY+1
				yEnd = kingY-1
			else
				yCheck = kingY
				yEnd = posY-1
			end
			for y=yStart,yEnd do
				if not CanPieceMoveToPos(posX,y) then
					return false
				end
			end
			return true
		end
	end
	return false
end

function CanBishopMoveToPos(posX,posY,kingX,kingY,isWhite)
	if CanPieceMoveToPos(posX,posY,isWhite) then
		local xDist = posX - kingX
		local yDist = posY - kingY
		if math.abs(xDist) == math.abs(yDist) then
			return true
		end
		

	end
	return false
end

function CanQueenMoveToPos(posX,posY,kingX,kingY,isWhite)
	if CanRookMoveToPos(posX,posY,kingX,kingY,isWhite) or CanBishopMoveToPos(posX,posY,kingX,kingY,isWhite) then
		return true
	end
	return false
end

-- UNFINISHED
function CanPawnMoveToPos(posX,posY,kingX,kingY,isWhite)
	if CanWhitePieceMoveToPos(posX,posY) then
		if posX == kingX and kingY+1 == posY then
			return true
		end
	end
	return false
end
