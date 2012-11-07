### oppen to puplic use ###
jQuery ->
  if jQuery('#name').html() == 'TheLabyrinthp2'
    #------------------------------------ Classes -------------------------------------
    #the wall class makes the walls of the maze
    class wall
      constructor: (name,moveable,color,up_color) ->
        @name = name
        @moveable = moveable
        @color = color
        @up_color = up_color

      draw: (x,y) ->
        PS.BeadColor x,y, @color
    #this class keeps track of the player and if they can move
    class player
      constructor: () ->
        @loc =
          x: 0
          y: 0
        #1,0 -> east, 0,1 - > sout, -1,0 -> west, 0,-1 -> north
        @facing =
          x: 0
          y: 1
        @wall = -1 #-1 -> no wall
      @moved = false

      draw: () ->
        glyph = '↓'
        glyph = '↑' if @facing.y == -1
        glyph = '←' if @facing.x == -1
        glyph = '→' if @facing.x == 1
        PS.BeadColor @loc.x,@loc.y, G.COLORS.PLAYER
        PS.BeadGlyph @loc.x,@loc.y, glyph
        if @wall >= 0
          w = G.Walls[@wall]  #grab the wall
          PS.BeadColor @loc.x+@facing.x, @loc.y+@facing.y, w.up_color #draw the wall
      #this will move the player or rotate checking for collisions
      move: (delta_x,delta_y) ->
        @moved = true
        if @wall >= 0 #we have to tak into acount the wall
          # #check to see if we are facing that way
          if @facing.x == delta_x and @facing.y == delta_y
            #check to see if we can move
            if @loc.x+2*delta_x >= G.BOARD.X_min and @loc.x+2*delta_x <= G.BOARD.X_max and @loc.y+2*delta_y >= G.BOARD.Y_min and @loc.y+2*delta_y <= G.BOARD.Y_max
              d1 = PS.BeadData @loc.x+delta_x,@loc.y+delta_y
              d2 = PS.BeadData @loc.x+(2*delta_x),@loc.y+(2*delta_y)
              if d1<0 and d2<0 #nothing obstructing us
                @loc.x += delta_x
                @loc.y += delta_y
              else #we ran into a wall
                PS.AudioPlay G.AUDIO.RUN_INTO_WALL
            else #we ran into a wall
              PS.AudioPlay G.AUDIO.RUN_INTO_WALL
          else if Math.abs(@facing.x) == Math.abs(delta_x) and Math.abs(@facing.y) == Math.abs(delta_y) #we are facing in 180
            #how to pull a block backwards
            if @loc.x+delta_x >= G.BOARD.X_min and @loc.x+delta_x <= G.BOARD.X_max and @loc.y+delta_y >= G.BOARD.Y_min and @loc.y+delta_y <= G.BOARD.Y_max
              d = PS.BeadData @loc.x+delta_x,@loc.y+delta_y
              if d < 0 #there is no wall and we can move
                @loc.x += delta_x
                @loc.y += delta_y
              else #we ran into a wall
                PS.AudioPlay G.AUDIO.RUN_INTO_WALL
            else #we ran into a wall
              PS.AudioPlay G.AUDIO.RUN_INTO_WALL
          else #we want to rotate
            d = PS.BeadData @loc.x+delta_x,@loc.y+delta_y
            if d < 0 #there is no wall and we can move
              @facing.x = delta_x
              @facing.y = delta_y
            else #we ran into a wall
              PS.AudioPlay G.AUDIO.RUN_INTO_WALL
        else #we don't have a wall
          #check to see if we are facing that way
          if @facing.x == delta_x and @facing.y == delta_y
            #we are facing that way now check to see if we can move
            if @loc.x+delta_x >= G.BOARD.X_min and @loc.x+delta_x <= G.BOARD.X_max and @loc.y+delta_y >= G.BOARD.Y_min and @loc.y+delta_y <= G.BOARD.Y_max
              d = PS.BeadData @loc.x+delta_x,@loc.y+delta_y
              if d < 0 #there is no wall and we can move
                @loc.x += delta_x
                @loc.y += delta_y
              else #we ran into a wall
                PS.AudioPlay G.AUDIO.RUN_INTO_WALL
            else if @loc.x+delta_x >= G.BOARD.X_min-1 and @loc.x+delta_x <= G.BOARD.X_max+1 and @loc.y+delta_y >= G.BOARD.Y_min and @loc.y+delta_y <= G.BOARD.Y_max
              #play win sound if we mad it to the end
              if @loc.x <= G.BOARD.X_max and @loc.x+delta_x > G.BOARD.X_max
                PS.AudioPlay G.AUDIO.WIN
              @loc.x += delta_x
              @loc.y += delta_y
            else #somthing went wrong
              PS.AudioPlay G.AUDIO.RUN_INTO_WALL
          else #we are not facing that direction so rotate
            @facing.x = delta_x
            @facing.y = delta_y
      #allows the player to pick up moveable blocks and put them down again
      pick_up_put_dow: () ->
        if @wall >= 0 #we have to put this one down
          PS.BeadData @loc.x+@facing.x,@loc.y+@facing.y, @wall
          @wall = -1
          PS.AudioPlay G.AUDIO.PUT_DOWN
        else
          #we need to pick up
          #check to se if our focus is in the game board
          if @loc.x+@facing.x >= G.BOARD.X_min and @loc.x+@facing.x <= G.BOARD.X_max and @loc.y+@facing.y >= G.BOARD.Y_min and @loc.y+@facing.y <= G.BOARD.Y_max
            #check to see if there is a wall
            d = PS.BeadData @loc.x+@facing.x,@loc.y+@facing.y
            if d >= 0
              if G.Walls[d].moveable #there is a wall
                PS.BeadData @loc.x+@facing.x,@loc.y+@facing.y, -1
                PS.AudioPlay G.AUDIO.PICK_UP
                @wall = d
              else
                PS.AudioPlay G.AUDIO.CANT_PICK_UP


    #this class handles wall that will shift in the night time
    class shift_rule
    #expected format is an aray [center,north,north east...north west] for each left and right the sound is what will get played when this rull happens
      constructor: (left,right,sound) ->
        @left = left
        @right = right
        @sound = sound

      #implements the rule if it is aplicable
      implemnt: (x,y) ->
        #check if the left cent is valid
        center_data = PS.BeadData x,y
        if center_data == @left[0]
          can_look_north = y > G.BOARD.Y_min
          can_look_south = y < G.BOARD.Y_max
          can_look_east = x < G.BOARD.X_max
          can_look_west = x > G.BOARD.X_min

          #now check if the rest of the directions are valid
          valid = true
          if can_look_north
            valid = valid and @left[1] == PS.BeadData(x,y-1)
          else
            valid = valid and(@left[1] == -1 and @right[1] ==[-1])
          #north east
          if can_look_north and can_look_east
            valid = valid and @left[2] == PS.BeadData(x+1,y-1)
          else
            valid = valid and(@left[2] == -1 and @right[2] ==[-1])
          #east
          if can_look_east
            valid = valid and @left[3] == PS.BeadData(x+1,y)
          else
            valid = valid and(@left[3] == -1 and @right[3] ==[-1])
          #south east
          if can_look_south and can_look_east
            valid = valid and @left[4] == PS.BeadData(x+1,y+1)
          else
            valid = valid and(@left[4] == -1 and @right[4] ==[-1])
          #south
          if can_look_south
            valid = valid and @left[5] == PS.BeadData(x+0,y+1)
          else
            valid = valid and(@left[5] == -1 and @right[5] ==[-1])
          #south west
          if can_look_south and can_look_west
            valid = valid and @left[6] == PS.BeadData(x-1,y+1)
          else
            valid = valid and(@left[6] == -1 and @right[6] ==[-1])
          #west
          if can_look_west
            valid = valid and @left[7] == PS.BeadData(x-1,y)
          else
            valid = valid and(@left[7] == -1 and @right[7] ==[-1])
          #north west
          if can_look_north and can_look_west
            valid = valid and @left[8] == PS.BeadData(x-1,y-1)
          else
            valid = valid and(@left[8] == -1 and @right[8] ==[-1])

          if valid
            #alert 'ok'
            #check if we colide with the player or his block
            player_x = G.Player.loc.x
            player_w = 0
            player_w += 1 if Math.abs(G.Player.facing.x) == 1 and G.Player.wall >= 0
            player_x -= 1 if G.Player.facing.x < 0
            player_y = G.Player.loc.y
            player_h = 0
            player_h += 1 if  Math.abs(G.Player.facing.y) == 1 and G.Player.wall >= 0
            player_y -= 1 if G.Player.facing.y < 0
            #see if that box is in the zone we are trying to implement
            #alert ((player_x + player_w) + ' >= ' +  (x-1) + ' and ' + (player_x) + ' <= ' + (x+1)) + ' and ' + ((player_y+player_h) + ' >= ' + (y-1) + ' and ' + (player_y) <= (y+1))
            if ((player_x + player_w) >= (x-1) and (player_x) <= (x+1)) and ((player_y+player_h) >= (y-1) and (player_y) <= (y+1))
              #we may colid with the player
              return false
            else #we will not colide with the player
              PS.AudioPlay @sound
              #implement the rule
              PS.BeadData x,y, @right[0]
              PS.BeadData x,y-1, @right[1] if can_look_north
              PS.BeadData x+1,y-1, @right[2] if can_look_north and can_look_east
              PS.BeadData x+1,y, @right[3] if can_look_east
              PS.BeadData x+1,y+1, @right[4] if can_look_south and can_look_east
              PS.BeadData x,y+1, @right[5] if can_look_south
              PS.BeadData x-1,y+1, @right[6] if can_look_south and can_look_west
              PS.BeadData x-1,y, @right[7] if can_look_west
              PS.BeadData x-1,y-1, @right[8] if can_look_north and can_look_west


    #------------------------------------ helper funtions -----------------------------
    draw_start_and_end_and_controls = () ->
      start_letters = ['S','T','A','R','T',' ']
      end_letters = ['E','N','D',' ']
      for y in [G.BOARD.Y_min..G.BOARD.Y_max]
        PS.BeadColor 0,y, G.COLORS.START
        PS.BeadGlyph 0,y, start_letters[y%start_letters.length]
        PS.BeadGlyph G.GRID.Width-1,y, end_letters[y%end_letters.length]
        PS.BeadColor G.GRID.Width-1,y, G.COLORS.END

      for x in [0..(G.GRID.Width-1)]
        PS.BeadColor x, G.GRID.Height-1, 0x00000

      PS.BeadGlyph 0, (G.GRID.Height-1), '☠'
      PS.BeadGlyph (G.GRID.Width-1),(G.GRID.Height-1), '♪' if G.Music_Playing
      PS.BeadGlyph (G.GRID.Width-1),(G.GRID.Height-1), '♫' if G.Music_Playing == false

    load_level = () ->
      level = G.Levels[G.Current_Level]
      #change the status
      G.STATUS.Current = 0
      G.STATUS.Values = level.status
      #change the grid size
      G.BOARD.X_max = level.board[0].length
      G.BOARD.Y_max = level.board.length - 1
      G.GRID.Width = G.BOARD.X_max + 2
      G.GRID.Height = G.BOARD.Y_max + 2
      #change the grid size
      PS.GridSize G.GRID.Width, G.GRID.Height
      #turn of flash and borders
      PS.BeadBorderWidth PS.ALL,PS.ALL, 0
      PS.BeadFlash PS.ALL,PS.ALL, false
      #draw the zones
      draw_start_and_end_and_controls()
      #place the walls
      for y in [0..level.board.length-1]
        for x in [0..level.board[y].length-1]
          PS.BeadData x+1,y, level.board[y][x]

      #reset the player
      G.Player = new player()

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
    movable = true
    not_movable = false
    f = -1
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
      AUDIO:
        RUN_INTO_WALL: 'perc_drum_snare'
        WIN: 'fx_tada'
        RESTART: 'fx_wilhelm'
        PICK_UP: 'fx_swoosh'
        PUT_DOWN: 'fx_bang'
        CANT_PICK_UP: 'fx_hoot'
      STATUS:
        CYCLE: 300
        Current: 0
        Values: ['The Labyrinth','By Dynamic New Algorithms']
      Walls: [new wall('solid',not_movable,0x725D41,0x725D41),
              new wall('soft',movable, 0x00a521, 0x60f581),
              new wall('soft',movable, 0x0021a5, 0x6081f5)
            ]
      Player: new player()
      Shifts: []
      Tick: 0 #keeps track of how many tick the game has had
      Music_index: 0
      Music_Playing: true
      Music: [4,0]
      Current_Level: 0
      Levels: [
              ( #start declartng level one
                status: ['The Labyrinth: Level one', 'WASD or arrows to move.']
                rules: [] #these are the rules that will be implemented
                board: [
                        ([0,0,0,0,0,0,0,0,0,0,0,0]),
                        ([0,0,f,f,f,f,f,0,0,0,0,0]),
                        ([0,0,f,0,0,0,f,0,0,0,0,0]),
                        ([f,f,f,0,0,0,f,0,0,0,0,0]),
                        ([0,0,0,0,0,0,f,0,0,0,0,0]),
                        ([0,0,0,f,f,f,f,0,0,0,0,0]),
                        ([0,0,0,f,0,0,0,0,0,0,0,0]),
                        ([0,0,0,f,f,f,f,f,f,f,f,f]),
                        ([0,0,0,0,0,0,0,0,0,0,0,0])
                      ]
              ),
              ( #start declartng level one
                status: ['The Labyrinth: Level two', 'Space to pick up and put down walls.']
                rules: [] #these are the rules that will be implemented
                board: [
                  ([0,0,0,0,0,0,0,0,0,0,0,0]),
                  ([0,0,0,f,f,f,f,f,f,f,f,f]),
                  ([0,0,0,f,0,0,0,0,0,0,0,0]),
                  ([f,f,f,1,f,f,f,0,0,0,0,0]),
                  ([0,0,0,0,0,0,0,0,0,0,0,0])
                ]
              ),
              ( #start declartng level one
                status: ['The Labyrinth: Level three', 'You can pull blocks.']
                rules: [] #these are the rules that will be implemented
                board: [
                  ([0,0,0,0,0,0,0,0,0,0,0,0]),
                  ([0,0,0,0,0,0,0,f,f,f,f,f]),
                  ([0,0,0,f,f,f,0,f,0,0,0,0]),
                  ([f,f,f,f,f,f,f,1,0,0,0,0]),
                  ([0,0,0,0,0,0,0,0,0,0,0,0])
                ]
              ),
              ( #start declartng level one
                status: ['The Labyrinth: Level four', 'You can turn 90° with a wall.']
                rules: [] #these are the rules that will be implemented
                board: [
                  ([0,0,0,0,0,0,0,0,0,0,0,0]),
                  ([f,f,f,1,f,f,f,f,f,f,f,f]),
                  ([0,0,0,f,0,0,0,0,0,0,0,0]),
                  ([0,0,0,0,0,0,0,0,0,0,0,0])
                ]
              ),
              ( #start declartng level one
                status: ['The Labyrinth: Level five', 'Some times walls will move.','Stuck click the skull.']
                rules: [
                  new shift_rule(([0,f,f,0,0,0,1,0,f]),([0,1,f,0,0,0,f,0,f]),'fx_silencer')
                ] #these are the rules that will be implemented
                board: [
                  ([0,0,0,0,0,0,0,0,0,0,0,0]),
                  ([0,0,0,0,0,f,f,f,f,f,f,f]),
                  ([0,0,0,0,0,f,0,0,0,0,0,0]),
                  ([f,f,f,f,f,1,f,0,0,0,0,0]),
                  ([0,0,f,0,0,0,0,0,0,0,0,0]),
                  ([0,0,0,0,0,0,0,0,0,0,0,0])
                ]
              ),
              ( #start declartng level one
                status: ['The Labyrinth: Level six']
                rules: [ ] #these are the rules that will be implemented
                board: [
                  ([0,0,0,0,0,0,0,f,0,0,0,0,0,0,f,0]),
                  ([0,f,f,f,f,f,f,f,0,f,f,f,0,f,f,0]),
                  ([0,f,0,0,0,f,0,f,0,0,0,f,f,f,0,0]),
                  ([0,f,0,f,f,f,0,f,f,0,0,f,0,f,0,0]),
                  ([0,f,0,0,0,0,0,0,f,f,0,f,0,f,0,0]),
                  ([0,f,f,f,f,f,f,f,0,f,f,f,0,f,f,f]),
                  ([0,f,0,f,0,0,0,f,0,0,0,0,0,0,0,f]),
                  ([f,f,0,0,f,0,f,f,f,f,0,f,f,f,f,0]),
                  ([f,f,f,f,f,0,f,0,0,0,f,f,0,f,0,0]),
                  ([0,0,0,0,f,0,f,f,0,f,f,0,0,f,0,0]),
                  ([0,f,f,0,f,0,0,0,0,f,0,0,0,0,0,0]),
                  ([0,f,0,0,f,0,f,f,f,f,f,f,f,f,f,0]),
                  ([0,f,f,f,f,0,f,0,0,0,0,0,0,0,f,0]),
                  ([0,0,f,0,0,0,f,0,f,0,f,f,f,0,f,0]),
                  ([0,f,f,f,f,f,f,0,f,f,f,0,f,f,f,0]),
                  ([0,0,0,0,0,0,f,0,0,0,0,0,0,0,0,0])
                ]
              ),
              ( #start declartng level one
                status: ['The Labyrinth: Level seven','Green dose not like to be in a corner.','The power of H.','Blue falls.']
                rules: [
                  new shift_rule(([1,0,0,0,0,0,0,f,0]),([0,0,0,0,0,0,f,f,1]),'fx_silencer'),
                  new shift_rule(([0,f,f,0,0,0,1,0,f]),([0,f,1,0,0,0,f,0,f]),'fx_silencer'),
                  new shift_rule(([1,0,0,0,f,f,f,0,0]),([f,0,1,0,f,f,f,0,0]),'fx_silencer'),
                  new shift_rule(([1,0,0,0,0,0,f,0,0]),([1,f,f,1,1,1,1,1,f]),'fx_silencer'),
                  new shift_rule(([1,f,1,1,1,f,1,1,1]),([f,f,f,f,2,2,2,f,f]),'fx_bomb2'),
                  new shift_rule(([2,f,f,2,0,0,0,2,f]),([f,f,f,f,2,2,2,f,f]),'fx_gun'),
                ] #these are the rules that will be implemented
                board: [
                  ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]),
                  ([0,0,0,0,0,0,0,0,0,f,f,1,0,0,0,0]),
                  ([0,0,0,0,0,0,0,0,0,0,f,0,0,0,0,0]),
                  ([0,0,0,0,0,0,f,0,0,0,f,f,f,0,0,0]),
                  ([0,f,f,f,f,f,f,f,0,0,f,f,f,0,0,0]),
                  ([0,f,0,0,0,0,0,0,0,0,f,f,f,0,0,0]),
                  ([0,f,0,0,f,0,0,0,0,0,0,0,0,0,0,0]),
                  ([0,f,f,f,f,0,0,0,0,0,0,0,0,0,0,0]),
                  ([0,f,0,0,f,0,0,0,0,0,0,0,0,0,0,0]),
                  ([0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0]),
                  ([f,f,f,f,f,f,0,0,0,0,1,1,1,0,f,f]),
                  ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,f,0]),
                  ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,f,0]),
                  ([0,0,0,0,0,0,0,0,0,0,0,0,0,f,f,0]),
                  ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
                ]
              )
              ]
    #DNA_MUSIC.Load()

    #Color 1 -- RGB: 210, 194, 153 / HEX: D2C299
    #Color 2 -- RGB: 171, 149, 136 / HEX: AB9588
    #Color 3 -- RGB: 156, 117, 82 / HEX: 9C7552
    #Color 4 -- RGB: 114, 93, 65 / HEX: 725D41
    #Color 5 -- RGB: 133, 100, 78 / HEX: 85644E
    #------------------------------------------ pre PS.init init --------------------------------------

    #------------------------------------------ Events -----------------------------------------

    PS.Init = ->
      "use strict"
      load_level()
      PS.StatusText G.STATUS.Values[G.STATUS.Current]
      PS.Clock 1

    PS.Click = (x, y, data) ->
      "use strict"
      if y == G.GRID.Height-1
        if x == 0
          PS.AudioPlay G.AUDIO.RESTART
          load_level()
          PS.StatusText G.STATUS.Values[G.STATUS.Current]
        else if x == G.GRID.Width-1
          if G.Music_Playing
            G.Music_Playing = false
          else
            G.Music_Playing = true
          PS.BeadGlyph (G.GRID.Width-1),(G.GRID.Height-1), '♪' if G.Music_Playing
          PS.BeadGlyph (G.GRID.Width-1),(G.GRID.Height-1), '♫' if G.Music_Playing == false

    PS.Release = (x, y, data) ->
      "use strict"

    PS.Enter = (x, y, data) ->
      "use strict"

    PS.Leave = (x, y, data) ->
      "use strict"

    PS.KeyDown = (key, shift, ctrl) ->
      "use strict"
      if key == 87 or key == PS.ARROW_UP
        G.Player.move(0,-1)
      else if key == 68 or key == PS.ARROW_RIGHT
        G.Player.move(1,0)
      else if key == 83 or key == PS.ARROW_DOWN
        G.Player.move(0,1)
      else if key == 65 or key == PS.ARROW_LEFT
        G.Player.move(-1,0)
      else if key == 32
        G.Player.pick_up_put_dow()

    PS.KeyUp = (key, shift, ctrl) ->
      "use strict"

    PS.Wheel = (dir) ->
      "use strict"

    PS.Tick = ->
      "use strict"
      #update tick counter
      G.Tick += 1
      if G.Tick >= 3600
        G.Tick = 0

      #play music
      if G.Tick % 15 == 0 and G.Music_Playing
        last_note = G.Music
        key = last_note[0]*12 + last_note[1]
        go = 1
        go = -1 if Math.random()*(last_note[0]-1) > Math.random()*(7-last_note[0])
        note = (key - 12*Math.floor(key/12))
        scale = [0-note,2-note,3-note,5-note,6-note,8-note,11-note,12-note]
        key = key + (go * scale[Math.floor(Math.random()*scale.length)])
        key = Math.max(9,Math.min(97,key))
        key = [Math.floor(key/12),(key - 12*Math.floor(key/12))]
        PS.AudioPlay DNA_MUSIC.Piano[key[0]][key[1]]
        G.Music = key
      #change status
      if G.Tick % G.STATUS.CYCLE == 0
        G.STATUS.Current = (G.STATUS.Current+1) % G.STATUS.Values.length
        PS.StatusText G.STATUS.Values[G.STATUS.Current]
      #update the screen if we have moved or the time is right
      if G.Player.moved or G.Tick % 10 == 0
        #clear the screen
        PS.BeadColor PS.ALL,PS.ALL, G.COLORS.GROUND
        PS.BeadGlyph PS.ALL,PS.ALL, ' '
        #draw the zones again
        draw_start_and_end_and_controls()
        #draw the walls
        de = ''
        for x in [G.BOARD.X_min..G.BOARD.X_max]
          for y in [G.BOARD.Y_min..G.BOARD.Y_max]
            #if we have rules implement them
            for r in [0..G.Levels[G.Current_Level].rules.length-1]
              if r >= 0  and r < G.Levels[G.Current_Level].rules.length
                G.Levels[G.Current_Level].rules[r].implemnt(x,y)
            #draw the walls

            d = PS.BeadData x,y
            de = de + ', ' + d
            PS.BeadColor x,y, G.Walls[d].color if d >= 0 and d < G.Walls.length
        #draw the player
        G.Player.draw()
        #check for a victory
        if G.Player.loc.x > G.BOARD.X_max
          G.Current_Level = (G.Current_Level + 1) % G.Levels.length
          load_level()
          PS.StatusText G.STATUS.Values[G.STATUS.Current]






