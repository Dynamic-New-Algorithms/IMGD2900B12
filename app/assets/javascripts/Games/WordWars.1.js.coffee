
### START OF GAME CODE ###
###------------------------------------ Classes -------------------------------------###
class letter
  ### the letter allows us to keep track of words and manage combat ###
  constructor: (vowel,value) ->
    vowel = true if vowel == 'undefined' or vowel == '?'
    @number = 0
    @vowel = vowel
    if @vowel
      i = 0
      while Alphabet[0][i] != value
        i += 1
        if i > Alphabet[0].length
          @vowel = false
          break
      @number = i

    if @vowel == false
      i = 0
      while Alphabet[1][i] != value
        i += 1
        if i > Alphabet[1].length
          i = -1
          break
      @number = i

    @glyph = value
    if @vowel
      @glyph = Alphabet[0][@number]
    else if @number > 0
      @glyph = Alphabet[1][@number]

    @major = [0,2,4,5,7,9,11]
    @minor = [0,2,3,5,7,8,10]
  ### combat pits this letter (as you) against the incoming ###
  combat: (other) ->
    if other.number < 0
      return 'win'
    else if @number < 0
      return 'lose'
    ### if we are a vowel we should beat all none vowels ###
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
class word
  ### a word is set of letters ###
  constructor: () ->
    @head =
      x: 0
      y: 0
    @letters = []
    @player = ''
    @direction = -1
    @history = []
    @has_moved = false
  get_word: () ->
    w = 'EMPTY'
    if @letters.length > 0
      w = ''
      for l in @letters
        w += l.glyph
    return w
  kill_first: () ->
    @has_moved = true
    @letters.splice(0,1)
    @history.splice(0,1)
    if @history.length > 0
      @head.x = @history[0].x
      @head.y = @history[0].y
  draw: (index)->
    if @letters.length > 0
      if @history.length == 0
        @history = []
        for l in @letters
          @history.push({x: @head.x,y:@head.y})
      for loc in [(@letters.length-1)..0]
        PS.BeadData @history[loc].x,@history[loc].y,index+1
        PS.BeadColor @history[loc].x,@history[loc].y, G.COLORS.PLAYER.WORD.BG   if @player == 'player'
        PS.BeadColor @history[loc].x,@history[loc].y, G.COLORS.COMP.WORD.BG  if @player == 'comp'
        PS.BeadGlyphColor @history[loc].x,@history[loc].y, G.COLORS.PLAYER.WORD.GLYPH   if @player == 'player'
        PS.BeadGlyphColor @history[loc].x,@history[loc].y, G.COLORS.COMP.WORD.GLYPH  if @player == 'comp'
        PS.BeadGlyph @history[loc].x,@history[loc].y,@letters[loc].glyph
  update_history: () ->
    if @history.length > 1
      for h in [@history.length-1..1]
        @history[h] = @history[h-1]
    @history[0] = {x: @head.x, y: @head.y}
  word_fight: (their_index) ->
    my_l = @letters[0]
    their_l = Game.Words[their_index].letters[0]
    r = my_l.combat(their_l)
    PS.Debug "    #{my_l.glyph} with combat #{their_l.glyph} and #{r}\n"
    if r == 'tie'
      PS.BeadFlashColor @head.x,@head.y,0xffffff
      PS.BeadFlash @head.x,@head.y
      this.kill_first()
      Game.Words[their_index].has_moved = true
      Game.Words[their_index].kill_first()
    else if r == 'lose'
      PS.BeadFlashColor @head.x,@head.y,G.COLORS.COMP.FLASH
      PS.BeadFlash @head.x,@head.y
      this.kill_first()
    else if r == 'win'
      PS.BeadFlashColor Game.Words[their_index].head.x,Game.Words[their_index].head.y,G.COLORS.PLAYER.FLASH
      PS.BeadFlash @head.x,@head.y
      Game.Words[their_index].has_moved = true
      Game.Words[their_index].kill_first()
    PS.Debug "    now #{this.get_word()} have moved = #{@has_moved} and #{Game.Words[their_index].get_word()} have moved =  #{Game.Words[their_index].has_moved}\n"
  move: () ->
    if @history.length == 0
      @history = []
      for l in @letters
        @history.push({x: @head.x,y:@head.y})
    if @has_moved == false
      PS.Debug "#{this.get_word()} will now move.\n"
      @has_moved = true
      if @direction == 1
        ### moveing to the east ###
        if @head.x+1 < 29
          if PS.BeadColor(@head.x+1,@head.y) == G.COLORS.BATTLE_GROUND.PATH
            @head.x += 1
            this.update_history()
          else
            PS.Debug "#{this.get_word()} couldn't move east because " + PS.BeadColor(@head.x+1,@head.y) + ' != ' + G.COLORS.BATTLE_GROUND.PATH + '\n'
            if @player == 'player'
              if PS.BeadColor(@head.x+1,@head.y) == G.COLORS.COMP.WORD.BG
                their_index = PS.BeadData(@head.x+1,@head.y)-1
                this.word_fight(their_index)
              else if PS.BeadColor(@head.x+1,@head.y) == G.COLORS.COMP.BUFFER.BG
                alert 'winner'
                window.location.reload()
            else if @player == 'comp' and PS.BeadColor(@head.x+1,@head.y) == G.COLORS.PLAYER.BUFFER.BG
              alert 'loser'
              window.location.reload()
        else
          ### we turn to virtical ###
          @direction = 0
      else if @direction == -1
        ### we are moving west ###
        if @head.x-1 > 0
          if PS.BeadColor(@head.x-1,@head.y) == G.COLORS.BATTLE_GROUND.PATH
            @head.x -= 1
            this.update_history()
          else
            PS.Debug "#{this.get_word()} couldn't move west because " + PS.BeadColor(@head.x-1,@head.y) + ' != ' + G.COLORS.BATTLE_GROUND.PATH + '\n'
            if @player == 'player'
              if PS.BeadColor(@head.x-1,@head.y) == G.COLORS.COMP.WORD.BG
                their_index = PS.BeadData(@head.x-1,@head.y)-1
                this.word_fight(their_index)
        else
          ### we turn to virtical ###
          @direction = 0
      else if @direction == 0
        ### move virticaly ###
        if @player == 'player'
          if @head.y-1 >= 0
            if PS.BeadColor(@head.x,@head.y-1) == G.COLORS.BATTLE_GROUND.PATH
              @head.y -= 1
              this.update_history()
            else if PS.BeadGlyph(@head.x,@head.y-1) == 0 or PS.BeadGlyph(@head.x,@head.y-1) == 32
              ### we turn to horizontal ###
              @direction = 1 if @head.x == 1
              @direction = -1 if @head.x == 28
            else
              PS.Debug "#{this.get_word()} couldn't move north because " + PS.BeadColor(@head.x,@head.y-1) + ' != ' + G.COLORS.BATTLE_GROUND.PATH + '\n'
              if PS.BeadColor(@head.x,@head.y-1) == G.COLORS.COMP.WORD.BG
                their_index = PS.BeadData(@head.x,@head.y-1)-1
                this.word_fight(their_index)
          else
            ### we turn to horizontal ###
            @direction = 1 if @head.x == 1
            @direction = -1 if @head.x == 28
        else if @player == 'comp'
          if @head.y+1 <= 26
            if PS.BeadColor(@head.x,@head.y+1) == G.COLORS.BATTLE_GROUND.PATH
              @head.y += 1
              this.update_history()
            else if PS.BeadGlyph(@head.x,@head.y+1) == 0 or PS.BeadGlyph(@head.x,@head.y+1) == 32
              ### we turn to horizontal ###
              @direction = 1 if @head.x == 1
              @direction = -1 if @head.x == 28
            else
              PS.Debug "#{this.get_word()} couldn't move north because " + PS.BeadColor(@head.x,@head.y-1) + ' != ' + G.COLORS.BATTLE_GROUND.PATH + '\n'
          else
            ### we turn to horizontal ###
            @direction = 1 if @head.x == 1
            @direction = -1 if @head.x == 28












        ###------------------------------------------ Helper functions ----------------------------------------- ###
