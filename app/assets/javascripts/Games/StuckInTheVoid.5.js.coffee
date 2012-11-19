### oppen to puplic use
    Dynamic New Algorithms
    William Decker
    Peter Lepper
###

debug = (response) ->
  property_names = ""
  for propertyName of response
    ### propertyName is what you want###
    property_names += propertyName + " = " + response[propertyName] + "\n"
  alert property_names
###------------------------------------------ Global Vars ----------------------------------------- ###

G =
  GRID:
    WIDTH: 32
    HEIGHT: 32

curser = {x: 0,y: 0}
auto_type = 'If you prick us#$$    do we not bleed?#$$If you tickle us#$$    do we not laugh?#$$$$If you poison us#$$    do we not die?##$$$$And##$$$$if you wrong us#$$    shall we not revenge?#$$$.$$$.$$$.'
clear = false

###------------------------------------------ PS Events ----------------------------------------- ###
PS.Init = ->
  PS.GridSize G.GRID.WIDTH, G.GRID.HEIGHT
  PS.BeadFlash PS.ALL,PS.ALL,false
  PS.BeadColor PS.ALL,PS.ALL,0x000000
  PS.BeadBorderWidth PS.ALL,PS.ALL,0
  PS.BeadBorderColor PS.ALL,PS.ALL,0x000000
  PS.GridBGColor 0x0000
  PS.StatusFade false
  PS.StatusText ''
  PS.StatusColor(0xffffff)

  PS.Clock(15)


PS.Click = (x, y, data) ->
  "use strict"

PS.Release = (x, y, data) ->
  "use strict"

PS.Enter = (x, y, data) ->
  "use strict"

PS.Leave = (x, y, data) ->
  "use strict"

PS.KeyDown = (key, shift, ctrl) ->
  "use strict"

PS.KeyUp = (key, shift, ctrl) ->
  "use strict"


PS.Wheel = (dir) ->
  "use strict"

PS.Tick = ->
  "use strict"
  if auto_type.length > 0
    l = auto_type[0]
    auto_type = auto_type.substr(1)
    if l != '$' and l != '#'
      if clear and l != ' '
        PS.StatusText('')
        clear = false
      PS.StatusText(PS.StatusText()+l) unless clear
      PS.BeadGlyph curser.x,curser.y,l
      PS.AudioPlay 'fx_click' if l != ' '
      curser.x += 1
      if curser.x >= G.GRID.WIDTH
        curser.y += 1
        curser.x = 0
        if curser.y >= G.GRID.HEIGHT
          curser.y = 0
    else if l == '#'
      clear = true
      curser.y += 1
      curser.x = 0
      if curser.y >= G.GRID.HEIGHT
        curser.y = 0



### END OF GAME CODE ###