### oppen to puplic use ###

#------------------------------------ Classes -------------------------------------
class dot
  constructor: (x,y) ->
    @x = Math.floor(x)
    @y = Math.floor(y)

  update: () ->
    @x = Math.abs((@x + Math.floor(Math.random() * 2 + 1) - Math.floor(Math.random() * 2 + 1)) % GRID_SIZE)
    @y = Math.abs((@y + Math.floor(Math.random() * 2 + 1) - Math.floor(Math.random() * 2 + 1)) % GRID_SIZE)

  draw: () ->
    c = PS.BeadColor @x,@y
    c = PS.UnmakeRGB(c)
    c = PS.MakeRGB(Math.abs(c.r-255),Math.abs(c.g-255),Math.abs(c.b-255))
    PS.BeadColor @x, @y, Math.abs(c-1)
    c = PS.BeadColor (GRID_SIZE-1)-@x,@y
    c = PS.UnmakeRGB(c)
    c = PS.MakeRGB(Math.abs(c.r-255),Math.abs(c.g-255),Math.abs(c.b-255))
    PS.BeadColor (GRID_SIZE-1)-@x, @y, Math.abs(c-1)
    c = PS.BeadColor (GRID_SIZE-1)-@x,(GRID_SIZE-1)-@y
    c = PS.UnmakeRGB(c)
    c = PS.MakeRGB(Math.abs(c.r-255),Math.abs(c.g-255),Math.abs(c.b-255))
    PS.BeadColor (GRID_SIZE-1)-@x, (GRID_SIZE-1)-@y, Math.abs(c-1)
    c = PS.BeadColor @x,(GRID_SIZE-1)-@y
    c = PS.UnmakeRGB(c)
    c = PS.MakeRGB(Math.abs(c.r-255),Math.abs(c.g-255),Math.abs(c.b-255))
    PS.BeadColor @x, (GRID_SIZE-1)-@y, Math.abs(c-1)

#------------------------------------------ Constants -----------------------------------------
GRID_SIZE = 32

dot = new dot(GRID_SIZE/2,GRID_SIZE/2)

#------------------------------------------ Events -----------------------------------------

PS.Init = ->
  # change to the dimensions you want
  PS.GridSize GRID_SIZE, GRID_SIZE
  PS.StatusText "Rorschach"
  #start the clock
  PS.Clock(10)

PS.Click = (x, y, data) ->
  "use strict"
  PS.BeadColor x, y, 0xff0000
  PS.AudioPlay "fx_click"
  c = PS.BeadColor x, y
  c = PS.UnmakeRGB(c)
  alert c.r
  # put code here for bead clicks


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
  dot.update()
  dot.draw()