draw_tech_zone = () ->
  l_i = []
  for l of Letters
    l_i.push(l)
  for x in [0..25]
    c = PS.UnmakeRGB 0x000000
    if Game.Player.Resources[l_i[x]].income != 0
      c.r = Math.floor((1-(Game.Player.Resources[l_i[x]].income / 60)) * 256)
      c.g = Math.floor((1-(Game.Player.Resources[l_i[x]].income / 60)) * 256)
      c.b = Math.floor((1-(Game.Player.Resources[l_i[x]].income / 60)) * 256)
    PS.BeadColor x+1,28,c
    PS.BeadGlyph x+1,28,l_i[x]
    PS.BeadGlyphColor x+1,28,0x0000ff
    PS.BeadBorderWidth x+1,28,1
    PS.BeadData x+1,28, (x,y) -> click_income_ups(x,y)

    PS.BeadColor x+1,29,0x555555
    PS.BeadGlyph x+1,29,String(Game.Player.Resources[l_i[x]].current)
    PS.BeadBorderWidth x+1,29,1
    PS.BeadData x+1,29, (x,y) -> click_income_ups(x,y)

  c =  PS.UnmakeRGB 0x000000
  if Game.Player.Resources['tech'].income != 0
    c.r = Math.floor((1-(Game.Player.Resources['tech'].income / 60)) * 256)
    c.g = Math.floor((1-(Game.Player.Resources['tech'].income / 60)) * 256)
    c.b = Math.floor((1-(Game.Player.Resources['tech'].income / 60)) * 256)
  PS.BeadColor 29,28,c
  PS.BeadGlyph 29,28,'★'
  PS.BeadGlyphColor 29,28,0x0000ff
  PS.BeadColor 29,29,0x555555
  PS.BeadGlyph 29,29,String(Game.Player.Resources['tech'].current)

  PS.BeadGlyph 27,28,'⊂'
  PS.BeadColor 27,28,0x000000
  PS.BeadBorderWidth 27,28,1
  PS.BeadData 27,28,(x,y) ->
    if  Game.Player.Resources['tech'].current > 0 and Game.Switch_backs < 13
      Game.Player.Resources['tech'].current -= 1
      update_tech_current()
      PS.AudioPlay 'perc_hihat_closed' if G.Sound
      PS.BeadFlash x,y
      Game.Switch_backs = Math.min(13,Game.Switch_backs+2)
      draw_battleground()
    else
      PS.AudioPlay 'fx_whistle'
  PS.BeadGlyph 28,28,'☝'
  PS.BeadColor 28,28,0x000000
  PS.BeadBorderWidth 28,28,1
  PS.BeadGlyph 27,29,'⊄'
  PS.BeadColor 27,29,0x000000
  PS.BeadBorderWidth 27,29,1
  PS.BeadBorderWidth 27,29,1
  PS.BeadData 27,29,(x,y) ->
    if  Game.Player.Resources['tech'].current > 0 and Game.Switch_backs > 1
      Game.Player.Resources['tech'].current -= 1
      update_tech_current()
      PS.AudioPlay 'perc_hihat_closed' if G.Sound
      PS.BeadFlash x,y
      Game.Switch_backs = Math.max(1,Game.Switch_backs-2)
      draw_battleground()
    else
      PS.AudioPlay 'fx_whistle'
  PS.BeadGlyph 28,29,'☟'
  PS.BeadColor 28,29,0x000000
  PS.BeadBorderWidth 28,29,1

  PS.BeadGlyph 0,28,'♫' if G.Sound == false
  PS.BeadGlyph 0,28,'♪' if G.Sound
  PS.BeadBorderWidth 0,28,1
  PS.BeadData 0,28,(x,y) ->
    if G.Sound
      G.Sound = false
      PS.BeadGlyph 0,28,'♫'
    else
      G.Sound = true
      PS.BeadGlyph 0,28,'♪'

  PS.BeadGlyph 0,29,'⌂'
  PS.BeadBorderWidth 0,29,1
  PS.BeadData 0,29,(x,y) -> alert('Go Home!')

