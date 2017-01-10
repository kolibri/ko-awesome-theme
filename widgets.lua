local awful     = require("awful")
local wibox     = require("wibox")
local net_widgets = require("net_widgets")
local ko_widgets = require("ko_widgets")


function add_widgets(screen, beautiful)

-- {{{ Wibox

-- Textclock
clockicon = wibox.widget.imagebox(beautiful.widget_clock)
mytextclock = awful.widget.textclock(" %a %d %b %H:%M:%S", 5)

-- Separators
spr = wibox.widget.textbox(' ')

-- Create a wibox for each screen and add it
topwibox = {}
rightwibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
  awful.button({ }, 1, function (c)
      if c == client.focus then
          c.minimized = true
      else
          -- Without this, the following
          -- :isvisible() makes no sense
          c.minimized = false
          if not c:isvisible() then
              awful.tag.viewonly(c:tags()[1])
          end
          -- This will also un-minimize
          -- the client, if needed
          client.focus = c
          c:raise()
      end
  end),
  awful.button({ }, 3, function ()
      if instance then
          instance:hide()
          instance = nil
      else
          instance = awful.menu.clients({ width=250 })
      end
  end),
  awful.button({ }, 4, function ()
      awful.client.focus.byidx(1)
      if client.focus then client.focus:raise() end
  end),
  awful.button({ }, 5, function ()
      awful.client.focus.byidx(-1)
      if client.focus then client.focus:raise() end
  end))

for s = 1, screen.count() do

    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()

    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                            awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                            awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                            awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))

    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    topwibox[s] = awful.wibox({ position = "top", screen = s, height = 18 })
    rightwibox[s] = awful.wibox({ position = "right", screen = s, width = 18 })

    -- Widgets that are aligned to the upper left
    local top_bar_left = wibox.layout.fixed.horizontal()
    top_bar_left:add(spr)
    top_bar_left:add(mytaglist[s])
    top_bar_left:add(mypromptbox[s])
    top_bar_left:add(spr)

    -- Widgets that are aligned to the upper right
    local top_bar_right = wibox.layout.fixed.horizontal()
    if s == 1 then top_bar_right:add(wibox.widget.systray()) end
    top_bar_right:add(mytextclock)
    top_bar_right:add(spr)
    top_bar_right:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local top_bar = wibox.layout.align.horizontal()
    top_bar:set_left(top_bar_left)
    top_bar:set_middle(mytasklist[s])
    top_bar:set_right(top_bar_right)
    topwibox[s]:set_widget(top_bar)

    -- right bar widgets
    local right_bar = wibox.layout.align.vertical()
    local right_bar_top = wibox.layout.fixed.vertical()
    right_bar_top:add(net_widgets.wireless({interface="wlp3s0", command_mode="newer"}))
    right_bar_top:add(ko_widgets.battery())
    right_bar_top:add(ko_widgets.acplug())
    right_bar_top:add(ko_widgets.volume())
    right_bar_top:add(ko_widgets.temperature())
    right_bar_top:add(ko_widgets.touchpad())
    right_bar_top:add(ko_widgets.screen_brightness())

    right_bar:set_top(right_bar_top)

    rightwibox[s]:set_widget(right_bar)
end
-- }}}
end
