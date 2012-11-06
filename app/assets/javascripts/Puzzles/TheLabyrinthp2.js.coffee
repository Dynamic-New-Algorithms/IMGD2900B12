### oppen to puplic use ###
jQuery ->
  if jQuery('#name').html() == 'TheLabyrinthp2'
    alert 'ok'
    #------------------------------------ Classes -------------------------------------
    #------------------------------------ helper funtions -----------------------------
    shuffle = (list) ->
      new_list = []
      for i in [0..list.length-1]
        new_list.push list[i]
      for i in [0..new_list.length-1]
        j = Math.floor(Math.random()*new_list.length)
        temp = new_list[i]
        new_list[i] = new_list[j]
        new_list[j] = temp
      return new_list

    debug = (response) ->
      property_names = ""
      for propertyName of response
        # propertyName is what you want
        property_names += propertyName + " = " + response[propertyName] + "\n"
      alert property_names
    #------------------------------------------ Constants -----------------------------------------
    G =
      GRID:
        Width: 16
        Height: 16
      BOARD:
        X_min: 1
        Y_min: 0
        X_max: 14
        Y_max: 15
      COLORS:
        PLAYER: 0x0000ff
        START: 0xff0000
        END: 0x22aa00
        GROUND: 0xAB9588
      STATUS:
        CYCLE: 20
        Current: 0
        VALUES: ['The Labyrinth', 'WASD or arrows to move.','Space to pick up or put down walls.']
      DIFICCULTY:
        Rules: 10
        Walls: 0.70
        Wall_types: 1
      Mode: 'play'
      Walls: [new wall('brick',0xA50021,'b',0xf56081), new wall('hedge',0x00a521,'h',0x60f581),new wall('river',0x0021a5,'r',0x6081f5)]
      Player: new player()
      Shifts: []
      Tick: 0 #keeps track of how many tick the game has had

    #Color 1 -- RGB: 210, 194, 153 / HEX: D2C299
    #Color 2 -- RGB: 171, 149, 136 / HEX: AB9588
    #Color 3 -- RGB: 156, 117, 82 / HEX: 9C7552
    #Color 4 -- RGB: 114, 93, 65 / HEX: 725D41
    #Color 5 -- RGB: 133, 100, 78 / HEX: 85644E
    #------------------------------------------ pre PS.init init --------------------------------------


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