draw_battleground = () ->
  ### turn off flash and draw the background ###
  for x in [0..29]
    for y in [0..26]
      PS.BeadFlash x,y,false
      PS.BeadBorderWidth x,y, 0
      a = Math.random()
      b = Math.random()*(1-a)
      c = (1-a-b)
      p = [a,b,c]
      color = PS.UnmakeRGB 0x000000
      for i in [0..2]
        co = PS.UnmakeRGB G.COLORS.BATTLE_GROUND.BG[i]
        color.r += Math.floor(co.r * p[i])
        color.g += Math.floor(co.g * p[i])
        color.b += Math.floor(co.b * p[i])
      PS.BeadColor x,y, color
  draw_path()

draw_path = () ->
  ### draw the path ###
  for s in [0..Game.Switch_backs]
    y = 26 - Math.floor(26*(s/Game.Switch_backs))
    sx = 1
    ex = 28
    if s%2 == 0
      sx = 28
      ex = 1
    for x in [sx..ex]
      PS.BeadData x,y, 0
      PS.BeadColor x,y, G.COLORS.BATTLE_GROUND.PATH
      PS.BeadGlyph x,y, ' '
    ye = Math.max(0,(26 - Math.floor(26*((s+1) / Game.Switch_backs))))
    for yi in [y..ye]
      PS.BeadData ex,yi, 0
      PS.BeadColor ex,yi, G.COLORS.BATTLE_GROUND.PATH
      PS.BeadGlyph ex,yi, ' '
  wi = 0
  for w in Game.Words
    w.draw(wi)
    wi += 1

  draw_player_buffer()
  draw_comp_buffer()

