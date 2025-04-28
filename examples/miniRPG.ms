import "oneBit"
import "listUtil"
import "stringUtil"

// Prepare the display system.
// It consists of several layers:
//   disp.background (grass etc.)
//   disp.main (player and obstacles)
//   disp.overlay (trees, roofs, etc.)
clear
disp = {}
disp.width = 20
disp.height = 20
disp.background = oneBit.prepareTileDisplay(6, 32, disp.width, disp.height)
disp.main = oneBit.prepareTileDisplay(5, 32, disp.width, disp.height)
disp.overlay = oneBit.prepareTileDisplay(4, 32, disp.width, disp.height)

placeSmallStuff = function(whichDisp, options, count, color="#FFFFFF")
	for i in range(count-1)
		x = floor(rnd * disp.width)
		y = floor(rnd * disp.height)
		whichDisp.setCell x, y, options.any
		whichDisp.setCellTint x, y, color
	end for
end function

// Build the map.
placeSmallStuff disp.background, [1,5,5,5], 200, "#006600"	// grass
placeSmallStuff disp.main, [32, 33, 34, 35, 36, 37, 67], 10, "#2FA14A" // small trees
placeSmallStuff disp.main, [608, 609, 640, 641, 673], 6, "#D6D8A5" // houses

trunks = [211, 212]
treetops = [179, 180]
for i in range(4)
	x = floor(rnd * disp.width)
	y = floor(rnd * disp.height)
	disp.main.setCell x, y, trunks.any
	disp.main.setCellTint x, y, "#AC6100FF"
	disp.overlay.setCell x, y+1, treetops.any
	disp.overlay.setCellTint x, y+1, "#2FA14AFF"
end for

player = {}
player.tileIdx = 25
player.x = floor(disp.width/2)
player.y = floor(disp.height/2)
player.lastX = -1
player.lastY = -1

player.move = function(dx, dy)
	nx = self.x + dx
	ny = self.y + dy
	if nx < 0 or nx >= disp.width or ny < 0 or ny >= disp.height then return
	if disp.main.cell(nx, ny) != null then return
	disp.main.setCell self.x, self.y, null
	self.x = nx; self.y = ny
	disp.main.setCell self.x, self.y, self.tileIdx
	disp.main.setCellTint self.x, self.y, "#EEEEEE"
end function	

disp.main.setCell player.x, player.y, null
player.move 0, 0

// Define movement keys.  I've included arrows, WASD (Qwerty),
// and Dvorak equivalents.
westKeys = ["left", "a"]
northKeys = ["up", "w", ","]
eastKeys = ["right", "d", "e"]
southKeys = ["down", "s", "o"]

allKeys = westKeys + northKeys + eastKeys + southKeys + ["escape"]

anyPressed = function(keys)
	for k in keys
		if key.pressed(k) then return true
	end for
	return false
end function

getDirKey = function
	while not anyPressed(allKeys); yield; end while
	n = ""; s = ""; e = ""; w = ""; esc = ""
	while anyPressed(allKeys)
		if anyPressed(northKeys) then n = "N"
		if anyPressed(southKeys) then s = "S"
		if anyPressed(eastKeys) then e = "E"
		if anyPressed(westKeys) then w = "W"
		if key.pressed("escape") then esc = "ESC-"
	end while
	key.clear
	return esc + n + s + e + w
end function

handleKey = function(k)
	if k == "ESC-" then
		globals.gameOver = true
		return
	end if
	dx = k.contains("E") - k.contains("W")
	dy = k.contains("N") - k.contains("S")
	player.move dx, dy
end function

gameOver = false
while not gameOver
	handleKey getDirKey
end while

