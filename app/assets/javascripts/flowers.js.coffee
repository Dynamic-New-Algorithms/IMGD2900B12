### oppen to puplic use ###
jQuery ->
  if jQuery('#name').html() == 'Flowers'
    #------------------------------------ Classes -------------------------------------
    class sun
      constructor: () ->
        @x =2
        @y = 2
        @moved = true
        @down = false

      draw: () ->
        if @moved
          PS.BeadColor @x,@y, 0xffff00
          PS.BeadColor @x+1,@y, 0xffffdd
          PS.BeadColor @x-1,@y, 0xffffdd
          PS.BeadColor @x,@y-1, 0xffffdd
          PS.BeadColor @x,@y+1, 0xffffdd
          @moved = false

      move: (x,y) ->
        PS.BeadColor @x,@y, 0xffffff
        PS.BeadColor @x+1,@y, 0xffffff
        PS.BeadColor @x-1,@y, 0xffffff
        PS.BeadColor @x,@y-1, 0xffffff
        PS.BeadColor @x,@y+1, 0xffffff
        @x = Math.min(Math.max(x,1),GRID_SIZE-2)
        @y = Math.min(Math.max(y,1),GRID_SIZE-3)
        @moved = true

    class seed

      constructor: () ->
        @x = -1
        @y = -1




    #------------------------------------------ Constants -----------------------------------------
    GRID_SIZE = 16

    sun = new sun()

    dirt = ->
      for i in [0..GRID_SIZE-1]
        PS.BeadColor i , GRID_SIZE-1, 0x964B00


    #------------------------------------------ Events -----------------------------------------

    PS.Init = ->
      # change to the dimensions you want
      PS.GridSize GRID_SIZE, GRID_SIZE
      PS.StatusText "Flowers"
      #hide the borders
      PS.BeadBorderWidth PS.ALL, PS.ALL, 0
      PS.BeadFlash PS.ALL, PS.ALL, false
      #start the clock
      dirt()
      PS.Clock(10)

    PS.Click = (x, y, data) ->
      "use strict"
      PS.BeadColor x, y, 0xff0000
      if x == sun.x and y == sun.y
        sun.down = true


    PS.Release = (x, y, data) ->
      "use strict"
      sun.down = false


    PS.Enter = (x, y, data) ->
      "use strict"
      if sun.down
        sun.move(x,y)

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
      sun.draw()
      #fade.draw()