draw_player_buffer = () ->
  ### draw the construction zones ###
  for x in [0..Game.Player.Max_word_length]
    PS.BeadBorderColor 29-x,26, G.COLORS.PLAYER.BUFFER.BORDER
    PS.BeadBorderWidth 29-x,26, 1
    PS.BeadColor 29-x,26, G.COLORS.PLAYER.BUFFER.BG
    PS.BeadGlyph 29-x,26,' '
  if Game.Player.Current_word.length > 0
    for x in [0..(Game.Player.Current_word.length-1)]
      PS.BeadGlyphColor 29-(Game.Player.Current_word.length-1)+x,26, G.COLORS.PLAYER.WORD.GLYPH
      PS.BeadGlyph 29-(Game.Player.Current_word.length-1)+x,26,Game.Player.Current_word[x]
draw_comp_buffer = () ->
  ### draw the construction zones ###
  for x in [0..Game.Comp.Max_word_length]
    PS.BeadBorderColor 29-x,0, G.COLORS.COMP.BUFFER.BORDER
    PS.BeadBorderWidth 29-x,0, 1
    PS.BeadColor 29-x,0, G.COLORS.COMP.BUFFER.BG
    PS.BeadGlyph 29-x,0,' '
  if Game.Comp.Current_word.length > 0
    for x in [0..(Game.Comp.Current_word.length-1)]
      PS.BeadGlyph 29-(Game.Comp.Current_word.length-1)+x,0,Game.Comp.Current_word[x]
click_income_ups = (x,y) ->
  l_i = []
  for l of Letters
    l_i.push(l)
  if Game.Player.Resources['tech'].current > 0 and Game.Player.Resources[l_i[x-1]].income > 1 or Game.Player.Resources[l_i[x-1]].income == 0
    PS.AudioPlay 'perc_hihat_closed' if G.Sound
    Game.Player.Resources['tech'].current -= 1
    update_tech_current()
    if Game.Player.Resources[l_i[x-1]].income == 0
      Game.Player.Resources[l_i[x-1]].income = 60
    else
      Game.Player.Resources[l_i[x-1]].income = Math.max(1,Math.floor(0.75*Game.Player.Resources[l_i[x-1]].income))

    c = PS.UnmakeRGB 0x000000
    if Game.Player.Resources[l_i[x-1]].income != 0
      c.r = Math.floor((1-(Game.Player.Resources[l_i[x-1]].income / 60)) * 256)
      c.g = Math.floor((1-(Game.Player.Resources[l_i[x-1]].income / 60)) * 256)
      c.b = Math.floor((1-(Game.Player.Resources[l_i[x-1]].income / 60)) * 256)
    PS.BeadColor x,28,c
    PS.BeadGlyph x,28,l_i[x-1]
    PS.BeadGlyphColor x,28,0x0000ff
    PS.BeadBorderWidth x,28,1
    PS.BeadFlash x,28
    PS.BeadColor x,29,0x555555
    PS.BeadGlyph x,29,String(Game.Player.Resources[l_i[x-1]].current)
    PS.BeadBorderWidth x,29,1
    PS.BeadFlash x,29
  else
    PS.AudioPlay 'fx_whistle' if G.Sound

update_tech_current= () ->
  r = 'tech'
  PS.BeadFlash 29,29 if Game.Player.Resources[r].current < 11
  PS.BeadGlyph 29,29,String(Game.Player.Resources[r].current) if Game.Player.Resources[r].current < 10
  PS.BeadGlyph 29,29,'*' if Game.Player.Resources[r].current == 10

updtate_letter_current = (r) ->
  xi = 1
  for l of Letters
    if r == l
      break
    xi += 1
  PS.BeadFlash xi,29 if Game.Player.Resources[r].current < 11
  PS.BeadGlyph xi,29,String(Game.Player.Resources[r].current) if Game.Player.Resources[r].current < 10
  PS.BeadGlyph xi,29,'*' if Game.Player.Resources[r].current == 10

fill_buffer = (v) ->
  ### fills the player buffer with the passed in value ###
  if Game.Player.Current_word.length <= Game.Player.Max_word_length
    Game.Player.Resources[v].current -= 1
    updtate_letter_current(v)
    Game.Player.Current_word = Game.Player.Current_word + v
    draw_player_buffer()
  else
    PS.AudioPlay 'fx_whistle' if G.Sound

