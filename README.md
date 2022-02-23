# FS22_AnimalInspector

![GitHub release (latest by date)](https://img.shields.io/github/v/release/jtsage/FS22_AnimalInspector) ![GitHub all releases](https://img.shields.io/github/downloads/jtsage/FS22_AnimalInspector/total)

<p align="left">
  <img src="https://github.com/jtsage/FS22_AnimalInspector/raw/main/modIcon.png">
</p>

First I did the vehicle one.  Then I thought it might be nice to have productions on screen too.  Now, I want animals too,
so here that is.

Note that this ignores horses.  They are just too different, and I didn't want to write all of the extra code.

## Note about the ZIP in the repo

That ZIP file, while the ?working? mod, is usually my test version.  It's updated multiple times per
version string, so be aware if you download from there, instead of the releases page, you might be
unknowingly using an old version.  For "official" releases, please use the release link to the right.

## Multiplayer

No idea.  I left the flag on for now, but I can't imagine it will work flawlessly.

## Features

* Show number of animals and space left
* Show food levels (total and individual)
* Show output products and their fill levels
* Show animal health average, breeding average, and immature animal percentage

## Default Input Bindings

* `Left Ctrl` + `Left Alt` + `Num Pad 7` : Reload configuration file from disk
* `Left Alt` + `Num Pad 7` : Toggle display on and off

## Options

All options are set via a xml file in `modSettings/FS22_AnimalInspector/savegame##/animalInspector.xml`

Most view options can be set in the in-game settings menu (scroll down)

### displayMode (configurable in the game settings menu)

* __1__ - Top left, under the input help display (auto height under key bindings, if active). Not compatible with FS22_InfoMessageHUD (they overlap).  Hidden if large map and key bindings are visible together.
* __2__ - Top right, under the clock.  Not compatible with FS22_EnhancedVehicle new damage / fuel displays
* __3__ - Bottom left, over the map (if shown). Hidden if large map and key bindings are visible together.
* __4__ - Bottom right, over the speedometer.  Special logic added for FS22_EnhancedVehicle HUD (but not the old style damage / fuel)
* __5__ - Custom placement.  Set X/Y origin point in settings XML file as well.

### in-game configurable

* __isEnabledVisible__ - Show / Hide the HUD
* __isEnabledShowCount__ - Show animal counts
* __isEnabledShowFood__ - Show total food
* __isEnabledShowFoodTypes__ - Show individual food types
* __isEnabledShowProductivity__ - Show productivity
* __isEnabledShowReproduction__ - Show reproduction average
* __isEnabledShowPuberty__ - Show percentage of animals too young to breed
* __isEnabledShowHealth__ - Show average health
* __isEnabledShowOutputs__ - Show output products (and extras)


### colors

Fill levels are color coded based on value. There is a color blind mode available (use the game setting).  All other colors are defined with a red, green, blue, and alpha component

* __colorHomeName__ - Color for husbandry name
* __colorDataName__ - Color for all information captions
* __colorSep__ - Color for seperator

### text

* __setStringTextIndent__ - text for indentation of production lines, default "    " (4 spaces)
* __setStringTextSep__ - text for separators, default " | "
* __setValueTextMarginX__ - text margin height, default "15"
* __setValueTextMarginY__ - text margin width, default "10"
* __setValueTextSize__ - text size, default "12"

### dev, debug and extras

* __setValueTimerFrequency__ - timer update frequency. We probably don't need to query every vehicle on every tick for performance reasons
* __debugMode__ - show debug output.  Mostly garbage.

## Sample

<p align="center">
  <img width="650" src="https://github.com/jtsage/FS22_AnimalInspector/raw/main/readme_sample.png">
</p>
