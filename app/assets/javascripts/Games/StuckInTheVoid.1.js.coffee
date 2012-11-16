### oppen to puplic use
    Dynamic New Algorithms
    William Decker
    Peter Lepper
###
f=(x) ->
  if 0 <= x and x < 51
    return 45/100.0
  else if 51 <= x and x < 55
    return (-1.25*x+108.75) / 100.0
  else if 55 <= x and x < 60
    return (2*x-70) / 100.0
  else if 60 <= x and x < 63
    return 50/100.0
  else if 63 <= x and x < 65
    return  (1.5*x-44.5) / 100.0
  else if 65 <= x and x < 71
    return (-8.833*x+627.166) / 100.0
  else if 71 <= x and x < 72
    return (100*x-7100) / 100.0
  else if 72 <= x and x < 76
    return (-13.25*x+1054) / 100.0
  else if 76 <= x and x < 82
    return (-1.167*x+135.667) / 100.0
  else if 82 <= x and x < 89
    return (-2.429*x+239.143) / 100.0
  else if 89 <= x and x < 97
    return (5.75*x-488.75) / 100.0
  else if 97 <= x and x < 110
    return (-1.846*x+248.077) / 100.0
  else
    return 45/100.0
###------------------------------------------ Global Vars ----------------------------------------- ###

G =
  GRID:
    WIDTH: 3
    HEIGHT: 3
speed = 1
high_low = 0
played = false
x = 0

###------------------------------------------ PS Events ----------------------------------------- ###
PS.Init = ->
  PS.GridSize G.GRID.WIDTH, G.GRID.HEIGHT
  PS.BeadFlash PS.ALL,PS.ALL,false
  PS.BeadColor PS.ALL,PS.ALL,0x000000
  PS.BeadBorderWidth PS.ALL,PS.ALL,0
  PS.GridBGColor 0x0000
  PS.StatusFade false
  PS.StatusText 'Stuck in the Void'

  PS.BeadColor 1,1,Math.floor(255*f(x)),Math.floor(255*(1-f(x))),0
  PS.BeadBorderColor 1,1, 0x000000
  PS.BeadBorderWidth 1,1,Math.floor(f(x) * 10)

  PS.Clock 1

PS.Click = (x, y, data) ->
  "use strict"

PS.Release = (x, y, data) ->
  "use strict"

PS.Enter = (xx, yy, data) ->
  "use strict"

PS.Leave = (x, y, data) ->
  "use strict"

PS.KeyDown = (key, shift, ctrl) ->
  "use strict"
  PS.Clock 0
PS.KeyUp = (key, shift, ctrl) ->
  "use strict"

PS.Wheel = (dir) ->
  "use strict"
  speed += dir * 0.1
  speed = Math.max(0.1,speed)

PS.Tick = ->
  "use strict"
  x += speed
  if x >= 138
    high_low = 0
    x = 0
  if x >= 68 and high_low == 0
    PS.AudioPlay 'perc_drum_tom3'
    high_low = 1
  if x >= 89 and high_low == 1
    PS.AudioPlay 'perc_drum_tom4'
    high_low = 2


  PS.BeadColor 1,1,Math.floor(100*(1-f(x)))+125,0,Math.floor(20*(f(x)))
  PS.BeadBorderWidth 1,1,Math.floor((1-f(x)) * 50)



### END OF GAME CODE ###