build_player_word = () ->
  ### Takes the current word and starts it on its way to death ###
  if Game.Player.Current_word.length > 0
    if word_in_dictionary(Game.Player.Current_word)
      if PS.BeadColor(29-Game.Player.Max_word_length-1,26) == G.COLORS.BATTLE_GROUND.PATH
        w = new word()
        for l in Game.Player.Current_word
          w.letters.push(new letter('?',l))
        w.head.x = 29-Game.Player.Max_word_length
        w.head.y = 26
        w.player = 'player'
        w.direction = -1
        Game.Words.push(w)
        Game.Player.Current_word = ''
      else
        PS.StatusText 'No room to move forward.'
    else
      PS.StatusText Game.Player.Current_word + ' is not in our dictionary.'
  else
    PS.StatusText 'Please enter a word.'

build_comp_word = () ->
  ### Takes the current word and starts it on its way to death ###
  if Game.Comp.Current_word.length > 0 and PS.BeadColor(29-Game.Comp.Max_word_length-1,0) == G.COLORS.BATTLE_GROUND.PATH
    w = new word()
    for l in Game.Comp.Current_word
      w.letters.push(new letter('?',l))
    w.head.x = 29-Game.Comp.Max_word_length
    w.head.y = 0
    w.player = 'comp'
    w.direction = -1
    Game.Words.push(w)
    Game.Comp.Current_word = ''

