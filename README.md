# ActiveSkyXP-Helper
A plugin for X-Plane 11 that retrieves METAR's from ActiveSky.

![ActiveSkyXP-Helper](https://user-images.githubusercontent.com/49170559/141706953-9055ef82-54b0-49d7-9bb0-f6c58263ab31.PNG)

This plugin requests the METAR information from a running ActiveSky instance through it's HTTP port, note that ActiveSky should use it's default HTTP port (19285). The command "FlyWithLua/ActiveSkyMetar/show_toggle" is available to support a keyboard/button shortcut. (see screenshot above)

This plugin requires the [FlyWithLua](https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/) plugin to function properly.

# Instalation

- Copy metar_asxp.lua file to <X-Plane 11 Folder>\Resources\plugins\FlyWithLua\Scripts
- Copy metar_asxp.ini file to <X-Plane 11 Folder>\Resources\plugins\FlyWithLua\Scripts
- In case you do not have SImbrief-Helper installed copy the content of modules folder into <X-Plane 11 Folder>\Resources\plugins\FlyWithLua\Modules

The ActiveSky network port should be set to the default value (19285):
![ActiveSky](https://user-images.githubusercontent.com/49170559/141481241-06ff8726-20b8-4efd-be93-c7e660759b9a.PNG)

# Specific ActiveSky Configuration
In case your ActiveSky runs on specific IP and/or Port, the network parameters can be adjusted in metar_asxp.ini file.
Please, make use of "localhost" instead of 127.0.0.1  for local machine communication. The standard configuration is:

[activesky]
host=localhost
port=19285

# Contributors:
- dechilders 

# Change History:
V0.8
- Add a checkbox to set bigger font

V 0.7
- Fix negative temparatures alignment in Wind Layers
- Improve detection of AcviveSky communication failure
- Add configuration file for ActiveSky IP/hostname and Port

V 0.6 - 12/Nov/2021
- Display wind layers

V 0.5 - 12/Nov/2021 (Thank you @dechilders)
- Fixes several typos
- keyboard shortcut changed to "FlyWithLua/ActiveSkyMetar/show_toggle"

V 0.4 - 12/Nov/2021
- Enhanced warning message when ActiveSky is not running

V 0.3 - 11/Nov/2021
- Fix freeze issue that happen when ActiveSky is not running
- Add feature to display Zulu time of last update/query
- Refresh time is displayed in blue in case of chage in Metar


V 0.2 - 10/Nov/2021
- Includes dependency modules (originally used by simbrief)
- New repository structure
- New package structure
