### oppen to puplic use ###
jQuery ->
  if jQuery('#name').html() == 'Composer'
    #------------------------------------ Classes -------------------------------------
    #------------------------------------------ Constants -----------------------------------------
    GRID_SIZE = 64
    MODE = 2 #how long do new notes play for
    #key pressing stuff
    key_start = new Date()
    key_audio = 0
    key_x = 0
    key_n = -1
    key_end = new Date()

    Metrinome = 1 #where the time is
    notes = [] # piano scale
    # build the lines for the music to be played on
    sheet = ->
      for y in [4..16]
        for x in [1..(GRID_SIZE-1)]
          if y%3 == 1 or x == 1
            PS.BeadColor x,y, 0x000000
          else
            PS.BeadColor x,y, 0xffffff

      for y in [25..37]
        for x in [1..(GRID_SIZE-1)]
          if y%3 == 1 or x == 1
            PS.BeadColor x,y, 0x000000
          else
            PS.BeadColor x,y, 0xffffff
    #draw the mode triangle to people can chose how long new notes are played
    mode = ->
      m = MODE
      c = 0x0000ff
      s = 0xffff00
      xi = 0
      for y in [46..54]
        sc = c
        sc = s if m == xi
        for x in [10..(10+xi)]
          PS.BeadColor x,y, sc
        xi += 1
    #create the notes
    load_scale = ->
      y = 41
      i = 1
      m = 0
      ns = ['c','d','e','f','g','a','b']
      nss = 6
      shift = 1
      str = ''
      while y > 0
        if y %3 != 0
          p = 'l_piano_'+ns[nss]+shift
          notes.push([-1,p,y])
          str = str + ', ' + notes[i-1][1]
          nss = nss + 1
          if nss > 6
            nss = 0
            shift = shift+1
          i = i + 1
        y = y-1
      #alert str





    #------------------------------------------ Events -----------------------------------------

    PS.Init = ->
      # change to the dimensions you want
      PS.GridSize GRID_SIZE, GRID_SIZE
      PS.StatusText "Composer"
      #hide the borders
      PS.BeadBorderWidth PS.ALL, PS.ALL, 0
      PS.Clock(15)

      #[chanle,PS.Adio,y]
      load_scale()

      sheet()
      mode()


    PS.Click = (x, y, data) ->
      "use strict"
      drew = false
      #if it is in the music sheet
      if y > 0 and y < 43 and x >2 and x < GRID_SIZE-MODE
        if y%3 != 1 #FACE
          yi = 1
          yi = -1 if y%3 == 0
          c = PS.BeadColor x,y
          c = PS.BeadColor x,y+yi if y%3 ==0
          c = PS.UnmakeRGB(c)
          ci = 0xff0000 if c.b == 255
          ci = 0xffffff if c.b == 0
          for ix in [0..MODE]
            drew = true
            PS.BeadColor x+ix,y, ci
            PS.BeadColor x+ix,y+yi, ci
          PS.BeadColor x+MODE+1,y, 0xffffff
          PS.BeadColor x+MODE+1,y+yi, 0xffffff
          PS.BeadColor x-1,y, 0xffffff
          PS.BeadColor x-1,y+yi, 0xffffff
        else # EGBDF
          yi = -1
          c = PS.BeadColor x,y
          c = PS.UnmakeRGB(c)
          cib = 0x00ff00 if c.g == 0
          cib = 0x000000 if c.g == 255
          for ix in [0..MODE]
            drew = true
            PS.BeadColor x+ix,y, cib
          PS.BeadColor x+MODE+1,y, 0x000000
          PS.BeadColor x-1,y, 0x000000
      else if y > 45 and y < 55 and x > 9 and x < 10+(y-45) #if it is in mode select
        MODE = (y-46)
        mode()
      #alert c.r
      #alert drew

    PS.Release = (x, y, data) ->
      "use strict"

    PS.Enter = (x, y, data) ->
      "use strict"

    PS.Leave = (x, y, data) ->
      "use strict"

    PS.KeyDown = (key, shift, ctrl) ->
      "use strict"
      #if it is a good key and we haven't started to play yet
      if ((key >=65 and key <=71) or (key >= 97 and key <= 103)) and key_n == -1 and key != 16 and key != 17
        key_n = 0
        if key >= 65 and key <= 71
          if ctrl
            key_n = key - 52
            key_n = key_n + 7 if key_n < 15
          else
            key_n = key - 59
            key_n = key_n + 7 if key_n < 8
        else if key >= 97 and key <= 103
          key_n = key - 98
          key_n = key_n + 7 if key_n < 1
        key_start = new Date()
        key_x = Metrinome
        #key_n = Math.abs(key_n - (notes.length-1))
        #alert notes[key_n][1]
        key_audio = PS.AudioPlay notes[key_n][1]

    PS.KeyUp = (key, shift, ctrl) ->
      "use strict"
      #if we have started to play
      if key_n != -1
        PS.AudioStop key_audio
        key_end = new Date()
        t = new Date()
        t.setTime key_end.getTime() - key_start.getTime()
        t = t.getMilliseconds() + t.getSeconds() * 1000
        t = Math.floor(t/250)
        temp = MODE
        MODE = t
        PS.Click key_x,notes[key_n][2]
        MODE = temp
        key_n = -1
      if key == 32  #Twinkle Twinkle
        sheet()
        MODE = 1
        PS.Click 4,19
        PS.Click 8,19
        PS.Click 12,13
        PS.Click 16,13
        PS.Click 20,11
        PS.Click 24,11
        PS.Click 36,15
        PS.Click 40,15
        PS.Click 44,16
        PS.Click 48,16
        PS.Click 52,17
        PS.Click 56,17
        PS.Click 52,28
        PS.Click 56,27
        MODE = 7
        PS.Click 28,13
        PS.Click 4,32
        PS.Click 12,30
        PS.Click 20,28
        PS.Click 28,30
        PS.Click 36,31
        PS.Click 44,33
        MODE = 1


    PS.Wheel = (dir) ->
      "use strict"

    PS.Tick = ->
      "use strict"
      #play some souds
      for n in notes
        c2 = PS.BeadColor Metrinome, n[2]
        c2 = PS.UnmakeRGB(c2)
        if ((c2.r==0 and c2.g==0 and c2.b == 0) or (c2.r == 255 and c2.g == 255 and c2.b == 255))
          PS.AudioStop(n[0]) if n[0] != -1
          n[0] = -1
          #look a next guy
          c = PS.BeadColor Metrinome+1, n[2]
          c = PS.UnmakeRGB(c)
          if c.b == 0 and (c.r ==255 or c.g ==255)
            n[0] = PS.AudioPlay(n[1])
      #PS.BeadColor Metrinome,44,0xffffff
      Metrinome = (Metrinome + 1) % (GRID_SIZE - 1)
      Metrinome = Math.max(1,Metrinome)
      PS.BeadColor(Metrinome,44,0xff00ff)
#fade.draw()


