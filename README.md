# ActiveSkyXP-Helper
A plugin for X-Plane 11 that retrieves METAR's from ActiveSky.

![ActiveSkyXP-Helper](https://user-images.githubusercontent.com/49170559/141481160-9cff5913-4b8b-4951-ae08-2076b04945e3.PNG)

This plugin requests the METAR information from a running ActiveSky instance through it's HTTP port, note that ActiveSky should use it's default HTTP port (19285).
The command "FlyWithLua/ActiveSkyMetar/show_toggle" is available to support a keyboard/button shortcut.

This plugin requires the [FlyWithLua](https://forums.x-plane.org/index.php?/files/file/38445-flywithlua-ng-next-generation-edition-for-x-plane-11-win-lin-mac/) plugin to function properly.

The ActiveSky network port should be set to the default value (19285):
![ActiveSky](https://user-images.githubusercontent.com/49170559/141481241-06ff8726-20b8-4efd-be93-c7e660759b9a.PNG)


# Contributors:
- dechilders 

# Change History:

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