draw_home_screen = () ->
  PS.BeadFlash PS.ALL,PS.ALL, false
  PS.BeadColor PS.ALL,PS.ALL, 0x333333
  PS.BeadBorderWidth PS.ALL,PS.ALL, 0
  PS.BeadGlyph PS.ALL,PS.ALL, 0
  ###title ###
  t = ['W','o','r','d',' ','W','a','r','s']
  x = Math.floor((30-t.length) / 2)
  for ti in t
    PS.BeadGlyphColor x,2,0x000000
    PS.BeadColor x,2,0xffffff
    PS.BeadGlyph x,2,ti
    x += 1

  ### Game settings ###
  t = ['G','a','m','e',' ','S','e','t','t','i','n','g','s']
  x = 1
  for ti in t
    PS.BeadGlyphColor x,5,0x000000
    PS.BeadColor x,5,0xffffff
    PS.BeadGlyph x,5,ti
    x += 1
  t = ['G','a','m','e',' ','S','p','e','e','d']
  x = 2
  for ti in t
    PS.BeadGlyphColor x,7,0x000000
    PS.BeadColor x,7,0xffffff
    PS.BeadGlyph x,7,ti
    x += 1
  PS.BeadGlyphColor 3,9,0x000000
  PS.BeadBorderColor 3,9,0x000000
  PS.BeadBorderWidth 3,9,1
  PS.BeadColor 3,9,0xffffff
  PS.BeadGlyph 3,9,'◀'
  PS.BeadData 3,9, (x,y) ->
    PS.AudioPlay 'fx_click'
    Setting.Game_speed = Math.max(1,Setting.Game_speed-1)
    draw_home_screen()
  gs = Setting.Game_speed
  tens = Math.floor(gs/10)
  ones = gs - tens*10
  PS.BeadGlyphColor 4,9,0x000000
  PS.BeadColor 4,9,0xffffff
  PS.BeadGlyph 4,9,String(tens)
  PS.BeadGlyphColor 5,9,0x000000
  PS.BeadColor 5,9,0xffffff
  PS.BeadGlyph 5,9,String(ones)
  PS.BeadGlyphColor 6,9,0x000000
  PS.BeadBorderColor 6,9,0x000000
  PS.BeadBorderWidth 6,9,1
  PS.BeadColor 6,9,0xffffff
  PS.BeadGlyph 6,9,'▶'
  PS.BeadData 6,9, (x,y) ->
    PS.AudioPlay 'fx_click'
    Setting.Game_speed = Math.min(60,Setting.Game_speed+1)
    draw_home_screen()
  t = ['G','a','m','e',' ','T','y','p','e']
  x = 2
  for ti in t
    PS.BeadGlyphColor x,11,0x000000
    PS.BeadColor x,11,0xffffff
    PS.BeadGlyph x,11,ti
    x += 1
  PS.BeadGlyphColor 3,13,0x000000
  PS.BeadBorderColor 3,13,0x000000
  PS.BeadBorderWidth 3,13,1
  PS.BeadColor 3,13,0xffffff
  PS.BeadGlyph 3,13,'◀'
  PS.BeadData 3,13, (x,y) ->
    PS.AudioPlay 'fx_click'
    Setting.Game_type -= 1
    Setting.Game_type = Setting.Game_types.length-1 if Setting.Game_type < 0
    draw_home_screen()
  t = Setting.Game_types[Setting.Game_type]
  x = 4
  for ti in t
    PS.BeadGlyphColor x,13,0x000000
    PS.BeadColor x,13,0xffffff
    PS.BeadGlyph x,13,ti
    x += 1
  PS.BeadGlyphColor x,13,0x000000
  PS.BeadBorderColor x,13,0x000000
  PS.BeadBorderWidth x,13,1
  PS.BeadColor x,13,0xffffff
  PS.BeadGlyph x,13,'▶'
  PS.BeadData x,13, (x,y) ->
    PS.AudioPlay 'fx_click'
    Setting.Game_type = (Setting.Game_type + 1 ) % Setting.Game_types.length
    draw_home_screen()

  t = 'Brutal'
  x = 2
  for ti in t
    PS.BeadGlyphColor x,15,0x000000
    PS.BeadColor x,15,0xffffff
    PS.BeadGlyph x,15,ti
    x += 1

  PS.BeadGlyph x+1,15, '✓' if Setting.Brutal_mode
  PS.BeadGlyph x+1,15, ' ' if Setting.Brutal_mode == false
  PS.BeadGlyphColor x+1,15,0x000000
  PS.BeadColor x+1,15,0xffffff
  PS.BeadBorderWidth x+1,15, 1
  PS.BeadBorderColor x+1,15, 0x000000
  PS.BeadData x+1,15, (x,y) ->
    if Setting.Brutal_mode
      Setting.Brutal_mode = false
    else
      Setting.Brutal_mode = true
    draw_home_screen()
  ### AI settings ###
  t = ['A','I',' ','S','e','t','t','i','n','g','s']
  x = 29-t.length
  for ti in t
    PS.BeadGlyphColor x,5,0x000000
    PS.BeadColor x,5,0xffffff
    PS.BeadGlyph x,5,ti
    x += 1

  t = 'AI Type'
  x = 28-t.length
  for ti in t
    PS.BeadGlyphColor x,7,0x000000
    PS.BeadColor x,7,0xffffff
    PS.BeadGlyph x,7,ti
    x += 1
  PS.BeadGlyphColor 27,9,0x000000
  PS.BeadBorderColor 27,9,0x000000
  PS.BeadBorderWidth 27,9,1
  PS.BeadColor 27,9,0xffffff
  PS.BeadGlyph 27,9,'▶'
  PS.BeadData 27,9, (x,y) ->
    PS.AudioPlay 'fx_click'
    Setting.AI_type = (Setting.AI_type + 1 ) % Setting.AI_types.length
    draw_home_screen()
  t = Setting.AI_types[Setting.AI_type]
  x = 27- t.length
  for ti in t
    PS.BeadGlyphColor x,9,0x000000
    PS.BeadColor x,9,0xffffff
    PS.BeadGlyph x,9,ti
    x += 1

  t = 'AI Speed'
  x = 28-t.length
  for ti in t
    PS.BeadGlyphColor x,11,0x000000
    PS.BeadColor x,11,0xffffff
    PS.BeadGlyph x,11,ti
    x += 1

  PS.BeadGlyphColor 24,13,0x000000
  PS.BeadBorderColor 24,13,0x000000
  PS.BeadBorderWidth 24,13,1
  PS.BeadColor 24,13,0xffffff
  PS.BeadGlyph 24,13,'◀'
  PS.BeadData 24,13, (x,y) ->
    PS.AudioPlay 'fx_click'
    Setting.AI_speed = Math.max(1,Setting.AI_speed-1)
    draw_home_screen()
  gs = Setting.AI_speed
  tens = Math.floor(gs/10)
  ones = gs - tens*10
  PS.BeadGlyphColor 25,13,0x000000
  PS.BeadColor 25,13,0xffffff
  PS.BeadGlyph 25,13,String(tens)
  PS.BeadGlyphColor 26,13,0x000000
  PS.BeadColor 26,13,0xffffff
  PS.BeadGlyph 26,13,String(ones)
  PS.BeadGlyphColor 27,13,0x000000
  PS.BeadBorderColor 27,13,0x000000
  PS.BeadBorderWidth 27,13,1
  PS.BeadColor 27,13,0xffffff
  PS.BeadGlyph 27,13,'▶'
  PS.BeadData 27,13, (x,y) ->
    PS.AudioPlay 'fx_click'
    Setting.AI_speed = Math.min(60,Setting.AI_speed+1)
    draw_home_screen()

  t = 'Play'
  x = Math.floor((30-t.length) / 2)
  for ti in t
    PS.BeadGlyphColor x,17,0x000000
    PS.BeadColor x,17,0xffffff
    PS.BeadGlyph x,17,ti
    PS.BeadData x,17, (x,y) ->
      PS.AudioPlay 'perc_triangle'
      G.Mode = 'game'
      PS.Init()
    x += 1




