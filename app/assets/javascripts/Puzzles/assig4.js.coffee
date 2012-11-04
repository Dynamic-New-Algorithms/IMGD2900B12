### oppen to puplic use ###
jQuery ->
  if jQuery('#name').html() == 'Assig4Puzzle'
    #------------------------------------ Classes -------------------------------------
    class wall
      #the wall is the main blocker of the player moving
      constructor: (name,color,glyph,up_color) ->
        @name = name
        @color = color
        @glyph = glyph
        @up_color = up_color

      draw: (x,y) ->
        PS.BeadColor x,y,@color
        PS.BeadGlyph x,y,@glyph
        PS.BeadBorderWidth x,y,1

    class shift_rule
      #these rulls controll how the walls with shift around
      constructor: (center,n,ne,e,se,s,sw,w,nw,result_center,result_n,result_ne,result_e,result_se,result_s,result_sw,result_w,result_nw) ->
        @left_array = [center,n,ne,e,se,s,sw,w,nw]
        @right_array = [result_center,result_n,result_ne,result_e,result_se,result_s,result_sw,result_w,result_nw]
        @left =
          center: center
          north: n
          north_east: ne
          east: e
          south_east: se
          south: s
          south_west: sw
          west: w
          north_west: nw
        @right =
          center: result_center
          north: result_n
          north_east: result_ne
          east: result_e
          south_east: result_se
          south: result_s
          south_west: result_sw
          west: result_w
          north_west: result_nw
      #implements this rull on the bead at the given codenets
      implement_rule: (x,y)->
        cd = PS.BeadData x,y #center data
        if cd != null and cd == @left.center #make sure that the centers match
          can_look_north = y > G.BOARD.Y_min
          can_look_south = y < G.BOARD.Y_max
          can_look_east = x < G.BOARD.X_max
          can_look_west = x > G.BOARD.X_min

          #alert 'north ' + can_look_north + ', east ' + can_look_east + ', south ' + can_look_south + ', west ' + can_look_west

          #make sure that if we can't look in a direction that it dosn't matter
          valid = true
          valid = valid and (@right.north == 0 and @right.north_east == 0 and @right.north_west == 0) if  can_look_north == false
          valid = valid and (@right.south == 0 and @right.sourth_east == 0 and @right.south.west == 0) if can_look_south == false
          valid = valid and (@right.east == 0 and @right.north_east == 0 and @right.south_east == 0) if can_look_east == false
          valid = valid and (@right.west == 0 and @right.north_west == 0 and @right.south_west == 0) if can_look_west == false

          if valid
            #alert 'we can look '
            if can_look_north
              nd = PS.BeadData x,y-1
              valid = valid and nd == @left.north
            if can_look_north and can_look_east
              ned = PS.BeadData x+1,y-1
              valid = valid and ned == @left.north_east
            if can_look_east
              ed = PS.BeadData x+1,y
              valid = valid and ed == @left.east
            if can_look_south and can_look_east
              sed = PS.BeadData x+1,y+1
              valid = valid and sed == @left.south_east
            if can_look_south
              sd = PS.BeadData x,y+1
              valid = valid and sd == @left.south
            if can_look_south and can_look_west
              swd = PS.BeadData x-1,y+1
              valid = valid and swd == @left.south_west
            if can_look_west
              wd = PS.BeadData x-1,y
              valid = valid and wd == @left.west
            if can_look_north and can_look_east
              nwd = PS.BeadData x-1,y-1
              valid = valid and nwd == @left.north_west
            #end of looking at the left side of the rule now if valid make the changes in bead data
            #now look to see if we will colid with player
            valid = valid and G.Player.dose_colide(x,y-1) if can_look_north and @right.north != 0
            valid = valid and G.Player.dose_colide(x+1,y-1) if can_look_north and can_look_east and @right.north_east != 0
            valid = valid and G.Player.dose_colide(x+1,y) if can_look_east and @right.east != 0
            valid = valid and G.Player.dose_colide(x+1,y+1) if can_look_east and can_look_south and @right.south_east != 0
            valid = valid and G.Player.dose_colide(x,y+1) if can_look_south and @right.south != 0
            valid = valid and G.Player.dose_colide(x-1,y+1) if can_look_south and can_look_west and @right.south_west != 0
            valid = valid and G.Player.dose_colide(x-1,y) if can_look_west and @right.west != 0
            valid = valid and G.Player.dose_colide(x-1,y-1) if can_look_north and can_look_west and @right.north_east != 0
            #alert 'do we match? ' + valid
            if valid
              PS.BeadData x,y,@right.center
              PS.BeadData x,y-1,@right.north if can_look_north
              PS.BeadData x+1,y-1,@right.north_east if can_look_north and can_look_east
              PS.BeadData x+1,y, @right.east if can_look_east
              PS.BeadData x+1,y+1, @right.south_east if can_look_south and can_look_east
              PS.BeadData x,y+1,@right.south if can_look_south
              PS.BeadData x-1,y+1,@right.south_west if can_look_south and can_look_west
              PS.BeadData x-1,y, @right.west if can_look_west
              PS.BeadData x-1,y-1, @right.north_west if can_look_north and can_look_west

    class player
      #this calls manages the player data
      constructor: () ->
        @x = 0
        @y = 0
        @direction =
          x: 1
          y: 0
        @wall = 0
        @moved = true

      dose_colide: (x,y) ->
        if @x == x and @y == y
          return false
        if @wall != 0
          if @x + @direction.x == x and @y + @direction.y == y
            return false
        return true

      move: (direction) ->
        @moved = true
        if direction == 'down'
          if @direction.y == 1  #if we are facing that way then move down
            if @wall != 0
              if @y + 2 <= G.BOARD.Y_max
                if PS.BeadData( @x,(@y+2)) == 0
                  @y += 1
            else
              if @y + 1 <= G.BOARD.Y_max
                if PS.BeadData( @x,(@y+1)) == 0
                  @y += 1
          else #change direction
            if @wall != 0
              if @y + 1 <= G.BOARD.Y_max
                if PS.BeadData( @x,(@y+1)) == 0 and @direction.y != -1
                  @direction.x = 0
                  @direction.y = 1
            else
              @direction.x = 0
              @direction.y = 1
        else if direction == 'up'
          if @direction.y == -1 #move
            if @wall != 0
              if @y - 2 >= G.BOARD.Y_min
                if PS.BeadData( @x, (@y-2)) == 0
                  @y -= 1
            else
              if @y - 1 >= G.BOARD.Y_min
                if PS.BeadData( @x,(@y-1)) == 0
                  @y -= 1
          else #rotate
            if @wall != 0
              if @y - 1 >= G.BOARD.Y_min
                if PS.BeadData( @x,(@y-1)) == 0  and @direction.y != 1
                  @direction.x = 0
                  @direction.y = -1
            else
              @direction.x = 0
              @direction.y = -1
        else if direction == 'left'
          if @direction.x == -1 #move
            if @wall != 0
              if @x - 2 >= G.BOARD.X_min
                if PS.BeadData( (@x-2),@y) == 0
                  @x -= 1
            else
              if @x - 1 >= (G.BOARD.X_min-1)
                if PS.BeadData( (@x-1),@y) == 0
                  @x -= 1
          else #rotate
            if @wall != 0
              if @x - 1 >= G.BOARD.X_min-1
                if PS.BeadData( (@x-1),@y) == 0  and @direction.x != 1
                  @direction.x = -1
                  @direction.y = 0
            else
              @direction.x = -1
              @direction.y = 0
        else if direction == 'right'
          if @direction.x == 1 #move
            if @wall != 0
              if @x + 2 <= G.BOARD.X_max
                if PS.BeadData( (@x+2),@y) == 0
                  @x += 1
            else
              if @x + 1 <= (G.BOARD.X_max+1)
                if PS.BeadData( (@x+1),@y) == 0
                  @x += 1
          else #rotate
            if @wall != 0
              if @x + 1 <= G.BOARD.X_max
                if PS.BeadData( (@x+1),@y) == 0   and @direction.x != -1
                  @direction.x = 1
                  @direction.y = 0
            else
              @direction.x = 1
              @direction.y = 0

      pick_up: () ->
        x = @x + @direction.x
        y = @y + @direction.y
        if x >= G.BOARD.X_min and x <= G.BOARD.X_max and y >= G.BOARD.Y_min and y <= G.BOARD.Y_max
          bd = PS.BeadData x,y
          if @wall == 0 #pick up
            @wall = bd
            PS.BeadData x,y,0
          else if bd == 0 #put down
            PS.BeadData x,y,@wall
            @wall = 0

      draw: () ->
        glyph = '↓'
        glyph = '↑' if @direction.y == -1
        glyph = '←' if @direction.x == -1
        glyph = '→' if @direction.x == 1
        x = @x
        y = @y
        PS.BeadColor x,y, G.COLORS.PLAYER
        PS.BeadBorderWidth x,y, 1
        PS.BeadGlyph x,y, glyph
        if @wall > 0
          w = G.Walls[@wall - 1]
          if (x + @direction.x) >= G.BOARD.X_min and (x + @direction.x) <= G.BOARD.X_max and (y + @direction.y) >= G.BOARD.Y_min and (y+ @direction.y) <= G.BOARD.Y_max
            PS.BeadColor (x + @direction.x),(y + @direction.y), w.up_color
            PS.BeadGlyph (x + @direction.x),(y + @direction.y), w.glyph
            PS.BeadBorderWidth (x + @direction.x),(y + @direction.y), 1


    #------------------------------------------ Helper Functions ----------------------------------------
    update_board_constraints = () ->
      G.BOARD.X_max = G.GRID.Width - 2
      G.BOARD.Y_max = G.GRID.Height - 2
    draw_start_and_end = () ->
      start_letters = ['S','T','A','R','T',' ']
      end_letters = ['E','N','D',' ']
      for y in [G.BOARD.Y_min..G.BOARD.Y_max]
        PS.BeadColor 0,y, G.COLORS.START
        PS.BeadGlyph 0,y, start_letters[y%start_letters.length]
        PS.BeadGlyph G.GRID.Width-1,y, end_letters[y%end_letters.length]
        PS.BeadColor G.GRID.Width-1,y, G.COLORS.END

      draw_controls()

    draw_controls = () ->
      for x in [0..(G.GRID.Width-1)]
        PS.BeadColor x, G.GRID.Height-1, 0x00000

      PS.BeadGlyph 0, (G.GRID.Height-1), '⌂'
      PS.BeadGlyph 1, (G.GRID.Height-1), '↺'

    build_walls = () ->
      for x in [G.BOARD.X_min..G.BOARD.X_max]
        for y in [G.BOARD.Y_min..G.BOARD.Y_max]
          PS.BeadData x,y, (Math.floor(Math.random() * (G.Walls.length ))+1) if Math.random() <= G.DIFICCULTY.Walls
    #build a random set of rules
    generate_rules = () ->
      G.Shifts = []
      for i in [0..G.DIFICCULTY.Rules]
        valid = false
        center = Math.floor(Math.random() * G.DIFICCULTY.Wall_types + 1)
        left = [center,0,0,0,0,0,0,0,0]
        right = [0,0,0,0,0,0,0,0,0]
        while valid == false
          valid = true

          #number of peices
          n = 1 + Math.floor(Math.random() * 7)

          for ni in [1..n]
            s = Math.floor(Math.random() * 8) + 1
            while left[s] != 0
              s = (s+1)
              s = 1 if s >= left.length
            left[s] = Math.floor(Math.random() * G.DIFICCULTY.Wall_types + 1)
          for ni in [0..8]
            v = left[ni]
            s = Math.floor(Math.random() * 9)
            while right[s] != 0
              s = s + 1
              s = 0 if s >= right.length
            right[s] = v

          for i in [0..(G.Shifts.length)]
            if i < G.Shifts.length
              sub_valid = true
              for li in [0..8]
                sub_valid = sub_valid and G.Shifts[i].left_array[li] == left[li]
              valid = valid and (sub_valid == false)
              if valid == false
                break
        #now we are valid
        G.Shifts.push(new shift_rule(left[0],left[1],left[2],left[3],left[4],left[5],left[6],left[7],left[8],right[0],right[1],right[2],right[3],right[4],right[5],right[6],right[7],right[8]))

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
        END: 0x00ff00
        GROUND: 0xffffff
      STATUS:
        CYCLE: 300
        Current: 0
        VALUES: ['The Labyrinth', 'WASD or arrows to move.','Space to pick up or put down walls.']
      DIFICCULTY:
        Rules: 10
        Walls: 0.60
        Wall_types: 3
      Mode: 'play'
      Walls: [new wall('brick',0xA50021,'b',0xf56081), new wall('hedge',0x00a521,'h',0x60f581),new wall('river',0x0021a5,'r',0x6081f5)]
      Player: new player()
      Shifts: []
      Tick: 0 #keeps track of how many tick the game has had

    #------------------------------------------ pre PS.init init --------------------------------------


    #------------------------------------------ Events -----------------------------------------

    PS.Init = ->
      G.Player = new player()
      update_board_constraints()
      generate_rules()
      # change to the dimensions you want
      PS.GridSize G.GRID.Width, G.GRID.Height
      PS.StatusFade false
      PS.StatusText G.STATUS.VALUES[G.STATUS.Current]

      PS.BeadFlash PS.ALL,PS.ALL,false
      PS.BeadBorderWidth PS.ALL,PS.ALL,0

      build_walls()

      PS.Clock(1)

    PS.Click = (x, y, data) ->
      "use strict"
      if x = 1 and y == G.GRID.Height-1
        PS.Init()

    PS.Release = (x, y, data) ->
      "use strict"

    PS.Enter = (x, y, data) ->
      "use strict"

    PS.Leave = (x, y, data) ->
      "use strict"

    PS.KeyDown = (key, shift, ctrl) ->
      "use strict"
      if key == 87 or key == PS.ARROW_UP
        G.Player.move('up')
      else if key == 68 or key == PS.ARROW_RIGHT
        G.Player.move('right')
      else if key == 83 or key == PS.ARROW_DOWN
        G.Player.move('down')
      else if key == 65 or key == PS.ARROW_LEFT
        G.Player.move('left')
      else if key == 32
        G.Player.pick_up()

    PS.KeyUp = (key, shift, ctrl) ->
      "use strict"

    PS.Wheel = (dir) ->
      "use strict"

    PS.Tick = ->
      "use strict"
      #update the tick counter
      G.Tick = G.Tick + 1
      #update the status text
      if G.Tick % G.STATUS.CYCLE == 0
        PS.StatusText G.STATUS.VALUES[G.STATUS.Current]
        G.STATUS.Current =  (G.STATUS.Current + 1) % G.STATUS.VALUES.length
        G.Tick = 0
      if G.Player.moved or G.Tick % 15 == 0
        #clear the screen
        PS.BeadColor PS.ALL,PS.ALL, G.COLORS.GROUND
        PS.BeadBorderWidth PS.ALL,PS.ALL,0
        #draw the end zones
        draw_start_and_end()
        #redraw the walls and shift them
        for x in [G.BOARD.X_min..G.BOARD.X_max]
          for y in [G.BOARD.Y_min..G.BOARD.Y_max]
            if PS.BeadData( x,y ) > 0
              for i in [0..(G.Shifts.length)]
                if i < G.Shifts.length
                  rule = G.Shifts[i]
                  rule.implement_rule(x,y)
            bd = PS.BeadData x,y
            if bd > 0
              w = G.Walls[bd-1]
              w.draw(x,y)
        #redraw the player
        G.Player.draw()
        G.Player.moved = true
        if G.Player.x > G.BOARD.X_max
          alert 'Congradulations you won!'
          PS.Init()





