### oppen to puplic use
    Dynamic New Algorithms
    William Decker
    Peter Lepper
###
###------------------------------------------ Global Vars ----------------------------------------- ###

G =
  GRID:
    WIDTH: 9
    HEIGHT: 9
block = {x: 3,y:3,w: 10,goal: 10,down: false}

###------------------------------------------ PS Events ----------------------------------------- ###
PS.Init = ->
  PS.GridSize G.GRID.WIDTH, G.GRID.HEIGHT
  PS.BeadFlash PS.ALL,PS.ALL,false
  PS.BeadColor PS.ALL,PS.ALL,0x000000
  PS.BeadBorderWidth PS.ALL,PS.ALL,0
  PS.BeadBorderColor PS.ALL,PS.ALL,0x000000
  PS.GridBGColor 0x0000
  PS.StatusFade false
  PS.StatusText 'Stuck in the Void: toy 2'
  PS.StatusColor(0xffffff)
  PS.BeadColor block.x,block.y,0xffffff
  PS.BeadBorderWidth block.x,block.y,Math.floor(block.w)


  PS.Clock 1

PS.Click = (x, y, data) ->
  "use strict"
  if block.x == x and block.y == y
    block = {x: x,y: y,w: block.w,goal: 0,down: true}

PS.Release = (x, y, data) ->
  "use strict"
  if block.x == x and block.y == y
    block = {x: x,y: y,w: block.w,goal: 10,down: false}

PS.Enter = (x, y, data) ->
  "use strict"
  if block.down
    PS.BeadColor block.x,block.y,0x000000
    PS.BeadBorderWidth block.x,block.y,0
    block = {x: x,y: y,w: block.w,goal: block.goal,down: true}
    PS.BeadColor block.x,block.y,0xffffff
    PS.BeadBorderWidth block.x,block.y,Math.floor(block.w)

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
  if block.goal != block.w
    if block.w < block.goal
      block.w = Math.min(block.w + (block.goal - block.w) * (block.w / block.goal),block.goal)
      block.w = 0.01 if block.w == 0
    else
      block.w = Math.max(0,block.w - (block.w - block.goal) * (1 / block.w) )
    PS.BeadBorderWidth block.x,block.y,Math.floor(block.w)
    PS.BeadColor block.x,block.y,0xffffff




### END OF GAME CODE ###