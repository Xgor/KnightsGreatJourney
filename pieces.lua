PIECE_PICKUP = 2
PIECE_ARROW_UP = 3
PIECE_ARROW_RIGHT = 4
PIECE_ARROW_DOWN = 5
PIECE_ARROW_LEFT = 6
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
	return PIECE_BLACK_KING <= piece
end

function IsNotEmptySpace(x,y)
	return GetMapPiece(x,y) > 0
end

function CanPiecePassThroughPos(posX,posY)
	local goalPiece = GetMapPiece(posX,posY)

	return goalPiece ~= nil and goalPiece>0 and goalPiece< PIECE_WHITE_KING
end

function CanPieceMoveToPos(posX,posY,isWhite)
	
	if isWhite then
		return CanWhitePieceMoveToPos(posX,posY)
	else
		return CanBlackPieceMoveToPos(posX,posY)
	end
end

function CanMoveToPos(posX,posY)
	local goalPiece = GetMapPiece(posX,posY)

	return goalPiece ~= nil and IsNotEmptySpace(posX,posY)
end

function CanWhitePieceMoveToPos(posX,posY)
	local goalPiece = GetMapPiece(posX,posY)
	return CanMoveToPos(posX,posY) and not IsWhitePiece(goalPiece)
end

function CanBlackPieceMoveToPos(posX,posY)
	local goalPiece = GetMapPiece(posX,posY)

	return CanMoveToPos(posX,posY) and not IsBlackPiece(goalPiece)
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

function CanRookMoveToPos(posX,posY,pieceX,pieceY,isWhite)

	if CanPieceMoveToPos(posX,posY,isWhite) then

		if posY == pieceY then
			local xStart, xEnd
			
			if math.abs(posX -pieceX) < 2 then
				return true
			end
			if posX < pieceX then
				xStart = posX+1
				xEnd = pieceX-1
			else
				xStart = pieceX+1
				xEnd = posX-1
			end
			for x=xStart,xEnd do
				if not CanPiecePassThroughPos(x,posY) then
					return false
				end
			end
			return true
		elseif posX == pieceX then
			
			local yStart, yEnd

			if math.abs(posY -pieceY) < 2 then
				return true
			end

			if posY < pieceY then
				yStart = posY+1
				yEnd = pieceY-1
			else
				yStart = pieceY+1
				yEnd = posY-1
			end
			for y=yStart,yEnd do
				if not CanPiecePassThroughPos(posX,y) then
					return false
				end
			end
			return true
		end
	--	print("...")
	end
	return false
end

function CanBishopMoveToPos(posX,posY,pieceX,pieceY,isWhite)
	if CanPieceMoveToPos(posX,posY,isWhite) then
		
		local xDist = posX - pieceX
		local yDist = posY - pieceY

		if math.abs(xDist) == math.abs(yDist) then
			if xDist == 1 then
				return true
			end
			local xDir,yDir
			if xDist > 0 then xDir = 1 else xDir = -1 end
			if yDist > 0 then yDir = 1 else yDir = -1 end
			for i = 1,xDist-1 do
				if not CanPiecePassThroughPos(pieceX+i*xDir,pieceY+i*yDir) then
					return false
				end 
			end
			return true
		end
	end
	return false
end

function CanQueenMoveToPos(posX,posY,pieceX,pieceY,isWhite)
	if CanRookMoveToPos(posX,posY,pieceX,pieceY,isWhite) or CanBishopMoveToPos(posX,posY,pieceX,pieceY,isWhite) then
		return true
	end
	return false
end

-- Har inte att man kan hoppa två steg första gången
function CanPawnMoveToPos(posX,posY,pieceX,pieceY,isWhite)

	local YDir
	if isWhite then
		YDir = pieceY-1
	else
		YDir = pieceY+1
	end
	if YDir ~= posY then
		return false
	end

	-- Can Walk Foward
	if posX == pieceX and CanPiecePassThroughPos(posX,posY) then
		return true
	end
	if math.abs(pieceX-posX) == 1 and CanMoveToPos(posX,posY)then

		if isWhite then
			return IsBlackPiece(GetMapPiece(posX,posY))
		else
			return IsWhitePiece(GetMapPiece(posX,posY))
		end
	end
	return false
end