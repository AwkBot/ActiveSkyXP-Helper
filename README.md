# ActiveSkyXP-Helper
Plugin for XPlane 11 that retrieve metar from ActiveSky.

![ActiveSkyXP-Helper](https://user-images.githubusercontent.com/49170559/141481160-9cff5913-4b8b-4951-ae08-2076b04945e3.PNG)

It request the metar information from running ActiveSky thought its HTTP port, note that ActiveSky should use standard HTTP port (19285).
The command "FlyWithLua/ActiveSkypeMetar/show_toggle" is available to support keyboard/button shortcut.

It requires FlyWithLua plugin.

ActiveSkype network port should be set to defaul value:
Port: 19285
![ActiveSky](https://user-images.githubusercontent.com/49170559/141481241-06ff8726-20b8-4efd-be93-c7e660759b9a.PNG)

Change History:
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
