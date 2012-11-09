### oppen to puplic use ###
jQuery ->
  ### you need these variables
  but you can take out the jQuery stuff ###
  if jQuery('#name').html() == 'WordWars1'
    ### START OF GAME CODE ###
    ###------------------------------------ Classes -------------------------------------###
    class letter
      ### the letter allows us to keep track of words and manage combat ###
      constructor: (vowel,value) ->
        @number = 0
        @vowel = vowel
        if vowel
          i = 0
          while Alphabet[0][i] != value
            i += 1
          @number = i
        else
          i = 0
          while Alphabet[1][i] != value
            i += 1
          @number = i

        @glyph = '!'
        if @vowel
          @glyph = Alphabet[0][@number]
        else
          @glyph = Alphabet[1][@number]

        @major = [0,2,4,5,7,9,11]
        @minor = [0,2,3,5,7,8,10]
      ### combat pits this letter (as you) against the incoming ###
      combat: (other) ->
        ### if we are a vowel we should beat all none vowels ###
        #alert @number%2 + ' -- ' + other.number%2
        if @vowel
          if other.vowel
            if @number == other.number
              PS.AudioPlay 'perc_drum_snare' if G.Sound
              return 'tie'
            else if @number < other.number
              if @number % 2 == 0
                if other.number % 2 == 0
                  ### we lose ###
                  PS.AudioPlay DNA_MUSIC.Xylophone[5][@minor[other.number]] if G.Sound
                  if (@number+2)%5 == other.number
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@minor[other.number]+4)) / 12) ][(@minor[other.number]+4)%12] if G.Sound
                  else
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@minor[other.number]+8)) / 12) ][(@minor[other.number]+8)%12] if G.Sound
                  return 'lose'
                else
                  ### we win ###
                  PS.AudioPlay DNA_MUSIC.Xylophone[5][@major[@.number]] if G.Sound
                  if (@number+1)%5 == other.number
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@major[@.number]+5)) / 12) ][(@major[@.number]+5)%12] if G.Sound
                  else
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@major[@.number]+7)) / 12) ][(@major[@.number]+7)%12] if G.Sound
                  return 'win'
              else
                if other.number % 2 == 0
                  ### we win ###
                  PS.AudioPlay DNA_MUSIC.Xylophone[5][@major[@.number]] if G.Sound
                  if (@number+1)%5 == other.number
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@major[@.number]+5)) / 12) ][(@major[@.number]+5)%12] if G.Sound
                  else
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@major[@.number]+7)) / 12) ][(@major[@.number]+7)%12] if G.Sound
                  return 'win'
                else
                  ### we lose ###
                  PS.AudioPlay DNA_MUSIC.Xylophone[5][@minor[other.number]] if G.Sound
                  if (@number+2)%5 == other.number
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@minor[other.number]+4)) / 12) ][(@minor[other.number]+4)%12] if G.Sound
                  else
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@minor[other.number]+8)) / 12) ][(@minor[other.number]+8)%12] if G.Sound
                  return 'lose'
            else
              if @number % 2 == 0

                if other.number % 2 == 0
                  ### we win ###
                  PS.AudioPlay DNA_MUSIC.Xylophone[5][@major[@.number]] if G.Sound
                  if (@number+1)%5 == other.number
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@major[@.number]+7)) / 12) ][(@major[@.number]+7)%12] if G.Sound
                  else
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@major[@.number]+5)) / 12) ][(@major[@.number]+5)%12] if G.Sound
                  return 'win'
                else
                  ### we lose ###
                  PS.AudioPlay DNA_MUSIC.Xylophone[5][@minor[other.number]] if G.Sound
                  if (@number+2)%5 == other.number
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@minor[other.number]+8)) / 12) ][(@minor[other.number]+8)%12] if G.Sound
                  else
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@minor[other.number]+4)) / 12) ][(@minor[other.number]+4)%12] if G.Sound
                  return 'lose'
              else
                if other.number % 2 == 0
                  ### we lose ###
                  PS.AudioPlay DNA_MUSIC.Xylophone[5][@minor[other.number]] if G.Sound
                  if (@number+2)%5 == other.number
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@minor[other.number]+8)) / 12) ][(@minor[other.number]+8)%12] if G.Sound
                  else
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@minor[other.number]+4)) / 12) ][(@minor[other.number]+4)%12] if G.Sound
                  return 'lose'
                else
                  ### we win ###
                  PS.AudioPlay DNA_MUSIC.Xylophone[5][@major[@.number]] if G.Sound
                  if (@number+1)%5 == other.number
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@major[@.number]+7)) / 12) ][(@major[@.number]+7)%12] if G.Sound
                  else
                    PS.AudioPlay DNA_MUSIC.Xylophone[5+Math.floor(((@major[@.number]+5)) / 12) ][(@major[@.number]+5)%12] if G.Sound
                  return 'win'
          else
            return 'win'
        else
          cords = [ ([0,4,7]),
                    ([0,3,7]),
                    ([0,4,8]),
                    ([0,3,6]),
                    ([0,3,6,9]),
                    ([0,3,6,10]),
                    ([0,3,7,10])
                    ([0,3,7,11]),
                    ([0,4,4,10]),
                    ([0,4,7,11]),
                    ([0,4,8,10]),
                    ([0,4,8,11])
                  ]
          ### not a vowl ###
          if other.vowel
            return 'lose'
          else
            if @number == other.number
              PS.AudioPlay 'perc_drum_tom1' if @number%4 == 0 if G.Sound
              PS.AudioPlay 'perc_drum_tom2' if @number%4 == 1 if G.Sound
              PS.AudioPlay 'perc_drum_tom3' if @number%4 == 2 if G.Sound
              PS.AudioPlay 'perc_drum_tom4' if @number%4 == 3 if G.Sound
              return 'tie'
            else if @number < other.number
              if @number % 2 == 0
                if other.number%2 == 0
                  ### we lose ###
                  notes = cords[other.number%12]
                  for n in notes
                    PS.AudioPlay DNA_MUSIC.Piano[5+Math.floor((@minor[other.number%7]+n) / 12)][(@minor[other.number%7]+n)%12] if G.Sound
                  return 'lose'
                else
                  ### we win ###
                  notes = cords[@number%12]
                  for n in notes
                    PS.AudioPlay DNA_MUSIC.Piano[5+Math.floor((@major[@number%7]+n) / 12)][(@major[@number%7]+n)%12] if G.Sound
                  return 'win'
              else
                if other.number%2 == 0
                  ### we win ###
                  notes = cords[@number%12]
                  for n in notes
                    PS.AudioPlay DNA_MUSIC.Piano[5+Math.floor((@major[@number%7]+n) / 12)][(@major[@number%7]+n)%12] if G.Sound
                  return 'win'
                else
                  ### we lose ###
                  notes = cords[other.number%12]
                  for n in notes
                    PS.AudioPlay DNA_MUSIC.Piano[5+Math.floor((@minor[other.number%7]+n) / 12)][(@minor[other.number%7]+n)%12] if G.Sound
                  return 'lose'
            else
              if @number % 2 == 0
                if other.number%2 == 0
                  ### we win ###
                  notes = cords[@number%12]
                  for n in notes
                    PS.AudioPlay DNA_MUSIC.Piano[5+Math.floor((@major[@number%7]+n) / 12)][(@major[@number%7]+n)%12] if G.Sound
                  return 'win'
                else
                  ### we lose ###
                  notes = cords[other.number%12]
                  for n in notes
                    PS.AudioPlay DNA_MUSIC.Piano[5+Math.floor((@minor[other.number%7]+n) / 12)][(@minor[other.number%7]+n)%12] if G.Sound
                  return 'lose'
              else
                if other.number%2 == 0
                  ### we lose ###
                  notes = cords[other.number%12]
                  for n in notes
                    PS.AudioPlay DNA_MUSIC.Piano[5+Math.floor((@minor[other.number%7]+n) / 12)][(@minor[other.number%7]+n)%12] if G.Sound
                  return 'lose'
                else
                  ### we win ###
                  notes = cords[@number%12]
                  for n in notes
                    PS.AudioPlay DNA_MUSIC.Piano[5+Math.floor((@major[@number%7]+n) / 12)][(@major[@number%7]+n)%12] if G.Sound
                  return 'win'


    ###------------------------------------------ Helper functions ----------------------------------------- ###
    draw_tech_zone = () ->
      l_i = []
      for l of Letters
        l_i.push(l)
      for x in [0..26]
        PS.BeadColor x+3,30,0x000000
        PS.BeadGlyph x+3,30,l_i[x]
        PS.BeadColor x+3,31,0x555555
        PS.BeadGlyph x+3,31,'0'

      PS.BeadColor 31,30,0xcccccc
      PS.BeadGlyph 31,30,'★'
      PS.BeadGlyphColor 31,30,0x0000ff
      PS.BeadColor 31,31,0x555555
      PS.BeadGlyph 31,31,'0'

      PS.BeadGlyph 30,30,'☝'
      PS.BeadColor 30,30,0x000000
      PS.BeadGlyph 29,30,'☝'
      PS.BeadColor 29,30,0x000000
      PS.BeadGlyph 30,31,'☟'
      PS.BeadColor 30,31,0x000000
      PS.BeadGlyph 29,31,'☟'
      PS.BeadColor 29,31,0x000000


    debug = (response) ->
      property_names = ""
      for propertyName of response
        ### propertyName is what you want###
        property_names += propertyName + " = " + response[propertyName] + "\n"
      alert property_names
    ###------------------------------------------ Global Vars ----------------------------------------- ###
    ### the numerical value of the letters is the position in the array ###
    Alphabet = [
                (['a','e','i','o','u']),
                (['b','c','d','f','g','h','j','k','l','m','n','p','q','r','s','t','v','w','x','y','z'])
              ]
    Letters =
      a: new letter(true,'a')
      b: new letter(false,'b')
      c: new letter(false,'c')
      d: new letter(false,'d')
      e: new letter(true,'e')
      f: new letter(false,'f')
      g: new letter(false,'g')
      h: new letter(false,'h')
      i: new letter(true,'i')
      j: new letter(false,'j')
      k: new letter(false,'k')
      l: new letter(false,'l')
      m: new letter(false,'m')
      n: new letter(false,'n')
      o: new letter(true,'o')
      p: new letter(false,'p')
      q: new letter(false,'q')
      r: new letter(false,'r')
      s: new letter(false,'s')
      t: new letter(false,'t')
      u: new letter(true,'u')
      v: new letter(false,'v')
      w: new letter(false,'w')
      x: new letter(false,'x')
      y: new letter(false,'y')
      z: new letter(false,'z')
    G =
      Sound: false

    xx = 1
    yy = 1
    ###------------------------------------------ PS Events ----------------------------------------- ###
    PS.Init = ->
      PS.GridSize 32,32
      y = 1
      for me of Letters
        x = 1
        for you of Letters
          PS.BeadGlyph 0,y,Letters[me].glyph
          PS.BeadColor 0,y,0x000000
          PS.BeadGlyph x,0,Letters[you].glyph
          PS.BeadColor x,0,0x000000
          PS.BeadData x,y, ([Letters[me],Letters[you]])
          x+=1
        y += 1

      PS.Clock(6)
      draw_tech_zone()

    PS.Click = (x, y, data) ->
      "use strict"
      r = data[0].combat(data[1])
      if r == 'tie'
        PS.BeadColor x,y,0x777777
      else if r == 'win'
        PS.BeadColor x,y,0x00ff00
      else if r == 'lose'
        PS.BeadColor x,y,0xff0000

      PS.StatusText r

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
      PS.Click xx,yy,PS.BeadData(xx,yy)
      xx += 1
      if xx >= 27
        xx = 1
        yy += 1
        if yy >= 27
          PS.Clock 0

  ### END OF GAME CODE ###