load_dictionary = () ->
  result = null
  jQuery.ajax
    type: "GET"
    url: "/dict"
    async: false
    success: (data) ->
      result = data.split('\n')

  result

load_ai_script = () ->
  result = null
  jQuery.ajax
    type: "GET"
    url: AI_Types[Setting.AI_types[Setting.AI_type]]
    async: false
    success: (data) ->
      result = data

  result
word_in_dictionary = (word) ->
  for w in Dictionary
    if w == word
      return true
  return false
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
  Sound: true
  D_loaded: false
  COLORS:
    PLAYER:
      WORD:
        BG: 0x30395C
        GLYPH: 0xF2ECEC
      BUFFER:
        BG: 0x1A1F2B
        GLYPH: 0xF2ECEC
        BORDER: 0x85A5CC
      FLASH: 0x4A6491
    COMP:
      WORD:
        BG: 0x5C3930
        GLYPH: 0xECECF2
      BUFFER:
        BG: 0x2B1F1A
        GLYPH: 0xECECF2
        BORDER: 0xCCA585
      FLASH: 0x91644A
    BATTLE_GROUND:
      PATH: 0x89B474
      BG: ([0x557F50,0x8A661E,0x41700F])
  Tick: 0
  Mode: 'home'
Dictionary = 'EMPTY'
Game =
  Move_Time: 30
  Switch_backs: 3
  Player:
    Max_word_length: 5
    Current_word: ''
    Used_Words: []
    Resources:
      tech:
        income: 1
        current: 0
      a:
        income: 0
        current: 5
      b:
        income: 0
        current: 5
      c:
        income: 0
        current: 5
      d:
        income: 0
        current: 0
      e:
        income: 0
        current: 0
      f:
        income: 0
        current: 0
      g:
        income: 0
        current: 0
      h:
        income: 0
        current: 0
      i:
        income: 0
        current: 0
      j:
        income: 0
        current: 0
      k:
        income: 0
        current: 0
      l:
        income: 0
        current: 0
      m:
        income: 0
        current: 0
      n:
        income: 0
        current: 0
      o:
        income: 0
        current: 0
      p:
        income: 0
        current: 0
      q:
        income: 0
        current: 0
      r:
        income: 0
        current: 0
      s:
        income: 0
        current: 0
      t:
        income: 0
        current: 0
      u:
        income: 0
        current: 0
      v:
        income: 0
        current: 0
      w:
        income: 0
        current: 0
      x:
        income: 0
        current: 0
      y:
        income: 0
        current: 0
      z:
        income: 0
        current: 0
  Comp:
    Max_word_length: 8
    Current_word: ''
    Type_speed: 60
    Letter_index: 0
    Script: "EMPTY"
  Words: []
Setting =
  AI_type: 0
  AI_types: ['hamlet']
  AI_speed: 60
  Game_speed: 15
  Game_type: 0
  Game_types: ['Horder','Builder']
  Brutal_mode: false
Game_Types =
  Horder:
    tech:
      income: 0
      current: 10
    a:
      income: 0
      current: 20
    b:
      income: 0
      current: 10
    c:
      income: 0
      current: 10
    d:
      income: 0
      current: 10
    e:
      income: 0
      current: 20
    f:
      income: 0
      current: 10
    g:
      income: 0
      current: 10
    h:
      income: 0
      current: 10
    i:
      income: 0
      current: 20
    j:
      income: 0
      current: 10
    k:
      income: 0
      current: 10
    l:
      income: 0
      current: 10
    m:
      income: 0
      current: 10
    n:
      income: 0
      current: 10
    o:
      income: 0
      current: 20
    p:
      income: 0
      current: 10
    q:
      income: 0
      current: 10
    r:
      income: 0
      current: 10
    s:
      income: 0
      current: 10
    t:
      income: 0
      current: 10
    u:
      income: 0
      current: 20
    v:
      income: 0
      current: 10
    w:
      income: 0
      current: 10
    x:
      income: 0
      current: 10
    y:
      income: 0
      current: 10
    z:
      income: 0
      current: 10
  Builder:
    tech:
      income: 0
      current: 25
    a:
      income: 0
      current: 0
    b:
      income: 0
      current: 0
    c:
      income: 0
      current: 0
    d:
      income: 0
      current: 0
    e:
      income: 0
      current: 0
    f:
      income: 0
      current: 0
    g:
      income: 0
      current: 0
    h:
      income: 0
      current: 0
    i:
      income: 0
      current: 0
    j:
      income: 0
      current: 0
    k:
      income: 0
      current: 0
    l:
      income: 0
      current: 0
    m:
      income: 0
      current: 0
    n:
      income: 0
      current: 0
    o:
      income: 0
      current: 0
    p:
      income: 0
      current: 0
    q:
      income: 0
      current: 0
    r:
      income: 0
      current: 0
    s:
      income: 0
      current: 0
    t:
      income: 0
      current: 0
    u:
      income: 0
      current: 0
    v:
      income: 0
      current: 0
    w:
      income: 0
      current: 0
    x:
      income: 0
      current: 0
    y:
      income: 0
      current: 0
    z:
      income: 0
      current: 0
