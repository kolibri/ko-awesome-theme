local module_path = (...):match ("(.+/)[^/]+$") or ""

package.loaded.ko_widgets = nil

local ko_widgets = {
    volume            = require(module_path .. "ko_widgets.volume"),
    acplug            = require(module_path .. "ko_widgets.acplug"),
    temperature       = require(module_path .. "ko_widgets.temperature"),
    battery           = require(module_path .. "ko_widgets.battery"),
    touchpad          = require(module_path .. "ko_widgets.touchpad"),
    screen_brightness = require(module_path .. "ko_widgets.screen_brightness"),
    temperature_right = require(module_path .. "ko_widgets.temperature_right"),
    volume_right      = require(module_path .. "ko_widgets.volume_right")
}

return ko_widgets
