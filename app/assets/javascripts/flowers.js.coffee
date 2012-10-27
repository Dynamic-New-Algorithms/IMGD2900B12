### oppen to puplic use ###
jQuery ->
  if jQuery('#name').html() == 'Flowers'
    #------------------------------------ Classes -------------------------------------
    class sun
      constructor: () ->
        @x =2
        @y = 2
        @power = 100
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

    class leaf
      constructor: (x,y,life,gc,sc,fc,f_color) ->
        @x = x
        @y = y
        @life = life
        @split_chance = sc
        @grow_chance = gc
        @flower_chance = fc
        @flower_color = f_color
        @grow_limit = 3
        @flower_limit = 1

      draw: () ->
        c = PS.MakeRGB(53,
                      Math.max(255-Math.floor(@life),35),
                      25)
        PS.BeadColor @x,@y, c

      grow: (s) ->
        d = Math.sqrt(((s.x-@x)*(s.x-@x)) + ((s.y-@y)*(s.y-@y)))
        v = [(@x - s.x) / d,(@y - s.y) / d]
        p = s.power
        xi = s.x
        xii = xi
        yi = s.y
        yii = yi
        while xii != @x and yii != @y
          c = PS.BeadColor xii, yii
          c = PS.UnmakeRGB(c)
          id = PS.BeadData(xii,yii)
          if id != undefined and id != null and id != 0
            p = p * ((id.life) / LEAF_LIFE_CAP)
          xi = xi + v[0]
          xii = Math.round(xi)
          yi = yi + v[1]
          yii = Math.round(yi)
        #make some more leafs
        @life = @life + Math.min(Math.max(0,p),LEAF_OBS)
        if @life > LEAF_LIFE_CAP
          @life = LEAF_LIFE_CAP

        if @life > LIFE_MIN
          if Math.random() <= @grow_chance
            if Math.random() <= @split_chance and @grow_limit > 0
              #split
              @grow_limit = -1
              xi =  Math.floor(@x-(v[0] / Math.abs(v[0])))
              yi = Math.floor(@y-(v[1] / Math.abs(v[1])))
              if yi > 0 and yi < (GRID_SIZE-2)
                id = PS.BeadData(@x,yi)
                if id == undefined or id == null or id == 0
                  l = new leaf(@x,yi,0,@grow_chance,@split_chance,@flower_chance,@flower_color)
                  PS.BeadData @x,yi, l
              if xi > -1 and xi < GRID_SIZE
                id = PS.BeadData(xi,@y)
                if id == undefined or id == null  or id == 0
                  l = new leaf(xi,@y,0,@grow_chance,@split_chance,@flower_chance,@flower_color)
                  PS.BeadData xi,@y, l
            else if Math.random() <= @flower_chance and @flower_limit > 0
              @flower_limit = 0
              #flower
              xi =  Math.floor(@x-(v[0] / Math.abs(v[0])))
              yi = Math.floor(@y-(v[1] / Math.abs(v[1])))
              if Math.abs(v[0]) > Math.abs(v[1])
                yi = @y
              else
                xi = @x
              if yi > 0 and yi < (GRID_SIZE-2) and xi > -1 and xi < GRID_SIZE
                id = PS.BeadData(xi,yi)
                if id == undefined or id == null or id == 0
                  f = new flower(xi,yi,0,@grow_chance,@split_chance,@flower_chance,@flower_color)
                  PS.BeadData xi,yi, f
            else if @grow_limit > 0
              @grow_limit = -1
              #grow strait
              xi =  Math.floor(@x-(v[0] / Math.abs(v[0])))
              yi = Math.floor(@y-(v[1] / Math.abs(v[1])))
              if Math.abs(v[0]) > Math.abs(v[1])
                yi = @y
                #alert 'horizontal (' + @x + ', ' + @y + ') -> (' + xi + ', ' + yi + ')'
              else
                xi = @x
                #alert 'virtical (' + @x + ', ' + @y + ') -> (' + xi + ', ' + yi + ')'
              xi  = @x
              if yi > 0 and yi < (GRID_SIZE-2) and xi > -1 and xi < GRID_SIZE
                id = PS.BeadData(xi,yi)
                if id == undefined or id == null or id == 0
                  l = new leaf(xi,yi,0,@grow_chance,@split_chance,@flower_chance,@flower_color)
                  PS.BeadData xi,yi, l
      die: () ->
        if @life >= LEAF_LIFE_CAP
          north = PS.BeadData(@x,@y-1)
          east =  PS.BeadData(Math.max(0,@x-1),@y-1)
          west =  PS.BeadData(Math.max(0,@x+1),@y-1)
          north = (north == undefined or north == null or north == 0)
          east = (east == undefined or east == null or east == 0)
          east = (east.grow_chance != @grow_chance and east.split_chance != @split_chance) unless east
          west = (west == undefined or west == null or west == 0)
          west = (west.grow_chance != @grow_chance and west.split_chance != @split_chance) unless west
          if north and east and west
            PS.BeadColor(@x,@y,PS.DEFAULT_BG_COLOR)
            PS.BeadData(@x,@y,0)
    class flower
      constructor: (x,y,life,gc,sc,fc,f_color) ->
        @x = x
        @y = y
        @life = life
        @split_chance = sc
        @grow_chance = gc
        @flower_chance = fc
        @flower_color = f_color

      draw: () ->
        c = PS.MakeRGB(@flower_color.r * (@life/LEAF_LIFE_CAP),
                      Math.max(255-Math.floor(@life),@flower_color.g * (@life/LEAF_LIFE_CAP)),
                      @flower_color.b * (@life/LEAF_LIFE_CAP))
        PS.BeadColor @x,@y, c

      grow: (s) ->
        d = Math.sqrt(((s.x-@x)*(s.x-@x)) + ((s.y-@y)*(s.y-@y)))
        v = [(@x - s.x) / d,(@y - s.y) / d]
        p = s.power
        xi = s.x
        xii = xi
        yi = s.y
        yii = yi
        while xii != @x and yii != @y
          c = PS.BeadColor xii, yii
          c = PS.UnmakeRGB(c)
          id = PS.BeadData(xii,yii)
          if id != undefined and id != null and id != 0
            p = p * ((id.life) / LEAF_LIFE_CAP)
          xi = xi + v[0]
          xii = Math.round(xi)
          yi = yi + v[1]
          yii = Math.round(yi)
        #make some more leafs
        @life = @life + Math.min(Math.max(0,p),LEAF_OBS)
        if @life > LEAF_LIFE_CAP   # become a new flower
          PS.BeadColor(@x,@y,PS.DEFAULT_BG_COLOR)
          PS.BeadData @x,@y, 0
          xi = Math.floor(Math.random()*GRID_SIZE)
          id = PS.BeadData(xi,GRID_SIZE-2)
          if id == undefined or id == null or id == 0
            gc = Math.min(1,Math.max(0,(@grow_chance + 0.1*(Math.random() - Math.random()))))
            sc = Math.min(1,Math.max(0,(@split_chance + 0.1*(Math.random() - Math.random()))))
            fc = Math.min(1,Math.max(0,(@flower_chance + 0.1*(Math.random() - Math.random()))))
            f_color =
              r: Math.floor(Math.min(255,Math.max(0,(@flower_color.r + 10*(Math.random() - Math.random())))))
              g: Math.floor(Math.min(255,Math.max(0,(@flower_color.g + 10*(Math.random() - Math.random())))))
              b: Math.floor(Math.min(255,Math.max(0,(@flower_color.b + 10*(Math.random() - Math.random())))))
            l = new leaf(xi,GRID_SIZE-2,0,gc,sc,fc,@flower_color)
            PS.BeadData(xi,GRID_SIZE-2,l)
      die: () ->
        if @life >= LEAF_LIFE_CAP
          PS.BeadData(@x,@y,0)


    #------------------------------------------ Constants -----------------------------------------
    GRID_SIZE = 32
    LEAF_LIFE_CAP = 255
    LIFE_MIN = 10
    LEAF_OBS = 1

    sun = new sun()
    col =
      r: Math.floor(Math.random()*255)
      g: Math.floor(Math.random()*255)
      b: Math.floor(Math.random()*255)
    start_leaf = new leaf(Math.floor(GRID_SIZE/2),GRID_SIZE-2,0,0.5,0.25,0.10,col)

    dirt = () ->
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
      PS.BeadData start_leaf.x,start_leaf.y, start_leaf
      PS.Clock(10)

    PS.Click = (x, y, data) ->
      "use strict"
      id = PS.BeadData x,y
      alert id.life
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
      for x in [0..GRID_SIZE-1]
        for y in [0..GRID_SIZE-2]
          id = PS.BeadData(x,y)
          if id != undefined and id != null and id != 0
            id.grow(sun)
            id.draw()
            id.die()
          else
            PS.BeadColor(x,y,PS.DEFAULT_BG_COLOR)

      sun.draw()
      sun.x = Math.max((sun.x + 1) % (GRID_SIZE-1),1)
      sun.moved = true
      #fade.draw()


