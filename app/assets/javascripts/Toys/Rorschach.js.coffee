### oppen to puplic use
William Decker
###
#------------------------------------ Classes -------------------------------------
class dot
  constructor: () ->
    @mode = -1
    @color =
      r: 0
      g: 0
      b: 0
    this.reset()

  update: () ->
    @x = Math.abs((@x + Math.floor(Math.random() * 2 + 1) - Math.floor(Math.random() * 2 + 1)) % GRID_SIZE)
    @y = Math.abs((@y + Math.floor(Math.random() * 2 + 1) - Math.floor(Math.random() * 2 + 1)) % GRID_SIZE)

    @color.r = Math.abs((@color.r + Math.floor(Math.random() * 10 + 1) - Math.floor(Math.random() * 10 + 1)) % 256)
    @color.g = Math.abs((@color.g + Math.floor(Math.random() * 10 + 1) - Math.floor(Math.random() * 10 + 1)) % 256)
    @color.b = Math.abs((@color.b + Math.floor(Math.random() * 10 + 1) - Math.floor(Math.random() * 10 + 1)) % 256)

  draw: () ->
    if @mode == 0
      c = PS.BeadColor @x,@y
      c = PS.UnmakeRGB(c)
      c = PS.MakeRGB(Math.abs(c.r-255),Math.abs(c.g-255),Math.abs(c.b-255))
      PS.BeadColor @x, @y, c
      PS.BeadColor (GRID_SIZE-1)-@x, @y, c
    if @mode == 1
      c = PS.BeadColor @x,@y
      c = PS.UnmakeRGB(c)
      if c.g == 255
        c.g = 0
        c.b = 0
      else
        c.g = 255
        c.b = 255
      c = PS.MakeRGB(c.r,c.g,c.b)
      PS.BeadColor @x, @y, c
      PS.BeadColor (GRID_SIZE-1)-@x, @y, c
    if @mode == 2
      c = PS.MakeRGB(@color.r, @color.g,@color.b)
      PS.BeadColor @x, @y, c
      PS.BeadColor (GRID_SIZE-1)-@x, @y, c


  reset: () ->
    @x = GRID_SIZE/2
    @y = GRID_SIZE/2
    @mode = (@mode + 1) %3

  get_mode: () ->
    if @mode == 0
      return 'Black'
    else if @mode == 1
      return 'Red'
    else if @mode == 2
      return 'Colored'


#------------------------------------------ Constants -----------------------------------------
GRID_SIZE = 32

dot = new dot()

#------------------------------------------ Events -----------------------------------------

PS.Init = ->
  # change to the dimensions you want
  PS.GridSize GRID_SIZE, GRID_SIZE
  PS.BeadColor PS.ALL,PS.ALL, 0xffffff
  PS.StatusText "Rorschach (" + dot.get_mode() + ")"
  #hide the borders
  PS.BeadBorderWidth PS.ALL, PS.ALL, 0
  PS.BeadFlash PS.ALL, PS.ALL, false
  #start the clock
  PS.Clock(10)

PS.Click = (x, y, data) ->
  "use strict"
  PS.Clock(0)
  PS.BeadColor PS.ALL, PS.ALL, PS.COLOR_WHITE
  dot.reset()
  PS.StatusText "Rorschach (" + dot.get_mode() + ")"
  PS.Clock(10)

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