AI_Types =
  hamlet: '/wordwars/ai/hamlet'
Dictionary = load_dictionary()
###------------------------------------------ PS Events ----------------------------------------- ###
PS.Init = ->
  PS.GridSize 30,30
  PS.BeadBorderWidth PS.ALL,PS.ALL,0
  PS.BeadColor PS.ALL,PS.ALL,0x555555
  if G.Mode == 'game'
    Dictionary = load_dictionary() if Dictionary == 'EMPTY'

    Game.Move_Time = Setting.Game_speed
    Game.Switch_backs = 3

    Game.Comp.Current_word = ''
    Game.Comp.Type_speed = Setting.AI_speed
    Game.Comp.Letter_index = 0
    Game.Comp.Script = load_ai_script()

    Game.Player.Current_word = ''
    Game.Player.Used_Words = []
    for r of Game_Types[Setting.Game_types[Setting.Game_type]]
      Game.Player.Resources[r].income = Game_Types[Setting.Game_types[Setting.Game_type]][r].income
      Game.Player.Resources[r].current = Game_Types[Setting.Game_types[Setting.Game_type]][r].current


    PS.Clock(1)
    draw_battleground()
    draw_tech_zone()
  else if G.Mode == 'home'
    draw_home_screen()

PS.Click = (x, y, data) ->
  "use strict"
  if typeof data == "function"
    data(x,y)

PS.Release = (x, y, data) ->
  "use strict"

PS.Enter = (x, y, data) ->
  "use strict"

PS.Leave = (x, y, data) ->
  "use strict"

PS.KeyDown = (key, shift, ctrl) ->
  "use strict"
  lower = [97..122]
  upper = [65..90]
  l_i = []
  for l of Letters
    l_i.push(l)

  if key in lower
    fill_buffer(l_i[key-97]) if Game.Player.Resources[l_i[key-97]].current > 0
  else if key in upper
    fill_buffer(l_i[key-65]) if Game.Player.Resources[l_i[key-65]].current > 0
  else if key == 32 or key == 13
    build_player_word()
  else if key == 8
    if Game.Player.Current_word.length > 1
      Game.Player.Current_word = Game.Player.Current_word[0..(Game.Player.Current_word.length-2)]
    else if Game.Player.Current_word.length > 0
      Game.Player.Current_word = ''
    draw_player_buffer()
  else
    build_comp_word()



PS.KeyUp = (key, shift, ctrl) ->
  "use strict"

PS.Wheel = (dir) ->
  "use strict"

PS.Tick = ->
  "use strict"
  ###every hour reset clock ###
  G.Tick += 1
  G.Tick = 0 if G.Tick >= 216000
  ### move words ###
  if G.Tick % Game.Move_Time == 0
    dwi = -1
    wi = 0
    for w in Game.Words
      draw_path()
      if w.letters.length > 0 and w.history.length > 0
        Game.Words[wi].move()
      else
        dwi = wi
      wi += 1
    for w in Game.Words
      w.has_moved = false
    if dwi != -1
      Game.Words.splice(dwi,1)
  ### have comp type ###
  if G.Tick % Game.Comp.Type_speed == 0
    next_letter = Game.Comp.Script[Game.Comp.Letter_index].toLowerCase()
    Game.Comp.Letter_index += 1
    if next_letter in [' ','\n']
      build_comp_word()
    else
      Game.Comp.Current_word = Game.Comp.Current_word + next_letter

  ### update resorces ###
  for r of Game.Player.Resources
    if Game.Player.Resources[r].income > 0  and G.Tick % (Game.Player.Resources[r].income * 60) == 0
      Game.Player.Resources[r].current += 1
      if r == 'tech'
        PS.AudioPlay 'perc_cymbal_ride' if G.Sound and Game.Player.Resources[r].current < 10
        update_tech_current()
      else
        xi = 1
        for l of Letters
          if r == l
            break
          xi += 1
        PS.BeadFlash xi,29 if Game.Player.Resources[r].current < 11
        PS.BeadGlyph xi,29,String(Game.Player.Resources[r].current) if Game.Player.Resources[r].current < 10
        PS.BeadGlyph xi,29,'*' if Game.Player.Resources[r].current == 10






  ### END OF GAME CODE ###