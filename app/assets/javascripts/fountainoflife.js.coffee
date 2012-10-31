### oppen to puplic use ###
jQuery ->
  if jQuery('#name').html() == 'FountainOfLife'
    #------------------------------------ Classes -------------------------------------
    class fountain
      constructor: (r,g,b) ->
        @red_out = r
        @green_out = g
        @blue_out = b

      update:(x,y) ->
        c = PS.BeadColor x,y
        c = PS.UnmakeRGB(c)

        rr = Math.random() * 255
        rg = Math.random() * 255
        rb = Math.random() * 255
        if rr <= @red_out
          c.r = Math.floor(Math.min(255,c.r + rr))
        if rg <= @green_out
          c.g = Math.floor(Math.min(255,c.g + rg))
        if rb <= @blue_out
          c.b = Math.floor(Math.min(255,c.b + rb))

        PS.BeadColor x,y, PS.MakeRGB(c.r,c.g,c.b)
        PS.BeadGlyphColor x,y, PS.MakeRGB(Math.abs(c.r-255),Math.abs(c.g-255),Math.abs(c.b-255))

        PS.BeadGlyph x,y, "⇧"

      Click: (x,y,data) ->
        PS.BeadGlyph x,y, 0
        PS.BeadData x,y,0

    class my_button

      constructor: (mode,ro,go,bo) ->
        @mode = mode
        @ro = ro
        @go = go
        @bo = bo

      Click: (x,y,data) ->
        if @mode == 'set'
          new_fountain.red_out = @ro if @ro != -1
          new_fountain.green_out = @go if @go != -1
          new_fountain.blue_out = @bo if @bo != -1
          draw_new_fountain_controls()
        else if @mode == 'shift'
          new_fountain.red_out = Math.Max(0,Math.min(255,new_fountain.red_out + @ro))
          new_fountain.green_out = Math.Max(0,Math.min(255,new_fountain.green_out + @go))
          new_fountain.blue_out = Math.Max(0,Math.min(255,new_fountain.blue_out + @bo))
    class life_action
      constructor: (hl,hh,rl,rh,gl,gh,bl,bh,srl,srh,sgl,sgh,sbl,sbh,syl,syh,sbrl,sbrh,sbgl,sbgh,sbbl,sbbh) ->
        @health =
          low: hl
          high: hh
        @red =
          low: rl
          high: rh
        @green =
          low: gl
          high: gh
        @blue =
          low: bl
          high: bh
       
        @side =
          color:
            red:
              low: srl
              high: srh
            green:
              low: sgl
              high: sgh
            blue:
              low: sbl
              high: sbh
          glyph:
            low: syl
            high: syh
          border_color:
            red:
              low: sbrl
              high: sbrh
            green:
              low: sbgl
              high: sbgh
            blue:
              low: sbbl
              high: sbbh
          

      do_test: (x,y) ->
        center =
          x: x
          y: y
          d: 0
          c: 0
        north =
          x: x
          y: y - 1
          g: 0
          c: 0
          bc: 0
        south =
          x: x
          y: y + 1
          g: 0
          c: 0
          bc: 0
        east =
          x: x + 1
          y: y
          g: 0
          c: 0
          bc: 0
        west =
          x: x - 1
          y: y
          g: 0
          c: 0
          bc: 0

        north.y = GRID_SIZE - 1 if north.y < 0
        south.y = 0 if south.y > GRID_SIZE - 5
        east.x = 0 if east.x >= GRID_SIZE
        west.x = GRID_SIZE - 1 if west.x < 0
        
        center.d = PS.BeadData center.x,center.y
        north.g = PS.BeadGlyph north.x,north.y
        south.g = PS.BeadGlyph south.x,south.y
        east.g = PS.BeadGlyph east.x,east.y
        west.g = PS.BeadGlyph west.x,west.y

        center.c = PS.UnmakeRGB(PS.BeadColor center.x,center.y )
        north.c = PS.UnmakeRGB(PS.BeadColor north.x,north.y )
        south.c = PS.UnmakeRGB(PS.BeadColor south.x,south.y)
        east.c = PS.UnmakeRGB(PS.BeadColor east.x,east.y)
        west.c = PS.UnmakeRGB(PS.BeadColor west.x,west.y)
        
        north.bc = PS.UnmakeRGB(PS.BeadBorderColor north.x,north.y )
        south.bc = PS.UnmakeRGB(PS.BeadBorderColor south.x,south.y)
        east.bc = PS.UnmakeRGB(PS.BeadBorderColor east.x,east.y)
        west.bc = PS.UnmakeRGB(PS.BeadBorderColor west.x,west.y)

        if center.d.health > @health.low and center.d.health < @health.high
          if center.c.r > @red.low and center.c.r < @red.high
            if center.c.g > @green.low and center.c.g < @green.high
              if center.c.b > @blue.low and center.c.b < @blue.high
                if north.c.r > @side.color.red.low and north.c.r < @side.color.red.high
                  if north.c.g > @side.color.green.low and north.c.g < @side.color.green.high
                    if north.c.b > @side.color.blue.low and north.c.b < @side.color.blue.high
                      if north.g > @side.glyph.low and north.g < @side.glyph.high
                        if north.bc.r > @side.border_color.red.low and north.bc.r < @side.border_color.red.high
                          if north.bc.g > @side.border_color.green.low and north.bc.g < @side.border_color.green.high
                            if north.bc.b > @side.border_color.blue.low and north.bc.b < @side.border_color.blue.high
                              return 'north'
                if south.c.r > @side.color.red.low and south.c.r < @side.color.red.high
                  if south.c.g > @side.color.green.low and south.c.g < @side.color.green.high
                    if south.c.b > @side.color.blue.low and south.c.b < @side.color.blue.high
                      if south.g > @side.glyph.low and south.g < @side.glyph.high
                        if south.bc.r > @side.border_color.red.low and south.bc.r < @side.border_color.red.high
                          if south.bc.g > @side.border_color.green.low and south.bc.g < @side.border_color.green.high
                            if south.bc.b > @side.border_color.blue.low and south.bc.b < @side.border_color.blue.high
                              return 'south'
                if east.c.r > @side.color.red.low and east.c.r < @side.color.red.high
                  if east.c.g > @side.color.green.low and east.c.g < @side.color.green.high
                    if east.c.b > @side.color.blue.low and east.c.b < @side.color.blue.high
                      if east.g > @side.glyph.low and east.g < @side.glyph.high
                        if east.bc.r > @side.border_color.red.low and east.bc.r < @side.border_color.red.high
                          if east.bc.g > @side.border_color.green.low and east.bc.g < @side.border_color.green.high
                            if east.bc.b > @side.border_color.blue.low and east.bc.b < @side.border_color.blue.high
                              return 'east'
                if west.c.r > @side.color.red.low and west.c.r < @west.color.red.high
                  if west.c.g > @west.color.green.low and west.c.g < @west.color.green.high
                    if west.c.b > @west.color.blue.low and west.c.b < @west.color.blue.high
                      if west.g > @west.glyph.low and west.g < @west.glyph.high
                        if west.bc.r > @west.border_color.red.low and west.bc.r < @west.border_color.red.high
                          if west.bc.g > @west.border_color.green.low and west.bc.g < @west.border_color.green.high
                            if west.bc.b > @west.border_color.blue.low and west.bc.b < @west.border_color.blue.high
                              return 'west'
        return 'none'

      make_copy: () ->
        h = mutate(@health.low,@health.high,0,1000)
        r = mutate(@red.low,@red.high,0,255)
        g = mutate(@green.low,@green.high,0,255)
        b = mutate(@blue.low,@blue.high,0,255)

        sr = mutate(@side.color.red.low,@side.color.red.high,0,255)
        sb = mutate(@side.color.blue.low,@side.color.blue.high,0,255)
        sg = mutate(@side.color.green.low,@side.color.green.high,0,255)
        sy = mutate(@side.glyph.low,@side.glyph.high,33,126)
        sbr = mutate(@side.border_color.red.low,@side.border_color.red.high,0,255)
        sbg = mutate(@side.border_color.green.low,@side.border_color.green.high,0,255)
        sbb = mutate(@side.border_color.blue.low,@side.border_color.blue.high,0,255)
        return new life_action(h.low, h.high,r.low,r.high,g.low,g.high,b.low,b.high,sr.low,sr.high,sg.low,sg.high,sb.low,sg.high,sy.low,sy.high,sbr.low,sbr.high,sbg.low,sbg.high,sbb.low,sbb.high)


    class cell
      constructor: (ri,bi,gi,gl,ew,mw,aw,cw) ->
        @red_in = ri
        @blue_in = bi
        @green_in = gi
        @glyph = gl
        @health = 100
        @eat_when = ew
        @attack_when = aw
        @move_when = mw
        @copy_when = cw

      update: (x,y,data) ->
        #draw
        PS.BeadBorderColor x,y, PS.MakeRGB(Math.floor(@red_in),Math.floor(@blue_in),Math.floor(@green_in))
        PS.BeadBorderWidth x,y,1
        PS.BeadGlyphColor x,y,PS.MakeRGB(Math.floor(@red_in),Math.floor(@blue_in),Math.floor(@green_in))
        PS.BeadGlyph x,y,@glyph
        #check health
        if @health > 0
          #do eat
          if @eat_when.do_test(x,y) != 'none'
            alert 'eating'
          #do move
          m = @move_when.do_test(x,y)
          if m != 'none'
            alert 'moveing ' + m
          #do attack
          m = @attack_when.do_test(x,y)
          if m != 'none'
            alert 'attacking ' + m
          #do copy
          m = @copy_when.do_test(x,y)
          if m != 'none'
            alert 'copying ' + m
        else
          this.Click(x,y,this)


      Click: (x,y,data) ->
        PS.BeadGlyph x,y, 0
        PS.BeadData x,y,0
        PS.BeadBorderWidth x,y,0


    give_and_take = (center,side) ->

      if center.r > side.r #give
        center.r = center.r - Math.max(1,Math.floor((center.r-side.r)* 0.25))
        side.r = side.r + Math.max(1,Math.floor((center.r-side.r)* 0.25))
      else if center.r < side.r #take
        center.r = center.r + Math.max(1,Math.floor((side.r-center.r)* 0.25))
        side.r = side.r - Math.max(1,Math.floor((side.r-center.r)* 0.25))

      if center.g > side.g #give
        center.g = center.g - Math.max(1,Math.floor((center.g-side.g)* 0.25))
        side.g = side.g + Math.max(1,Math.floor((center.g-side.g)* 0.25))
      else if center.g < side.g #take
        center.g = center.g + Math.max(1,Math.floor((side.g-center.g)* 0.25))
        side.g = side.g - Math.max(1,Math.floor((side.g-center.g)* 0.25))

      if center.b > side.b #give
        center.b = center.b - Math.max(1,Math.floor((center.b-side.b)* 0.25))
        side.b = side.b + Math.max(1,Math.floor((center.b-side.b)* 0.25))
      else if center.b < side.b #take
        center.b = center.b + Math.max(1,Math.floor((side.b-center.b)* 0.25))
        side.b = side.b - Math.max(1,Math.floor((side.b-center.b)* 0.25)  )

      return [center,side]

    mutate = (low,high,min,max) ->
      range = max-min
      new_low = Math.max(min,Math.min(max,(low + 0.01*Math.random()*range - 0.01*Math.random()*range)))
      new_high = Math.max(min,Math.min(max,(high + 0.01*Math.random()*range - 0.01*Math.random()*range)))
      r =
        low: new_low
        high: new_high
      if new_high > new_low
        r.low = new_high
        r.high = new_low
      return r

    make_random_cell = () ->
      h = mutate(0,1000,0,1000)
      r = mutate(0,255,0,255)
      g = mutate(0,255,0,255)
      b = mutate(0,255,0,255)
      sr = mutate(0,255,0,255)
      sb =  mutate(0,255,0,255)
      sg =  mutate(0,255,0,255)
      sy =  mutate(0,255,0,255)
      sbr =  mutate(0,255,0,255)
      sbg =  mutate(0,255,0,255)
      sbb =  mutate(0,255,0,255)
      la = new life_action(h.low, h.high,r.low,r.high,g.low,g.high,b.low,b.high,sr.low,sr.high,sg.low,sg.high,sb.low,sb.high,sy.low,sy.high,sbr.low,sbr.high,sbg.low,sbg.high,sbb.low,sbb.high)
      c = new cell(85,85,85,33,la,la,la,la)


    draw_new_fountain_controls = () ->
      #bars
      for i in [0..(GRID_SIZE-1)]
        PS.BeadColor i,GRID_SIZE-1, PS.MakeRGB(0,0,Math.floor((i) / (GRID_SIZE-1)*255))
        PS.BeadData i,GRID_SIZE-1, new my_button('set',-1,-1,Math.floor((i) / (GRID_SIZE-1)*255))
        PS.BeadBorderColor i,GRID_SIZE-1,0xffffff if Math.floor((i) / (GRID_SIZE-1)*255) == new_fountain.blue_out
        PS.BeadBorderWidth i,GRID_SIZE-1,0
        PS.BeadBorderWidth i,GRID_SIZE-1,1 if Math.floor((i) / (GRID_SIZE-1)*255) == new_fountain.blue_out
        PS.BeadColor i,GRID_SIZE-2, PS.MakeRGB(0,Math.floor((i) / (GRID_SIZE-1)*255),0)
        PS.BeadData i,GRID_SIZE-2, new my_button('set',-1,Math.floor((i) / (GRID_SIZE-1)*255),-1)
        PS.BeadBorderWidth i,GRID_SIZE-2,0
        PS.BeadBorderColor i,GRID_SIZE-2,0xffffff if Math.floor((i) / (GRID_SIZE-1)*255) == new_fountain.green_out
        PS.BeadBorderWidth i,GRID_SIZE-2,1 if Math.floor((i) / (GRID_SIZE-1)*255) == new_fountain.green_out
        PS.BeadColor i,GRID_SIZE-3, PS.MakeRGB(Math.floor((i) / (GRID_SIZE-1)*255),0,0)
        PS.BeadBorderWidth i,GRID_SIZE-3,0
        PS.BeadBorderColor i,GRID_SIZE-3,0xffffff if Math.floor((i) / (GRID_SIZE-1)*255) == new_fountain.red_out
        PS.BeadBorderWidth i,GRID_SIZE-3,1 if Math.floor((i) / (GRID_SIZE-1)*255) == new_fountain.red_out
        PS.BeadData i,GRID_SIZE-3, new my_button('set',Math.floor((i) / (GRID_SIZE-1)*255),-1,-1)

    #------------------------------------------ Constants -----------------------------------------
    GRID_SIZE = 16

    cell_start = make_random_cell()

    new_fountain =
      red_out: 255
      green_out: 0
      blue_out: 0

    #------------------------------------------ Events -----------------------------------------

    PS.Init = ->
      # change to the dimensions you want
      PS.GridSize GRID_SIZE, GRID_SIZE
      PS.StatusText "Fountain Of Life"
      PS.BeadFlash PS.ALL, PS.ALL, false
      PS.BeadColor PS.ALL,PS.ALL,0x00000
      PS.BeadBorderWidth PS.ALL, PS.ALL, 0
      PS.BeadFlash PS.ALL, PS.ALL, false
      draw_new_fountain_controls()
      PS.BeadData 4,4,cell_start
      #start the Clock
      PS.Clock 10

    PS.Click = (x, y, data) ->
      "use strict"
      if data == 0
        f = new fountain(new_fountain.red_out,new_fountain.green_out,new_fountain.blue_out)
        PS.BeadData x,y,f
      else
        data.Click(x,y,data)

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
      for x in [0..(GRID_SIZE-1)]
        for y in [0..(GRID_SIZE-5)]
          d = PS.BeadData x,y
          if d != 0 and d != undefined
            d.update x,y
          #update colors
          #self
          c = PS.BeadColor x,y
          c = PS.UnmakeRGB(c)
          nc =
            r: c.r
            g: c.g
            b: c.b
          if c.r > 0 #red beats green
            nc.g = Math.max(nc.g - 1,0)
          if c.g > 0  #green beats blue
            nc.b = Math.max(0,nc.b - 1)
          if c.b > 0 #blue beats red
            nc.r = Math.max(0,nc.r - 1)
          #north
          if y > 0
            cn = PS.BeadColor x,y-1
            cn = PS.UnmakeRGB(cn)
            temp = give_and_take(nc,cn)
            nc = temp[0]
            cn = temp[1]
            PS.BeadColor x,y-1,PS.MakeRGB(cn.r,cn.g,cn.b)
          else
            cn = PS.BeadColor x,GRID_SIZE-5
            cn = PS.UnmakeRGB(cn)
            temp = give_and_take(nc,cn)
            nc = temp[0]
            cn = temp[1]
            PS.BeadColor x,GRID_SIZE-5,PS.MakeRGB(cn.r,cn.g,cn.b)

          #west
          if x > 0
            cw = PS.BeadColor x-1,y
            cw = PS.UnmakeRGB(cw)
            temp = give_and_take(nc,cw)
            nc = temp[0]
            cw = temp[1]
            cw = PS.BeadColor x-1,y,PS.MakeRGB(cw.r,cw.g,cw.b)
          else
            cw = PS.BeadColor (GRID_SIZE-1),y
            cw = PS.UnmakeRGB(cw)
            temp = give_and_take(nc,cw)
            nc = temp[0]
            cw = temp[1]
            cw = PS.BeadColor (GRID_SIZE-1),y,PS.MakeRGB(cw.r,cw.g,cw.b)


          #done
          PS.BeadColor x,y,PS.MakeRGB(nc.r,nc.g,nc.b)









