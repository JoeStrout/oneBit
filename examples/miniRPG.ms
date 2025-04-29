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
disp.background = oneBit.prepareTileDisplay(6, 32, disp.width, disp.height, true)
disp.main = oneBit.prepareTileDisplay(5, 32, disp.width, disp.height, true)
disp.overlay = oneBit.prepareTileDisplay(4, 32, disp.width, disp.height, true)

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

x = 2; y = 4
disp.main.setCell x, y, 416; disp.main.setCellTint x, y, "#BBBBBB"
disp.overlay.setCell x, y+1, 384; disp.overlay.setCellTint x, y+1, "#BBBBBB"
disp.main.setCell x, y+1, 0  // (makes it clear and impassible)
disp.background.setCell x, y+1, null

// Make an Entity class - anything on the map that can be interacted with.
Entity = {}
Entity.x = 0
Entity.y = 0
Entity.tileIdx = 248
Entity.color = color.white
Entity.name = ""
Entity.Instances = []
Entity.FindAt = function(x, y)
	for inst in Entity.Instances
		if inst.x == x and inst.y == y then return inst
	end for
	return null
end function
Entity.init = function(x, y, tileIdx=null, color=null, name="")
	Entity.Instances.push self
	if tileIdx != null then self.tileIdx = tileIdx
	if color != null then self.color = color
	if name then self.name = name
	self.place x, y
end function
Entity.place = function(x, y)
	self.x = x; self.y = y
	disp.main.setCell self.x, self.y, self.tileIdx
	disp.main.setCellTint self.x, self.y, self.color
end function
Entity.interact = null // do something when the player interacts with this!

// Make a Agent class, to represent any body/thing that can move around
// and get a periodic update.
Agent = new Entity
Agent.x = 0
Agent.y = 0
Agent.tileIdx = 248
Agent.move = function(dx, dy, forceSuccess=false)
	nx = self.x + dx
	ny = self.y + dy
	if nx < 0 or nx >= disp.width or ny < 0 or ny >= disp.height then return
	if disp.main.cell(nx, ny) != null then
		ent = Entity.FindAt(nx, ny)
		if ent != null then ent.interact
		if not forceSuccess then return
	end if
	disp.main.setCell self.x, self.y, null
	self.place nx, ny
end function
Agent.say = function(speech)
	s = self.name
	if s then s += ": "
	s += """" + speech + """"
	print char(13) + s
end function
Agent.update = null
Agent.UpdateAll = function
	for ent in Entity.Instances
		if ent isa Agent then ent.update
	end for
end function

// Prepare the player.
player = new Agent
player.init 10, 10, 25

// Prepare some NPCs.
girl = new Agent
girl.init 17, 15, 127, "#FFBBBB", "Girl"
girl.interact = function
	if dog.following != self then
		self.say "I've lost my dog Fido!  Can you help me find him?"
		dog.name = "Fido"
	else
		self.say "Thank you for finding Fido!"
	end if
end function
girl.update = function
	if dog.following == self then return
	dx = dog.x - self.x; dy = dog.y - self.y
	if 0 < abs(dx) + abs(dy) < 5 then
		self.move sign(dx), sign(dy)
		if abs(dog.x - self.x) < 2 and abs(dog.y - self.y) < 2 then
			self.say "Fido!!!"
			dog.following = self
		end if
	end if
end function

dog = new Agent
dog.init 4, 2, 255, "#F0C06E", "Dog"
dog.found = false
dog.following = null
dog.interact = function
	self.say "Ruff!"
	if not self.found then
		self.found = true
		self.following = player
	end if
end function
dog.update = function
	if not self.found then
		// wander randomly
		if rnd < 0.1 then self.move floor(rnd*3)-1, floor(rnd*3)-1
	else if self.following then
		dx = self.following.x - self.x
		dy = self.following.y - self.y
		if abs(dx) + abs(dy) > 2 and rnd < 0.8 then
			self.move sign(dx), sign(dy)
		end if
	end if
end function


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

	text.clear
	text.row = 0; text.column = 0; text.delimiter = ""
	player.move dx, dy
	Agent.UpdateAll
	text.delimiter = char(13)
end function

gameOver = false
while not gameOver
	handleKey getDirKey
end while

