-- ActiveSky XP 
-- Carlos Eduardo Sampaio - 2021

-- Description: It get METAR information from activeSkype API
-- Based on SimBrief Helper Plugin

-- Modules
local xml2lua = require("xml2lua")
local handler = require("xmlhandler.tree")

-- Public Variables
local socket = require "socket"
local http = require "socket.http"
local LIP = require("LIP");
local ActiveSkyXMLFile = "metar_asxp.xml"

local DataASXP = {}
local asxpICAO = ""
local asxpMetar = ""
local getMetar = false

if not SUPPORTS_FLOATING_WINDOWS then
  -- to make sure the script doesn't stop old FlyWithLua versions
  logMsg("imgui not supported by your FlyWithLua version")
  return
end


function metarGet()
  local webRespose, webStatus = http.request("http://localhost:19285/ActiveSky/API/GetMetarInfoAt?ICAO=" .. asxpICAO)

  if webStatus ~= 200 then
    logMsg("Simbrief API is not responding OK")
    return false
  end

  asxpMetar = webRespose;
end

function asxp_on_build(sb_wnd, x, y)
  imgui.TextUnformatted(string.format("Enter ICAO airport."))
  
  local changed, tmpICAO = imgui.InputText(" ", asxpICAO, 5)
  if changed then
   asxpICAO = tmpICAO:upper()
  end
  
    -- BUTTON
  if imgui.Button("Get Metar") then
    if asxpICAO ~= nil then
	  metarGet()
      getMetar = true
    end
  end
  
  if getMetar then
	imgui.TextUnformatted(string.format(""))
	imgui.TextUnformatted(string.sub(asxpMetar, 0, 67))
	imgui.TextUnformatted(string.sub(asxpMetar, 68, 136))
	imgui.TextUnformatted(string.sub(asxpMetar, 137, 203))
  end
end

asxp_wnd = nil
function asxp_show_wnd()
  asxp_wnd = float_wnd_create(500, 150, 1, true)
  --float_wnd_set_imgui_font(asxp_wnd, 2)
  float_wnd_set_title(asxp_wnd, "ActiveSky Metar")
  float_wnd_set_imgui_builder(asxp_wnd, "asxp_on_build")
  float_wnd_set_onclose(asxp_wnd, "asxp_hide_wnd")
end

function asxp_hide_wnd()
  if asxp_wnd then
    float_wnd_destroy(asxp_wnd)
  end
end

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

add_macro("ActiveSky Metar", "asxp_show_wnd()", "asxp_hide_wnd()", "deactivate")
create_command("FlyWithLua/ActiveSkypeMetar/show_toggle", "open/close ActiveSkype Metar", "toggle_asxp_helper_interface()", "", "")
