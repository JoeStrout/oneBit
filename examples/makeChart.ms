// This script generates a handy reference chart, with
// every tile labeled with its index, and saves it as
// "chart.png".

import "oneBit"

textH = 16
cellW = 32
cellH = 32 + textH

drawCell = function(index, x, y)
	gfx.fillRect x, y, cellW, cellH, color.white
	img = oneBit.getTileImage(index)
	gfx.drawImage img, x, y + textH, cellW, cellW,
	0, 0, img.width, img.height, color.black
	s = str(index)
	w = s.len * 8
	gfx.print s, x + cellW/2 - w/2 - 1, y + 1, "#8888FF", "small"
	gfx.line x, y + textH, x+cellW, y + textH, "#EEEEEE"
	gfx.drawRect x, y, cellW, cellH, color.silver
end function

clear
gfx.clear color.white, cellW*32, cellH*32
x = 0
y = gfx.height - cellH
for i in range(0, 1023)
	drawCell i, x, y
	x += cellW
	if x + cellW > gfx.width then
		x = 0
		y -= cellH
		if y < 0 then break
	end if
end for

filename = "chart.png"
file.saveImage filename, gfx.getImage(0,0,gfx.width, gfx.height)
clear
print "Saved chart image to " + filename
