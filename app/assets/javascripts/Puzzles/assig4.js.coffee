### oppen to puplic use ###
jQuery ->
  if jQuery('#name').html() == 'Assig4Puzzle'
    #------------------------------------ Classes -------------------------------------
    class wall
      #the wall is the main blocker of the player moving
      constructor: (kind) ->
        @kind = kind

    class shift_rule
      #these rulls controll how the walls with shift around

      constructor: (center,n,ne,e,se,s,sw,w,nw) ->
        @grid =
          center: center
          north: n
          north_east: ne
          east: e
          south_east: se
          south: s
          south_west: sw
          west: w
          north_west: nw
      #implements this rull on the bead at the given codenets
      implement_rule: (x,y)->

    #------------------------------------------ Constants -----------------------------------------
    G =
      GRID:
        Width: 16
        Height: 16


    #------------------------------------------ Events -----------------------------------------

    PS.Init = ->
      # change to the dimensions you want
      PS.GridSize G.GRID.Width, G.GRID.Height


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


