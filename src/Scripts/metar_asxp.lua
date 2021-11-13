-- ActiveSky XP 
-- Version 0.4
-- Carlos Eduardo Sampaio - 2021

-- Description: It gets METAR information from the ActiveSky API
-- Based on SimBrief Helper Plugin


-- Modules
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

-- Public Definitions
local socket = require "socket"
local http = require "socket.http"
local LIP = require("LIP");
local ActiveSkyXMLFile = "metar_asxp.xml"

-- Public Variables
local DataASXP = {}
local asxpICAO = ""
local asxpMetar = ""
local asxpTimestamp = ""
local getMetar = false
local changedMetar = true

local tmp = ""
local DataASXP = {}

DataRef("asxpZulu", "sim/time/zulu_time_sec")

if not SUPPORTS_FLOATING_WINDOWS then
  -- to make sure the script doesn't stop old FlyWithLua versions
  logMsg("imgui not supported by your FlyWithLua version")
  return
end

-- Function: timeConvert
-- Parameter: number of seconds
-- Return: time withg hh:mm string 
-- Convert Timestamp format (seconds from midnight) into hh:mm string format
--##############################################################################################################################
function timeConvert(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "no data";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    return hours..":"..mins
  end
end

-- Function: readASXPXML
-- Read XML METAR from ActiveSky then store it into global variables
--##############################################################################################################################
function readASXPXML()
  -- Read and Parse XML file
  local xfile = xml2lua.loadFile(SCRIPT_DIRECTORY..ActiveSkyXMLFile)
  local parser = xml2lua.parser(handler)
  parser:parse(xfile)
  
  -- define variable to interate through WindLayers 
  local winds = handler.root.Weather.WindLayers.Layer

  -- Interate through WindLayers and populate global variables
  for i, p in pairs(winds) do
	DataASXP["WINDS"] = i  -- NUmber of Wind layer
  DataASXP["WA"..i]  = p._attr.AltFeet
	DataASXP["WD"..i]  = p._attr.WindDirection
	DataASXP["WS"..i]  = p._attr.WindSpeed
	DataASXP["WT"..i]  = p._attr.Temp
  end
end

-- Function: readASXPXML
-- Read METAR information from AcviveSkye and generate XML file
--##############################################################################################################################
function metarGet()
  -- Get METAR information
  local webRespose, webStatus = http.request("http://localhost:19285/ActiveSky/API/GetMetarInfoAt?ICAO=" .. asxpICAO)
  if webStatus ~= 200 then
    logMsg("ActiveSky API is not responding OK")
	asxpMetar = "Cannot contact ActiveSky"
    return false
  end

  -- State if METAR has changed in order to change the color of "Last Refresh" information
  if asxpMetar == webRespose then
	changedMetar = false
  else
    changedMetar = true
  end 
  
  -- Store METAR information into global variable
  asxpMetar = webRespose;

  -- Get Wind Layers from ActiveSky
  webRespose, webStatus = http.request("http://localhost:19285/ActiveSky/API/GetWeatherInfoXml?icaoid=" .. asxpICAO)
  if webStatus ~= 200 then
    logMsg("ActiveSky API is not responding OK")
    return false
  end

  -- Store Wind Layers information into XML file
  local f = io.open(SCRIPT_DIRECTORY..ActiveSkyXMLFile, "w")
  f:write(webRespose)
  f:close()
  
  return true
end

-- Function: asxp_on_build
-- Main GUI
--##############################################################################################################################
function asxp_on_build(sb_wnd, x, y)
  imgui.TextUnformatted(string.format("Airport ICAO"))
  imgui.SameLine()
  
  local changed, tmpICAO = imgui.InputText(" ", asxpICAO, 5)
  if changed then
   asxpICAO = tmpICAO:upper()
  end
  
    -- Fetch METAR button
  if imgui.Button("Get METAR") then
    if asxpICAO ~= nil then
      if metarGet() then
	      readASXPXML()
        asxpTimestamp = timeConvert(asxpZulu)
        getMetar = true
      else
        getMetar = false
        asxpTimestamp = "Cannot contact AcviveSky"
	    end
    end
  end
  
  -- If no METAR available skip redraw
  if not getMetar then
    imgui.SameLine()
    imgui.TextUnformatted(string.format(asxpTimestamp))
    return
  end

  -- Show last refresh time
  if changedMetar then
    imgui.SameLine()
    -- Show last fresh time in blue if a new metar has been displayed
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFF00)
    imgui.TextUnformatted(string.format("  Last Refresh: " .. asxpTimestamp .. "z"))
    imgui.PopStyleColor()
  else
    imgui.TextUnformatted(string.format("  Last Refresh: " .. asxpTimestamp .. "z"))
  end
  -- Diusplay METAR information
  imgui.TextUnformatted(string.format(" "))
  imgui.TextUnformatted(string.sub(asxpMetar, 0, 67))
  imgui.TextUnformatted(string.sub(asxpMetar, 68, 136))
  imgui.TextUnformatted(string.sub(asxpMetar, 137, 203))
	
  -- Display Wind Layer information
  if getMetar then
    -- Table Header
    imgui.Separator()
    imgui.PushStyleColor(imgui.constant.Col.Text, 0xFFFFFF00)
    imgui.TextUnformatted(string.format("                   Wind Layers")) 
    imgui.TextUnformatted(string.format("Altitude             Dir/Spd              Temp" ))
    imgui.PopStyleColor()
    imgui.Separator()

    -- Table data rows
    for i=1, DataASXP["WINDS"] do
      imgui.TextUnformatted(string.format("%6d               %3d/%3d              %3d", DataASXP["WA"..i], DataASXP["WD"..i], DataASXP["WS"..i], DataASXP["WT"..i]))
    end
  end
end

-- Function: asxp_show_wnd
-- Create GUI Windown
--##############################################################################################################################
asxp_wnd = nil
function asxp_show_wnd()
  asxp_wnd = float_wnd_create(500, 300, 1, true)

  --TODO: remember window position
  --float_wnd_set_position(asxp_wnd, 400, 200)
  float_wnd_set_title(asxp_wnd, "ActiveSky METAR")
  float_wnd_set_imgui_builder(asxp_wnd, "asxp_on_build")
  float_wnd_set_onclose(asxp_wnd, "asxp_hide_wnd")
end

-- Function: asxp_show_wnd
-- Destroy GUI Windown
--##############################################################################################################################
function asxp_hide_wnd()
  if asxp_wnd then 
    float_wnd_destroy(asxp_wnd)
  end
end


-- Function: toggle_asxp_helper_interface
-- Implement command used by XPlane macros
--##############################################################################################################################
asxp_show_only_once = 0
asxp_hide_only_once = 0

function toggle_asxp_helper_interface()
  sb_show_window = not sb_show_window
  if sb_show_window then
    if asxp_show_only_once == 0 then
      asxp_show_wnd()
      asxp_show_only_once = 1
      asxp_hide_only_once = 0
    end
  else
    if asxp_hide_only_once == 0 then
      asxp_hide_wnd()
      asxp_hide_only_once = 1
      asxp_show_only_once = 0
    end
  end
end


-- Implement XPlane macros/commands
--##############################################################################################################################
add_macro("ActiveSky Metar", "asxp_show_wnd()", "asxp_hide_wnd()", "deactivate")
create_command("FlyWithLua/ActiveSkyMetar/show_toggle", "open/close ActiveSky METAR", "toggle_asxp_helper_interface()", "", "")
