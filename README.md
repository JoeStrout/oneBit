# oneBit

## Code and tools for working with the "1bitTiles" image in Mini Micro

[Mini Micro](https://miniscript.org/MiniMicro/) comes with an amazing set of 1024 unique 16x16 1-bit icons.  These were adapted from [Kenney's 1-Bit Pack](https://kenney.nl/assets/1-bit-pack), but arranged into 32 rows and columns in a nice neat tile set found at [/sys/pics/1bitTiles.png](https://github.com/JoeStrout/minimicro-sysdisk/blob/master/sys/pics/1bitTiles.png).  At the same time, they were recolored to be white with a transparent background.  This is why, if you follow the link above, you may not be able to see the content (as GitHub draws images on a white background); but it also means the tiles can be easily tinted any color you like at runtime.

Kenney includes some mock-ups showing how effective it can be to colorize these 1-bit images on a per-tile basis, enabling scenes like these:

![RPG mock-up](https://kenney.nl/media/pages/assets/1-bit-pack/fda061c324-1677578508/sample_fantasy.png)

However, these 1-bit tiles are not just for making RPG maps!  You'll find *all sorts* of things in here, including:

- platforms and platformer characters
- UI elements like switches, buttons, and checkboxes
- characters and monsters
- equipment, weapons, and treasure
- playing cards and dice
- vehicles including boats, trucks, tanks, and UFOs
- a full alphabet and simple punctuation
- joystick and gamepad icons
- pipes, roadways, arrows, faces, and much more

Check out [this chart](examples/chart.png) for the full set.  Never before has a single tileset had so much game-making potential.

## In This Repo

The 1bitTiles image comes with Mini Micro, and you don't need anything but your own code and creativity to work with it.

However, this repo contains:

1. An import library called [oneBit](lib/oneBit.ms) which provides some utility functions to make working with this tileset even easier, and
2. A folder of [examples](examples) to get you started.

