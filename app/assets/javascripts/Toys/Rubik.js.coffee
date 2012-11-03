### oppen to puplic use ###
jQuery ->
  if jQuery('#name').html() == 'Rubrik'
    #------------------------------------ Classes -------------------------------------
    class face
      constructor: (c,size) ->
        @color = c
        @spots = []
        for i in [1..size]
          r = []
          for j in [1..size]
            r.push(c)
          @spots.push(r)
        @size = size

      rotate: (direction)->
        s = []
        for i in [1..@size]
          r = []
          for j in [1..@size]
            r.push(0)
          s.push(r)
        for r in [0..(@size-1)]
          for c in [0..(@size-1)]
            if direction == 1
              s[r][c] = @spots[c][(@size-1)-r]
            else if direction == 0
              s[r][c] = @spots[(@size-1)-c][r]
        @spots = s

      draw: (x,y) ->
        xi = x
        yi = y
        for r in [0..(@size-1)]
          for c in [0..(@size-1)]
            co = PS.MakeRGB(@spots[r][c].r,@spots[r][c].g,@spots[r][c].b)
            PS.BeadColor xi, yi, co
            PS.BeadBorderWidth xi,yi, 1
            PS.BeadBorderColor xi,yi, 0x000000
            xi = xi + 1
          xi = x
          yi = yi + 1

    class cube
      constructor: (size) ->
        @fw = new face(CUBE_WHITE,size)
        @fr = new face(CUBE_RED,size)
        @fb = new face(CUBE_BLUE,size)
        @fg = new face(CUBE_GREEN,size)
        @fy = new face(CUBE_YELLOW,size)
        @fo = new face(CUBE_ORANGE,size)
        @size = size

      rotate: (face,slice,direction)->
        if face == 'A'
          if slice == 0
            #rotate fo
            @fo.rotate(Math.abs(1-direction))
          if slice == @size-1
            #rotate fr
            @fr.rotate(direction)
          temp = [0,0,0]
          temp2 = [0,0,0]
          if direction == 1
            #g -> w
            for i in [1..@size]
              temp[i-1] = @fw.spots[i-1][slice]
              @fw.spots[i-1][slice] = @fg.spots[i-1][slice]
            #w -> b
            for i in [1..@size]
              temp2[i-1] = @fb.spots[i-1][slice]
              @fb.spots[i-1][slice] = temp[i-1]
            #b -> y
            for i in [1..@size]
              temp[i-1] = @fy.spots[i-1][slice]
              @fy.spots[i-1][slice] = temp2[i-1]
            #y -> g
            for i in [1..@size]
              @fg.spots[i-1][slice] = temp[i-1]
          else if direction == 0
            #y -> b
            for i in [1..@size]
              temp[i-1] = @fb.spots[i-1][slice]
              @fb.spots[i-1][slice] = @fy.spots[i-1][slice]
            #b -> w
            for i in [1..@size]
              temp2[i-1] = @fw.spots[i-1][slice]
              @fw.spots[i-1][slice] = temp[i-1]
            #w -> g
            for i in [1..@size]
              temp[i-1] = @fg.spots[i-1][slice]
              @fg.spots[i-1][slice] = temp2[i-1]
            #g -> y
            for i in [1..@size]
              @fy.spots[i-1][slice] = temp[i-1]
        else if face == 'B'
          if slice == 0
            #rotate fo
            @fg.rotate(direction)
          if slice == @size-1
            #rotate fr
            @fb.rotate(Math.abs(1-direction))
          temp = [0,0,0]
          temp2 = [0,0,0]
          if direction == 1
            # o->w
            for i in [1..@size]
              temp[i-1] = @fw.spots[slice][i-1]
              @fw.spots[slice][i-1] = @fo.spots[slice][i-1]
            # w->r
            for i in [1..@size]
              temp2[i-1] = @fr.spots[slice][i-1]
              @fr.spots[slice][i-1] = temp[i-1]
            # r->y
            for i in [1..@size]
              temp[i-1] = @fy.spots[slice][i-1]
              @fy.spots[slice][i-1] = temp2[i-1]
            # y->o
            for i in [1..@size]
              @fo.spots[slice][i-1] = temp[i-1]
          else if direction == 0
            # o->y
            for i in [1..@size]
              temp[i-1] = @fy.spots[slice][i-1]
              @fy.spots[slice][i-1] = @fo.spots[slice][i-1]
            # y -> r
            for i in [1..@size]
              temp2[i-1] = @fr.spots[slice][i-1]
              @fr.spots[slice][i-1] = temp[i-1]
            # r -> w
            for i in [1..@size]
              temp[i-1] = @fw.spots[slice][i-1]
              @fw.spots[slice][i-1] = temp2[i-1]
            # w -> o
            for i in [1..@size]
              @fo.spots[slice][i-1] = temp[i-1]
        else if face == 'C'
          if slice == 0
            #rotate fy
            @fy.rotate(direction)
          if slice == @size-1
            #rotate fw
            @fw.rotate(Math.abs(1-direction))
          temp = [0,0,0]
          temp2 = [0,0,0]
          if direction == 1
            # g -> r
            for i in [1..@size]
              temp[i-1] = @fr.spots[i-1][(@size-1)-slice]
              @fr.spots[i-1][(@size-1)-slice] = @fg.spots[slice][i-1]
            # r -> b
            for i in [1..@size]
              temp2[i-1] = @fb.spots[(@size-1)-slice][(@size-1)-(i-1)]
              @fb.spots[(@size-1)-slice][(@size-1)-(i-1)] = temp[i-1]
            # b -> o
            for i in [1..@size]
              temp[i-1] = @fo.spots[(@size-1)-(i-1)][slice]
              @fo.spots[(@size-1)-(i-1)][slice] = temp2[i-1]
            # o -> g
            for i in [0..@size]
              @fg.spots[slice][i-1] = temp[i-1]
          else if direction == 0
            # g -> o
            for i in [1..@size]
              temp[i-1] =  @fo.spots[(@size-1)-(i-1)][slice]
              @fo.spots[(@size-1)-(i-1)][slice] = @fg.spots[slice][i-1]
            #o -> b
            for i in [1..@size]
              temp2[i-1] = @fb.spots[(@size-1)-slice][(@size-1)-(i-1)]
              @fb.spots[(@size-1)-slice][(@size-1)-(i-1)] = temp[i-1]
            # b -> r
            for i in [1..@size]
              temp[i-1] = @fr.spots[i-1][(@size-1)-slice]
              @fr.spots[i-1][(@size-1)-slice] = temp2[i-1]
            # r-> g
            for i in [0..@size]
              @fg.spots[slice][i-1] = temp[i-1]

      draw: () ->
        @fg.draw(@size+1,1)
        @fo.draw(1,@size+1)
        @fw.draw(@size+1,@size+1)
        @fr.draw(@size*2+1,@size+1)
        @fb.draw(@size+1,@size*2+1)
        @fy.draw(@size+1,@size*3+1)
        for i in [0..(@size-1)]
          PS.BeadGlyph (@size+1)+i,0,"↓"
          PS.BeadGlyph (@size+1)+i,(@size*4 + 1),"↑"
          PS.BeadGlyph 0,(@size+1)+i, "→"
          PS.BeadGlyph (@size*3+1),(@size+1)+i, "←"
          PS.BeadGlyph (@size),(1)+i, "→"
          PS.BeadGlyph (@size*2+1),(1)+i, "←"
        PS.BeadGlyph (@size*2+1 + Math.floor(@size/2)),(@size*2+1 + Math.floor(@size/2)), "↺"
        PS.BeadGlyph (@size*2+2 + Math.floor(@size/2)),(@size*2+1 + Math.floor(@size/2)), "⇑"
        PS.BeadGlyph (@size*2+3 + Math.floor(@size/2)),(@size*2+1 + Math.floor(@size/2)), "⇓"

      shuffle: () ->
        for i in [0..32]
          d = PS.Random(2) - 1
          f = 'A'
          p = PS.Random(3) - 1
          if p == 1
            f = 'B'
          else if p == 2
            f = 'C'
          s = PS.Random(@size) - 1
          this.rotate(f,s,d)
        this.draw()



    #------------------------------------------ Constants -----------------------------------------
    GRID_SIZE = 16

    CUBE_WHITE =
      r: 255
      g: 255
      b: 255
    CUBE_RED =
      r: 196
      g: 30
      b: 58
    CUBE_BLUE =
      r: 0
      g: 81
      b: 186
    CUBE_GREEN =
      r: 0
      g: 158
      b: 96
    CUBE_YELLOW =
      r: 255
      g: 213
      b: 0
    CUBE_ORANGE =
      r: 229
      g: 149
      b: 0

    cu = new cube(3)

    #------------------------------------------ Events -----------------------------------------

    PS.Init = ->
      # change to the dimensions you want
      PS.GridSize GRID_SIZE, GRID_SIZE
      PS.StatusText "Rubik's Cudbe"
      #hide the borders
      PS.DEFAULT_BG_COLOR = 0x888888
      PS.BeadBorderWidth PS.ALL, PS.ALL, 0
      PS.BeadColor PS.ALL, PS.ALL, PS.DEFAULT_BG_COLOR

      cu.draw()

    PS.Click = (x, y, data) ->
      "use strict"
      d = 1
      f = ' '
      s = 0
      if y == 0
        if x > cu.size and x < cu.size*2+1
          s = x - cu.size - 1
          f = 'A'
        d = 1
      else if y == cu.size*4+1
        if x > cu.size and x < cu.size*2+1
          s = x - cu.size - 1
          f = 'A'
        d = 0
      else if x == 0
        d = 1
        if y > cu.size and y < cu.size*2+1
          s = y - cu.size - 1
          f = 'B'
      else if x == cu.size*3+1
        d = 0
        if y > cu.size and y < cu.size*2+1
          s = y - cu.size - 1
          f = 'B'
      else if x == cu.size
        d = 1
        if y >0 and y < cu.size+1
          s = y - 1
          f = 'C'
      else if x == cu.size*2+1
        d = 0
        if y >0 and y < cu.size+1
          s = y - 1
          f = 'C'

      if f != ' '
        cu.rotate(f,s,d)
        cu.draw()

      if x == (cu.size*2+1 + Math.floor(cu.size / 2)) and y == (cu.size*2+1 + Math.floor(cu.size / 2))
        cu.shuffle()
      else if x == (cu.size*2+2 + Math.floor(cu.size / 2)) and y == (cu.size*2+1 + Math.floor(cu.size / 2))
        cu = new cube(Math.min(15,cu.size+1))
        GRID_SIZE = cu.size * 4 + 2
        PS.Init()
      else if x == (cu.size*2+3 + Math.floor(cu.size / 2)) and y == (cu.size*2+1 + Math.floor(cu.size / 2))
        cu = new cube(Math.max(cu.size-1,2))
        GRID_SIZE = cu.size * 4 + 2
        PS.Init()

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
#fade.draw()


