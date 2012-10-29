### oppen to puplic use ###
jQuery ->
  if jQuery('#name').html() == 'LetterPop'
    #------------------------------------ Classes -------------------------------------
    class my_button
      constructor: (x,y,w,h,color,hover_color,text,state_change) ->
        @x = x
        @y = y
        @h = h
        @w = w
        @c = color
        @hc = hover_color
        @t = text
        @sc = state_change
        this.draw()

      draw: () ->
        for x in [@x..(@x+@w-1)]
          for y in [@y..(@y+@h-1)]
            PS.BeadColor x,y,@c
            PS.BeadData x,y,this

        xi = 0
        yi = 0
        for i in [0..(@t.length-1)]
          PS.BeadGlyph @x+xi,@y+yi,@t[i]
          xi = xi + 1
          if xi > @w
            yi = yi + 1
            xi = 0
            if yi > @h
              break
      is_in: (x,y) ->
        return (x >= @x and x < (@x+@w) and y >= @y and y < (@y+@h))

      Click: (x, y, data) ->
        "use strict"
        if this.is_in(x,y)
          return @sc
        else
          return 'None'
      Enter: (x, y, data) ->
        "use strict"
        if this.is_in(x,y)
          for x in [@x..(@x+@w-1)]
            for y in [@y..(@y+@h-1)]
              PS.BeadColor x,y,@hc

      Leave: (x, y, data) ->
        "use strict"
        if this.is_in(x,y)
          for x in [@x..(@x+@w-1)]
            for y in [@y..(@y+@h-1)]
              PS.BeadColor x,y,@c
    class my_text_box
      constructor: (x,y,w,h,color,select_color,dt) ->
        @x = x
        @y = y
        @w = w
        @h = h
        @c = color
        @sc = select_color
        @dt = dt
        @sx = 0 #selected
        @sy = 0 #selected
        this.draw()

      draw: () ->
        for x in [@x..(@x+@w-1)]
          for y in [@y..(@y+@h-1)]
            PS.BeadColor x,y,@c
            PS.BeadData x,y,this
        PS.BeadColor @x+@sx,@y+@sy,@sc

        xi = 0
        yi = 0
        for i in [0..(@dt.length-1)]
          PS.BeadGlyph @x+xi,@y+yi,@dt[i]
          xi = xi + 1
          if xi > @w
            yi = yi + 1
            xi = 0
            if yi > @h
              break
      is_in: (x,y) ->
        return (x >= @x and x < (@x+@w) and y >= @y and y < (@y+@h))
      shift_select:(direction,c) ->
        s = ''
        for i in [0..(@dt.length-1)]
          s = s + @dt[i] if i != @sx
          s = s + c if i == @sx
        @dt = s
        if direction == -1
          @sx = @sx - 1
        else if direction == 1
          @sx = @sx + 1
        @sx = @sx % @w
        this.draw()


      Click: (x, y, data) ->
        "use strict"
        if this.is_in(x,y)
          return 'None'
        else
          return 'None'
      Enter: (x, y, data) ->
        "use strict"
        if this.is_in(x,y)
          for x in [@x..(@x+@w-1)]
            for y in [@y..(@y+@h-1)]
              PS.BeadColor x,y,@hc

      Leave: (x, y, data) ->
        "use strict"
        if this.is_in(x,y)
          for x in [@x..(@x+@w-1)]
            for y in [@y..(@y+@h-1)]
              PS.BeadColor x,y,@c

    draw_home = () ->
      o = 'points'
      #Title
      l = ['L','E','T','T','E','R',' ','P','O','P']
      for i in [0..(l.length-1)]
        PS.BeadGlyph Math.floor((GRID_SIZE-l.length) / 2)+i,1, l[i]
        PS.BeadColor Math.floor((GRID_SIZE-l.length) / 2)+i,1, C_2


      #play button
      b = new my_button(7,5,4,1,C_2,C_5,'PLAY','play')
      b = new my_button(2,8,11,1,C_2,C_5,'HIGH SCORES','scores')

      tb = new my_text_box(2,5,3,1,C_5,C_3,'AAA')
    draw_score = (order) ->
      #title
      l = ['H','I','G','H',' ','S','C','O','R','E','S']
      for i in [0..(l.length-1)]
        PS.BeadGlyph Math.floor((GRID_SIZE-l.length) / 2)+i,1, l[i]
        PS.BeadColor Math.floor((GRID_SIZE-l.length) / 2)+i,1, C_2

      b = new my_button(1,3,1,1,C_2,C_2,'#','None')
      b = new my_button(3,3,4,1,C_2,C_2,'NAME','None')
      b = new my_button(8,3,6,1,C_2,C_5,'POINTS','points')
      b = new my_button(15,3,10,1,C_2,C_5,'DIFFICULTY','difficulty')
      b = new my_button(1,23,4,1,C_2,C_5,'HOME','home')
      b = new my_button(15,23,10,1,C_2,C_5,'PLAY AGAIN','play')

      #get the scores
      url = "/LPHS"
      json = 'nothing'
      $.ajax
        async: false
        global: false
        data: {order: order}
        url: url
        dataType: "json"
        success: (d) ->
          json = d
      if json != 'nothing'
        y = 5
        for i in json
          c = C_5
          c = C_2 if y%2 == 0
          b = new my_button(1,y,1,1,c,c,String(y-4),'None')
          b = new my_button(3,y,3,1,c,c,i.name,'None')
          b = new my_button(8,y,6,1,c,c,String(i.points),'None')
          b = new my_button(15,y,10,1,c,c,String(i.difficulty),'None')
          y = y + 1
      else
        alert 'epic fail'


    #------------------------------------------ Constants -----------------------------------------
    GRID_SIZE = 16

    C_1 = 0x333a40
    C_2 = 0x4c5e5e
    C_3 = 0xadd0e5
    C_4 = 0xCDE4FF
    C_5 = 0x729EBF

    dificulty = 0.1
    score = 0
    player_name = 'AAA'
    state = 'home' #home,play,score
    score_order = 'points'

    leters = ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z']
    #------------------------------------------ Events -----------------------------------------

    PS.Init = ->
      if state == 'home'
        PS.Clock 0
        GRID_SIZE = 16
      else if state == 'scores'
        PS.Clock 0
        GRID_SIZE = 26
      else
        GRID_SIZE = 16
      # change to the dimensions you want
      PS.GridSize GRID_SIZE, GRID_SIZE
      PS.StatusFade false
      PS.StatusText "Letter Pop"
      PS.BeadBorderWidth PS.ALL, PS.ALL, 0
      PS.BeadData PS.ALL, PS.ALL, 0
      PS.BeadColor PS.ALL, PS.ALL, C_1
      PS.BeadColor PS.ALL, GRID_SIZE-1, C_2
      PS.BeadFlash PS.ALL, PS.ALL, false
      PS.BeadFlashColor PS.ALL, PS.ALL, C_4
      PS.BeadGlyphColor PS.ALL,PS.ALL,C_4

      PS.AudioLoad( "fx_drip1" )
      PS.AudioLoad( "fx_drip2" )
      PS.AudioLoad( "fx_pop" )


      if state == 'home'
        PS.Clock 0
        draw_home()
      else if state == 'scores'
        PS.Clock 0
        draw_score(score_order)
      else
        dificulty = 0.1
        score = 0
        PS.Clock 15

      #start the Clock

    PS.Click = (x, y, data) ->
      "use strict"
      if data != 0
        s = data.Click(x,y,data)
        if s != 'None'
          state = s
          if s == 'points' or s == 'difficulty'
            score_order = s
            state = 'scores'
          PS.Init()

    PS.Release = (x, y, data) ->
      "use strict"

    PS.Enter = (x, y, data) ->
      "use strict"
      if data != 0
        data.Enter(x,y,data)

    PS.Leave = (x, y, data) ->
      "use strict"
      if data != 0
        data.Leave(x,y,data)

    PS.KeyDown = (key, shift, ctrl) ->
      "use strict"

    PS.KeyUp = (key, shift, ctrl) ->
      "use strict"
      if state == 'play'
        got_one = false
        for x in [0..(GRID_SIZE-1)]
          for y in [(GRID_SIZE-2)..0]
            if PS.BeadColor(x,y) != C_2
              g = PS.BeadGlyph x,y
              if g == key
                PS.AudioPlay("fx_pop")
                PS.BeadFlash x, y, true
                PS.BeadColor x,y,C_1
                PS.BeadGlyph x,y,0
                PS.BeadFlash x, y, false
                got_one = true
                score = score + 1
        if got_one
          dificulty = dificulty + 0.005
        else if key != 13
          score = score - 1
          dificulty = Math.max(0.1,dificulty - 0.005)
        PS.StatusText "Letter Pop. score: " + score + ', ' + Math.floor(1000*dificulty)
      else if state == 'home'
        tb = PS.BeadData 2,5
        s = String(String.fromCharCode(key))
        tb.shift_select(1,s)
        player_name = tb.dt



    PS.Wheel = (dir) ->
      "use strict"


    PS.Tick = ->
      "use strict"
      if state == 'play'
        for x in [0..(GRID_SIZE-1)]
          for y in [(GRID_SIZE-2)..0]
            if PS.BeadColor(x,y) != C_2
              #move drops down
              c = PS.BeadColor x,y
              if c == C_3
                #PS.BeadFlash x, y, true
                PS.BeadColor x,y, C_1
              else if c == C_5
                c2 = PS.BeadColor x,y+1
                if c2 == C_2
                  #PS.BeadFlash x, y, true
                  PS.BeadColor x, y, C_2
                  PS.BeadGlyph x,y, 0
                  PS.AudioPlay( "fx_drip2" )
                  if y == 0
                    PS.Clock 0
                    url = "/LPHS/sumbit"
                    json = 'nothing'
                    $.ajax
                      async: false
                      global: false
                      data: {name: player_name, points: score, difficulty: Math.floor(1000*dificulty)}
                      url: url
                      dataType: "json"
                      success: (d) ->
                        json = d
                    if json != 'nothing'
                      alert 'High Score!'
                    state = 'scores'
                    PS.Init()
                else
                  #PS.BeadFlash x, y+1, false
                  PS.BeadColor x,y+1, C_5
                  PS.BeadGlyph x,y+1, PS.BeadGlyph(x,y)
                  PS.BeadColor x,y,C_3
                  PS.BeadGlyph x,y, 0
        #add new Drop
        if Math.random() < dificulty
          xx = PS.Random(GRID_SIZE)-1
          if PS.BeadColor(xx,0) != C_5
            r = PS.Random(25)
            l = leters[r]
            PS.BeadColor xx,0,C_5
            PS.BeadGlyph xx,0,l
            PS.AudioPlay( "fx_drip1" )






