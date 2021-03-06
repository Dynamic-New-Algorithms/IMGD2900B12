### oppen to puplic use
    Dynamic New Algorithms
    William Decker
    Peter Lepper
###

###------------------------------------ Classes -------------------------------------###
class unit
  constructor: (x,y,kind,player) ->
    @x = x
    @y = y
    @kind = kind
    @selected = false
    @hover = false
    @player = player
    @has_moved = false
    @last_shot = 0
    @dest =
      x: x
      y: x

  draw: () ->
    if (@x - GAME.Off_Set.x >= 0 and  @x - GAME.Off_Set.x < G.GRID.WIDTH and @y - GAME.Off_Set.y >= 0 and  @y - GAME.Off_Set.y < G.GRID.HEIGHT)

      x = @x - GAME.Off_Set.x
      y = @y - GAME.Off_Set.y

      test_a = false
      test_b = false
      test_c = false
      test_d = false
      if @kind == 'a'
        test_a = @x - 1 >= 0 and GAME.Board.Data[@x - 1][@y].ocupied != 0 and GAME.Board.Data[@x - 1][@y].ocupied.player == 'player' and GAME.Board.Data[@x - 1][@y].ocupied.kind != 'a'
        test_b = @x+1 <= GAME.Board.Width and GAME.Board.Data[@x + 1][@y].ocupied != 0  and GAME.Board.Data[@x + 1][@y].ocupied.player == 'player' and GAME.Board.Data[@x + 1][@y].ocupied.kind != 'a'
        test_c = @y - 1 >= 0 and GAME.Board.Data[@x][@y - 1].ocupied != 0  and GAME.Board.Data[@x][@y - 1].ocupied.player == 'player' and GAME.Board.Data[@x][@y - 1].ocupied.kind != 'a'
        test_d = @y+1 <= GAME.Board.Height and GAME.Board.Data[@x][@y + 1].ocupied != 0 and GAME.Board.Data[@x][@y + 1].ocupied.player == 'player' and GAME.Board.Data[@x][@y + 1].ocupied.kind != 'a'
      else
        test_a = @x - 1 >= 0 and GAME.Board.Data[@x - 1][@y].ocupied != 0 and GAME.Board.Data[@x - 1][@y].ocupied.player == 'player'
        test_b = @x+1 <= GAME.Board.Width and GAME.Board.Data[@x + 1][@y].ocupied != 0  and GAME.Board.Data[@x + 1][@y].ocupied.player == 'player'
        test_c = @y - 1 >= 0 and GAME.Board.Data[@x][@y - 1].ocupied != 0  and GAME.Board.Data[@x][@y - 1].ocupied.player == 'player'
        test_d = @y+1 <= GAME.Board.Height and GAME.Board.Data[@x][@y + 1].ocupied != 0 and GAME.Board.Data[@x][@y + 1].ocupied.player == 'player'

      PS.BeadColor x,y, G.COLORS.UNIT.HOVER_OK if @hover
      PS.BeadColor x,y, G.COLORS.UNIT.HOVER_GOOD if @hover and GAME.Board.Data[@x][@y].ocupied == 0 and (test_a or test_b or test_c or test_d)
      PS.BeadColor x,y, G.COLORS.UNIT.HOVER_BAD if @hover and GAME.Board.Data[@x][@y].ocupied != 0

      PS.BeadBorderWidth x,y,3 if @selected
      PS.BeadBorderColor x,y,G.COLORS.UNIT.SELECTED if @selected

      PS.BeadGlyphColor x,y, G.COLORS.UNIT.PLAYER if @player == 'player'
      PS.BeadGlyphColor x,y, G.COLORS.UNIT.COMP if @player == 'comp'

      PS.BeadGlyph x,y, '♜' if @kind == 'd'
      PS.BeadGlyph x,y, '⚒' if @kind == 'p'
      PS.BeadGlyph x,y, '♞' if @kind == 'a'
    else if @hover
      x = @x - GAME.Off_Set.x
      y = @y - GAME.Off_Set.y
      PS.BeadColor x,y, G.COLORS.UNIT.HOVER_OK if @hover
      PS.BeadGlyphColor x,y, G.COLORS.UNIT.PLAYER if @player == 'player'
      PS.BeadGlyphColor x,y, G.COLORS.UNIT.COMP if @player == 'comp'
      PS.BeadGlyph x,y, '♜' if @kind == 'd'
      PS.BeadGlyph x,y, '⚒' if @kind == 'p'
      PS.BeadGlyph x,y, '♞' if @kind == 'a'
  shoot: () ->
    if @last_shot + G.BALANCE.SHOOTING_FEQ < G.Tick or G.Tick < @last_shot
      for y in [0..G.BALANCE.BULLET.LIFE]
        break if within_Board(@x,@y+y) == false
        break if GAME.Board.Data[@x][@y+y].ocupied.kind == 'm'
        if GAME.Board.Data[@x][@y+y].ocupied != 0 and GAME.Board.Data[@x][@y+y].ocupied.player != @player and GAME.Board.Data[@x][@y+y].ocupied.player != 'world'
          GAME.Board.Bullets.push(new bullet(@x,@y,0,1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          GAME.Board.Flashes.push(new flash(@x,@y,G.COLORS.FLASH.SHOOT,G.BALANCE.FLASH.SHOOT))
          return true

      for y in [0..G.BALANCE.BULLET.LIFE]
        break if within_Board(@x,@y-y) == false
        break if GAME.Board.Data[@x][@y-y].ocupied.kind == 'm'
        if GAME.Board.Data[@x][@y-y].ocupied != 0 and GAME.Board.Data[@x][@y-y].ocupied.player != @player and GAME.Board.Data[@x][@y-y].ocupied.player != 'world'
          GAME.Board.Bullets.push(new bullet(@x,@y,0,-1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          GAME.Board.Flashes.push(new flash(@x,@y,G.COLORS.FLASH.SHOOT,G.BALANCE.FLASH.SHOOT))
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if within_Board(@x-x,@y) == false
        break if GAME.Board.Data[@x-x][@y].ocupied.kind == 'm'
        if GAME.Board.Data[@x-x][@y].ocupied != 0 and GAME.Board.Data[@x-x][@y].ocupied.player != @player and GAME.Board.Data[@x-x][@y].ocupied.player != 'world'
          GAME.Board.Bullets.push(new bullet(@x,@y,-1,0,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          GAME.Board.Flashes.push(new flash(@x,@y,G.COLORS.FLASH.SHOOT,G.BALANCE.FLASH.SHOOT))
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if within_Board(@x+x,@y) == false
        break if GAME.Board.Data[@x+x][@y].ocupied.kind == 'm'
        if GAME.Board.Data[@x+x][@y].ocupied != 0 and GAME.Board.Data[@x+x][@y].ocupied.player != @player and GAME.Board.Data[@x+x][@y].ocupied.player != 'world'
          GAME.Board.Bullets.push(new bullet(@x,@y,1,0,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          GAME.Board.Flashes.push(new flash(@x,@y,G.COLORS.FLASH.SHOOT,G.BALANCE.FLASH.SHOOT))
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if within_Board(@x+x,@y+x) == false
        break if GAME.Board.Data[@x+x][@y+x].ocupied.kind == 'm'
        if GAME.Board.Data[@x+x][@y+x].ocupied != 0 and GAME.Board.Data[@x+x][@y+x].ocupied.player != @player and GAME.Board.Data[@x+x][@y+x].ocupied.player != 'world'
          GAME.Board.Bullets.push(new bullet(@x,@y,1,1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          GAME.Board.Flashes.push(new flash(@x,@y,G.COLORS.FLASH.SHOOT,G.BALANCE.FLASH.SHOOT))
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if within_Board(@x-x,@y-x) == false
        break if GAME.Board.Data[@x-x][@y-x].ocupied.kind == 'm'
        if GAME.Board.Data[@x-x][@y-x].ocupied != 0 and GAME.Board.Data[@x-x][@y-x].ocupied.player != @player and GAME.Board.Data[@x-x][@y-x].ocupied.player != 'world'
          GAME.Board.Bullets.push(new bullet(@x,@y,-1,-1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          GAME.Board.Flashes.push(new flash(@x,@y,G.COLORS.FLASH.SHOOT,G.BALANCE.FLASH.SHOOT))
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if within_Board(@x-x,@y+x) == false
        break if GAME.Board.Data[@x-x][@y+x].ocupied.kind == 'm'
        if GAME.Board.Data[@x-x][@y+x].ocupied != 0 and GAME.Board.Data[@x-x][@y+x].ocupied.player != @player and GAME.Board.Data[@x-x][@y+x].ocupied.player != 'world'
          GAME.Board.Bullets.push(new bullet(@x,@y,-1,1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          GAME.Board.Flashes.push(new flash(@x,@y,G.COLORS.FLASH.SHOOT,G.BALANCE.FLASH.SHOOT))
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if within_Board(@x+x,@y-x) == false
        break if GAME.Board.Data[@x+x][@y-x].ocupied.kind == 'm'
        if GAME.Board.Data[@x+x][@y-x].ocupied != 0 and GAME.Board.Data[@x+x][@y-x].ocupied.player != @player  and GAME.Board.Data[@x+x][@y-x].ocupied.player != 'world'
          GAME.Board.Bullets.push(new bullet(@x,@y,1,-1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          GAME.Board.Flashes.push(new flash(@x,@y,G.COLORS.FLASH.SHOOT,G.BALANCE.FLASH.SHOOT))
          return true
  move: () ->
    if @kind == 'p'
      GAME.Player.Credits += G.BALANCE.PRODUCTION_RATE  if @player == 'player'
      GAME.Comp.Credits += G.BALANCE.PRODUCTION_RATE  if @player == 'comp'
    else if @kind == 'd'
      this.shoot()
    else if @kind == 'a'
      this.shoot()
      if @dest.x != @x or @dest.y != @y

        @has_moved = true
        apple = { }
        h = Math.abs(@dest.x - @x) + Math.abs(@dest.y - @y)
        apple[String(@x+','+@y)] = {v: h, moves: 0,history: '',explored: false}
        goal = String(@dest.x+','+@dest.y)
        lowest = String(@x+','+@y)
        last_move = ''
        size = 1


        while lowest != goal and size < 512
          ss = 'lowest = ' + lowest + '\n'
          for n of apple
            s = n + ') '
            for e of apple[n]
              s += e + ' = ' + apple[n][e] + ', '
            ss += s + '\n'
          #alert ss
          m = apple[lowest].moves
          hi = apple[lowest].history
          apple[lowest].explored = true
          x = lowest.split(',')
          y = Number(x[1])
          x = Number(x[0])
          north = -1
          south = -1
          east = -1
          west = -1
          if within_Board(x,y-1)
            north = Math.abs(@dest.x - x) + Math.abs(@dest.y - (y-1)) + m + 1 if (GAME.Board.Data[x][y-1].ocupied == 0) or (GAME.Board.Data[x][y-1].ocupied.player != @player and GAME.Board.Data[x][y-1].ocupied.player != 'world') or (GAME.Board.Data[x][y-1].ocupied.kind == 'a')
          if within_Board(x,y+1)
            south = Math.abs(@dest.x - x) + Math.abs(@dest.y - (y+1)) + m + 1 if (GAME.Board.Data[x][y+1].ocupied == 0) or (GAME.Board.Data[x][y+1].ocupied.player != @player and GAME.Board.Data[x][y+1].ocupied.player != 'world') or (GAME.Board.Data[x][y+1].ocupied.kind == 'a')
          if within_Board(x+1,y)
            east = Math.abs(@dest.x - (x+1)) + Math.abs(@dest.y - y) + m + 1 if (GAME.Board.Data[x+1][y].ocupied == 0) or (GAME.Board.Data[x+1][y].ocupied.player != @player and GAME.Board.Data[x+1][y].ocupied.player != 'world') or (GAME.Board.Data[x+1][y].ocupied.kind == 'a')
          if within_Board(x-1,y)
            west = Math.abs(@dest.x - (x-1)) + Math.abs(@dest.y - y) + m + 1 if (GAME.Board.Data[x-1][y].ocupied == 0) or (GAME.Board.Data[x-1][y].ocupied.player != @player and GAME.Board.Data[x-1][y].ocupied.player != 'world') or (GAME.Board.Data[x-1][y].ocupied.kind == 'a')

          apple[String(x+','+(y-1))] = {v: north, moves: m+1,history: hi+'n',explored: false} if north != -1 and (apple[String(x+','+(y-1))] is undefined or apple[String(x+','+(y-1))].v > north )
          apple[String(x+','+(y+1))] = {v: south, moves: m+1,history: hi+'s',explored: false} if south != -1 and (apple[String(x+','+(y+1))] is undefined or apple[String(x+','+(y+1))].v > south )
          apple[String((x+1)+','+y)] = {v: east, moves: m+1,history: hi+'e',explored: false} if east != -1 and (apple[String((x+1)+','+y)] is undefined or apple[String((x+1)+','+y)].v > east )
          apple[String((x-1)+','+y)] = {v: west, moves: m+1,history: hi+'w',explored: false} if west != -1 and (apple[String((x-1)+','+y)] is undefined or apple[String((x-1)+','+y)].v > west )

          lowest_v = GAME.Board.Width + GAME.Board.Height
          options = []
          for node of apple
            if apple[node].v == lowest_v and apple[node].explored == false
              options.push(node)
            else if  apple[node].v < lowest_v and apple[node].explored == false
              options = [node]
              lowest_v = apple[node].v
          if options.length == 0
            options = []
            if within_Board(@x+1,@y)
              if @x < @dest.x and GAME.Board.Data[@x+1][@y].ocupied == 0
                options.push(String((@x+1)+','+@y))
            if within_Board(@x-1,@y)
              if @x > @dest.x and GAME.Board.Data[@x-1][@y].ocupied == 0
                options.push(String((@x-1)+','+@y))
            if within_Board(@x,@y-1)
              if @y > @dest.y and GAME.Board.Data[@x][@y-1].ocupied == 0
                options.push(String((@x)+','+(@y-1)))
            if within_Board(@x,@y+1)
              if @y < @dest.y and GAME.Board.Data[@x][@y+1].ocupied == 0
                options.push(String((@x)+','+(@y+1)))
            lowest = options[Math.floor(Math.random()*options.length)]
            break
          lowest = options[Math.floor(Math.random()*options.length)]


        if apple[lowest] != undefined
          move = apple[lowest].history[0]
          if apple[lowest].history.length == 0
            options = []
            if within_Board(@x+1,@y)
              if @x < @dest.x and GAME.Board.Data[@x+1][@y].ocupied == 0
                options.push('e')
            if within_Board(@x-1,@y)
              if @x > @dest.x and GAME.Board.Data[@x-1][@y].ocupied == 0
                options.push('w')
            if within_Board(@x,@y-1)
              if @y > @dest.y and GAME.Board.Data[@x][@y-1].ocupied == 0
                options.push('n')
            if within_Board(@x,@y+1)
              if @y < @dest.y and GAME.Board.Data[@x][@y+1].ocupied == 0
                options.push('s')
            move = options[Math.floor(Math.random()*options.length)]


          dx = 0
          dy = 0
          dx = 1 if move == 'e'
          dx = -1 if move == 'w'
          dy = -1 if move == 'n'
          dy = 1 if move == 's'
          if GAME.Board.Data[@x+dx][@y+dy].ocupied == 0
            GAME.Board.Data[@x][@y].ocupied = 0
            @y = @y - 1 if move == 'n'
            @y = @y + 1 if move == 's'
            @x = @x + 1 if move == 'e'
            @x = @x - 1 if move == 'w'
            GAME.Board.Data[@x][@y].ocupied = this
            if G.Mode == 'tutorial'
              if TUT.current_step == 3
                TUT.current_step = 4
                TUT.current_tip = 0
                GAME.Board.Data[GAME.Board.Width-4][GAME.Board.Height-4].ocupied = new unit(GAME.Board.Width-4,GAME.Board.Height-4,'p','comp')
                GAME.Board.Data[GAME.Board.Width-3][GAME.Board.Height-4].ocupied = new unit(GAME.Board.Width-3,GAME.Board.Height-4,'p','comp')
                GAME.Board.Data[GAME.Board.Width-3][GAME.Board.Height-3].ocupied = new unit(GAME.Board.Width-3,GAME.Board.Height-3,'p','comp')
                GAME.Board.Data[GAME.Board.Width-5][GAME.Board.Height-5].ocupied = new unit(GAME.Board.Width-5,GAME.Board.Height-5,'d','comp')
                GAME.Board.Data[GAME.Board.Width-4][GAME.Board.Height-5].ocupied = new unit(GAME.Board.Width-4,GAME.Board.Height-5,'d','comp')


class nature
  constructor: (x,y,kind) ->
    @x = x
    @y = y
    @kind = kind
    @player = 'world'
    a = Math.random()
    b = Math.random()*(1-a)
    c = (1-a-b)
    p = [a,b,c]
    color = PS.UnmakeRGB 0x000000
    for i in [0..2]
      co = PS.UnmakeRGB G.COLORS.NATURE.WATER[i] if @kind == 'w'
      co = PS.UnmakeRGB G.COLORS.NATURE.ROCK[i] if @kind == 'm'
      color.r += Math.floor(co.r * p[i])
      color.g += Math.floor(co.g * p[i])
      color.b += Math.floor(co.b * p[i])
    @color = PS.MakeRGB(color.r,color.g,color.b)

  draw: () ->
    if @x - GAME.Off_Set.x >= 0 and  @x - GAME.Off_Set.x < G.GRID.WIDTH and @y - GAME.Off_Set.y >= 0 and  @y - GAME.Off_Set.y < G.GRID.HEIGHT

      x = @x - GAME.Off_Set.x
      y = @y - GAME.Off_Set.y
      PS.BeadColor x,y,@color
      ###
      if @kind == 'w'
        PS.BeadGlyph x,y,'≈'
        PS.BeadGlyphColor x,y,0x0000ff
      else if @kind == 'm'
        PS.BeadGlyph x,y,'∆'
        PS.BeadGlyphColor x,y,0x000000
      ###

  move: () ->
    a = 0

class bullet
  constructor: (x,y,vx,vy,player) ->
    @x = x
    @y = y
    @vx = vx
    @vy = vy
    @life = G.BALANCE.BULLET.LIFE
    @player = player
    @has_moved = false

  draw: () ->
    if @x - GAME.Off_Set.x >= 0 and  @x - GAME.Off_Set.x < G.GRID.WIDTH and @y - GAME.Off_Set.y >= 0 and  @y - GAME.Off_Set.y < G.GRID.HEIGHT

      x = @x - GAME.Off_Set.x
      y = @y - GAME.Off_Set.y

      PS.BeadGlyphColor x,y, G.COLORS.UNIT.PLAYER if @player == 'player'
      PS.BeadGlyphColor x,y, G.COLORS.UNIT.COMP if @player == 'comp'

      PS.BeadGlyph x,y, '|' if @vx == 0 and @vy != 0
      PS.BeadGlyph x,y, '-' if @vx != 0 and @vy == 0
      PS.BeadGlyph x,y, 92 if (@vx == -1 and @vy == -1) or (@vx == 1 and @vy == 1)
      PS.BeadGlyph x,y, 47 if (@vx == -1 and @vy == 1) or (@vx == 1 and @vy == -1)

  move:() ->
    @has_moved = true
    @life -= 1
    if within_Board(@x+@vx,@y+@vy)
      @x += @vx
      @y += @vy
      return GAME.Board.Data[@x][@y].ocupied != 0
    else
      return true
class flash
  constructor: (x,y,color,life) ->
    @x = x
    @y = y
    @color = {r: color.r,g: color.g, b: color.b}
    @life = life

  draw: () ->
    if @x - GAME.Off_Set.x >= 0 and  @x - GAME.Off_Set.x < G.GRID.WIDTH and @y - GAME.Off_Set.y >= 0 and  @y - GAME.Off_Set.y < G.GRID.HEIGHT
      x = @x - GAME.Off_Set.x
      y = @y - GAME.Off_Set.y

      PS.BeadColor x,y,@color

  move: () ->
    base_color = GAME.Board.Data[@x][@y].color
    @color.r = Math.max(Math.floor(@color.r*0.9),base_color.r)
    @color.g = Math.max(Math.floor(@color.g*0.9),base_color.g)
    @color.b = Math.max(Math.floor(@color.b*0.9),base_color.b)
    @life -= 1


class AI
  constructor: () ->
    @scale = 1
    @id = -1
    @min_p = 4
    @next_build = {p: 0.33,d: 0.33,a: 0.33}
    @attack_feq = 600
    @last_p_count = 0
    @last_d_cound = 0
    if Settings.AI == 'Rabbit'
      @min_p = 4
      @next_build = {p: 0.5,d: 0.25,a: 0.25}
      @attack_feq = 600
      @last_p_count = 0
      @last_d_cound = 0
    else if Settings.AI == 'Turtle'
      @min_p = 4
      @next_build = {p: 0.25,d: 0.5,a: 0.25}
      @attack_feq = 600
      @last_p_count = 0
      @last_d_cound = 0
    else if Settings.AI == 'Wolf'
      @min_p = 4
      @next_build = {p: 0.25,d: 0.25,a: 0.5}
      @attack_feq = 600
      @last_p_count = 0
      @last_d_cound = 0

    ###
    url = "/asciiai/get"
    json = 'nothing'
    $.ajax
      async: false
      global: false
      #data: {name: player_name, points: score, difficulty: Math.floor(1000*dificulty)}
      url: url
      dataType: "json"
      success: (d) ->
        json = d
    if json != 'nothing'
      p = json.ir_p
      d = json.ir_d
      a = json.ir_a
      @id = json.id
      @min_p = json.min_p
      @next_build = {p: p,d: d,a: a}
      @attack_feq = json.attack_timing
      @last_p_count = 0
      @last_d_cound = 0
    ###

  report: (win) ->
    if @id >= 0
      win = 0 if G.Tick < 180
      url = "/asciiai/update"
      json = 'nothing'
      $.ajax
        async: false
        global: false
        data: {id: @id, win: win}
        url: url
        dataType: "json"

  think: () ->

    force_attack = false
    if GAME.Comp.Credits >= 2 or G.Tick % 15 == 0
      their_a = 0
      their_d = 0
      their_p = 0
      my_p = 0
      my_a = 0
      my_d = 0
      options = []
      for x in [GAME.Board.Width..0]
        for y in [GAME.Board.Height..0]
          test_a = x - 1 >= 0 and GAME.Board.Data[x - 1][y].ocupied != 0 and GAME.Board.Data[x - 1][y].ocupied.player == 'comp' and GAME.Board.Data[x - 1][y].ocupied.kind != 'a'
          test_b = x+1 <= GAME.Board.Width and GAME.Board.Data[x + 1][y].ocupied != 0  and GAME.Board.Data[x + 1][y].ocupied.player == 'comp' and GAME.Board.Data[x + 1][y].ocupied.kind != 'a'
          test_c = y - 1 >= 0 and GAME.Board.Data[x][y - 1].ocupied != 0  and GAME.Board.Data[x][y - 1].ocupied.player == 'comp' and GAME.Board.Data[x][y - 1].ocupied.kind != 'a'
          test_d = y+1 <= GAME.Board.Height and GAME.Board.Data[x][y + 1].ocupied != 0 and GAME.Board.Data[x][y + 1].ocupied.player == 'comp' and GAME.Board.Data[x][y + 1].ocupied.kind != 'a'

          if GAME.Board.Data[x][y].ocupied == 0 and (test_a or test_b or test_c or test_d)
            options.push({x: x,y: y})
          else if GAME.Board.Data[x][y].ocupied != 0 and GAME.Board.Data[x][y].ocupied.player == 'player'
            their_a += 1 if GAME.Board.Data[x][y].ocupied.kind == 'a'
            their_d += 1 if GAME.Board.Data[x][y].ocupied.kind == 'd'
            their_p += 1 if GAME.Board.Data[x][y].ocupied.kind == 'p'
          else if GAME.Board.Data[x][y].ocupied != 0 and GAME.Board.Data[x][y].ocupied.player == 'comp'
            my_p += 1 if GAME.Board.Data[x][y].ocupied.kind == 'p'
            my_d += 1 if GAME.Board.Data[x][y].ocupied.kind == 'd'
            my_a += 1 if GAME.Board.Data[x][y].ocupied.kind == 'a'
      if options.length > 0
        if GAME.Comp.Credits >= 2
          nb = 'p'
          nb = 'a' if their_p / (their_a+their_d+their_p) > @next_build.p or my_a < @next_build.a * @scale
          nb = 'd' if their_a / (their_a+their_d+their_p) > @next_build.a or my_d < @next_build.d * @scale
          nb = 'p' if my_p <= @min_p
          GAME.Comp.Credits -= 1
          GAME.Comp.Credits -= 1 if nb == 'a'
          loc = options[Math.floor(Math.random()*options.length)]
          nb = new unit(loc.x,loc.y,nb,'comp')
          nb.dest.x = loc.x
          nb.dest.y = loc.y
          GAME.Board.Data[nb.x][nb.y].ocupied = nb
        if my_a > @next_build.a * @scale and my_a > 1
          @scale += 1
          ###PS.Debug 'forced attack because i have to many A ('+ my_a / (my_a+my_d+my_p) + ' > '+  @next_build.a + '\n'  ###
          force_attack = true
        if (their_a+their_d+their_p) < my_a
          ### PS.Debug 'forced attack because they have less buildings then i do attackers\n' ###
          force_attack = true
        if my_p < @last_p_count or my_d < @last_d_count
          ### PS.Debug 'forced attack because being attacked\n'   ###
          force_attack = true
        @last_p_count = my_p
        @last_d_count = my_d
    if (G.Tick % @attack_feq == 0 or force_attack) and G.Tick > 60
      move_op = []
      my_a = []
      for x in [0..GAME.Board.Width]
        for y in [0..GAME.Board.Height]
          test_a = x - 1 >= 0 and GAME.Board.Data[x - 1][y].ocupied != 0 and GAME.Board.Data[x - 1][y].ocupied.player == 'player'
          test_b = x+1 <= GAME.Board.Width and GAME.Board.Data[x + 1][y].ocupied != 0  and GAME.Board.Data[x + 1][y].ocupied.player == 'player'
          test_c = y - 1 >= 0 and GAME.Board.Data[x][y - 1].ocupied != 0  and GAME.Board.Data[x][y - 1].ocupied.player == 'player'
          test_d = y+1 <= GAME.Board.Height and GAME.Board.Data[x][y + 1].ocupied != 0 and GAME.Board.Data[x][y + 1].ocupied.player == 'player'

          if GAME.Board.Data[x][y].ocupied == 0 and (test_a or test_b or test_c or test_d)
            move_op.push({x: x,y: y})
          else if GAME.Board.Data[x][y].ocupied != 0 and  GAME.Board.Data[x][y].ocupied.player == 'comp' and  GAME.Board.Data[x][y].ocupied.kind == 'a'
            my_a.push({x: x,y: y})

      if my_a.length > 0 and move_op.length > 0
        for a in my_a
          d = move_op[Math.floor(Math.random()*(move_op.length))]
          GAME.Board.Data[a.x][a.y].ocupied.dest.x = d.x
          GAME.Board.Data[a.x][a.y].ocupied.dest.y = d.y


###------------------------------------------ Helper functions ----------------------------------------- ###
within_Board= (x,y) ->
  return x >=0 and x <= GAME.Board.Width and y>=0 and y <= GAME.Board.Height
build_die_flash_color = () ->
  a = Math.random()
  b = Math.random()*(1-a)
  c = (1-a-b)
  p = [a,b,c]
  color = PS.UnmakeRGB 0x000000
  for i in [0..2]
    co = PS.UnmakeRGB G.COLORS.FLASH.DIE[i]
    color.r += Math.floor(co.r * p[i])
    color.g += Math.floor(co.g * p[i])
    color.b += Math.floor(co.b * p[i])
  return color
build_blank_board = () ->
  if Settings.Map == 'Custom' or G.Mode == 'tutorial'
    GAME.Board.Data = []
    for x in [0..GAME.Board.Width]
      col = []
      for y in [0..GAME.Board.Height]
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
        col.push({ocupied: 0,color: PS.MakeRGB(color.r,color.g,color.b)})
      GAME.Board.Data.push(col)
    GAME.Board.Data[4][4].ocupied = new unit(4,4,'p','player')
    if G.Mode == 'play'
      GAME.Board.Data[GAME.Board.Width-3][GAME.Board.Height-3].ocupied = new unit(GAME.Board.Width-3,GAME.Board.Height-3,'p','comp')
      GAME.Board.Data[GAME.Board.Width-4][GAME.Board.Height-4].ocupied = new unit(GAME.Board.Width-4,GAME.Board.Height-4,'d','comp')

      if Settings.Board.Mountains
        left = Math.floor((GAME.Board.Width * GAME.Board.Height)*0.1)
        limit = 2 * left
        while left > 0 and limit > 0
          limit -= 1
          x = Math.floor(Math.random() * GAME.Board.Width)
          y = Math.floor(Math.random() * GAME.Board.Height)
          if GAME.Board.Data[x][y].ocupied == 0
            GAME.Board.Data[x][y].ocupied = new nature(x,y,'m')
            left -= 1
      if Settings.Board.Lakes
        left = Math.floor((GAME.Board.Width * GAME.Board.Height)*0.1)
        limit = 2 * left
        while left > 0 and limit > 0
          limit -= 1
          x = Math.floor(Math.random() * GAME.Board.Width)
          y = Math.floor(Math.random() * GAME.Board.Height)
          if GAME.Board.Data[x][y].ocupied == 0
            GAME.Board.Data[x][y].ocupied = new nature(x,y,'w')
            left -= 1
  else
    GAME.Board.Width = MAPS[Settings.Map].w
    GAME.Board.Height = MAPS[Settings.Map].h
    GAME.Board.Data = []
    for x in [0..GAME.Board.Width]
      col = []
      for y in [0..GAME.Board.Height]
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
        col.push({ocupied: 0,color: color})
      GAME.Board.Data.push(col)

    for x in [0..GAME.Board.Width]
      for y in [0..GAME.Board.Height]
        if MAPS[Settings.Map].data[y][x] == 1
          GAME.Board.Data[x][y].ocupied = new nature(x,y,'w')
        else if MAPS[Settings.Map].data[y][x] == 2
          GAME.Board.Data[x][y].ocupied = new nature(x,y,'m')
        else if MAPS[Settings.Map].data[y][x] == -1
          GAME.Board.Data[x][y].ocupied = new unit(x,y,'p','player')
        else if MAPS[Settings.Map].data[y][x] == -2
          GAME.Board.Data[x][y].ocupied = new unit(x,y,'p','comp')
          GAME.Board.Data[x-1][y-1].ocupied = new unit(x-1,y-1,'d','comp')



move_game= () ->
  player_unit_count = 0
  comp_unit_count = 0
  empty = 0
  for x in [0..GAME.Board.Width]
    for y in [0..GAME.Board.Height]
      if GAME.Board.Data[x][y].ocupied != 0
        if GAME.Board.Data[x][y].ocupied.has_moved == false
          GAME.Board.Data[x][y].ocupied.move()
        player_unit_count += 1 if GAME.Board.Data[x][y].ocupied.player == 'player'
        comp_unit_count += 1 if GAME.Board.Data[x][y].ocupied.player == 'comp'
      else
        empty += 1

  if G.Mode == 'play' or (G.Mode == 'tutorial' and TUT.current_step == 4)
    if player_unit_count == 0  or (empty <= 2 and player_unit_count < comp_unit_count)
      PS.Clock 0
      GAME.Comp.AI.report(1) if G.Mode == 'play'
      G.Mode = 'home'
      PS.AudioPlay 'fx_wilhelm'
      PS.BeadData PS.ALL,PS.ALL,0
      t = '☠ You Lost ☠'
      x = Math.floor((G.GRID.WIDTH-t.length) / 2)
      for ti in t
        PS.BeadColor x, Math.floor((G.GRID.HEIGHT) / 2), 0xffffff
        PS.BeadBorderWidth x,Math.floor((G.GRID.HEIGHT) / 2),0
        PS.BeadGlyphColor x,Math.floor((G.GRID.HEIGHT) / 2),0x000000
        PS.BeadGlyph x,Math.floor((G.GRID.HEIGHT) / 2), ti
        PS.BeadData x,Math.floor((G.GRID.HEIGHT) / 2), (event,x,y) ->
          if event == 'enter'
            PS.BeadColor x,y,0xdddd00
          else if event == 'leave'
            PS.BeadColor x,y,0xffffff
          else if event == 'click'
            G.Mode = 'home'
            PS.Init()
        x += 1
    if comp_unit_count == 0 or (empty <= 2 and player_unit_count > comp_unit_count)

      PS.Clock 0
      GAME.Comp.AI.report(0) if G.Mode == 'play'
      G.Mode = 'home'
      PS.BeadData PS.ALL,PS.ALL,0
      PS.AudioPlay 'fx_tada'
      t = '♕ You Won ♕'
      x = Math.floor((G.GRID.WIDTH-t.length) / 2)
      for ti in t
        PS.BeadColor x, Math.floor((G.GRID.HEIGHT) / 2), 0xffffff
        PS.BeadBorderWidth x,Math.floor((G.GRID.HEIGHT) / 2),0
        PS.BeadGlyphColor x,Math.floor((G.GRID.HEIGHT) / 2),0x000000
        PS.BeadGlyph x,Math.floor((G.GRID.HEIGHT) / 2), ti
        PS.BeadData x,Math.floor((G.GRID.HEIGHT) / 2), (event,x,y) ->
          if event == 'enter'
            PS.BeadColor x,y,0xdddd00
          else if event == 'leave'
            PS.BeadColor x,y,0xffffff
          else if event == 'click'
            G.Mode = 'home'
            PS.Init()
        x += 1



  if GAME.Board.Bullets.length > 0
    for bi in [0..GAME.Board.Bullets.length-1]
      b = GAME.Board.Bullets[bi]
      if b.has_moved == false
        hit = b.move()
        if hit
          if GAME.Board.Data[b.x][b.y].ocupied != 0
            if GAME.Board.Data[b.x][b.y].ocupied.player != b.player and GAME.Board.Data[b.x][b.y].ocupied.player != 'world'
              if Math.random() <= G.BALANCE.BULLET.SUCCESS_RATE
                GAME.Board.Data[b.x][b.y].ocupied = 0
                PS.AudioPlay G.SOUNDS.DIE
                GAME.Board.Flashes.push(new flash(b.x,b.y,build_die_flash_color(),G.BALANCE.FLASH.DIE))
                b.life = -1
          else
            b.life = -1



  if GAME.Board.Bullets.length > 0
    removed = 0
    for bi in [0..GAME.Board.Bullets.length-1]
      if (bi-removed) < GAME.Board.Bullets.length
        GAME.Board.Bullets[bi-removed].has_moved = false
        if GAME.Board.Bullets[bi-removed].life <= 0
          GAME.Board.Bullets.splice(bi-removed,1)
          removed += 1


  for x in [0..GAME.Board.Width]
    for y in [0..GAME.Board.Height]
      if GAME.Board.Data[x][y].ocupied != 0
        GAME.Board.Data[x][y].ocupied.has_moved = false


draw_game= () ->
  for xi in [0..(G.GRID.WIDTH-1)]
    for yi in [0..(G.GRID.HEIGHT-1)]
      x = xi + GAME.Off_Set.x
      y = yi + GAME.Off_Set.y
      if PS.BeadColor(x-GAME.Off_Set.x,y-GAME.Off_Set.y) != GAME.Board.Data[x][y].color
        PS.BeadColor x-GAME.Off_Set.x,y-GAME.Off_Set.y,GAME.Board.Data[x][y].color
      if PS.BeadGlyph(x-GAME.Off_Set.x,y-GAME.Off_Set.y) != 0
        PS.BeadGlyph x-GAME.Off_Set.x,y-GAME.Off_Set.y,0
      if PS.BeadBorderWidth(x-GAME.Off_Set.x,y-GAME.Off_Set.y) != 0
        PS.BeadBorderWidth x-GAME.Off_Set.x,y-GAME.Off_Set.y,0
      if GAME.Board.Data[x][y].ocupied != 0
        if GAME.Board.Data[x][y].ocupied.player == 'world'
          if GAME.Board.Data[x][y].ocupied.color !=  PS.BeadColor(x-GAME.Off_Set.x,y-GAME.Off_Set.y)
            GAME.Board.Data[x][y].ocupied.draw()
        else
          GAME.Board.Data[x][y].ocupied.draw()

  if GAME.Board.Bullets.length > 0
    for b in GAME.Board.Bullets
      if GAME.Board.Data[b.x][b.y].ocupied == 0
        b.draw()
      else if GAME.Board.Data[b.x][b.y].ocupied.player == 'world'
        b.draw()

  if GAME.Board.Flashes.length > 0
    for f in GAME.Board.Flashes
      if f.life >= 0
        f.draw()
        f.move()

  if GAME.Board.Flashes.length > 0
    removed = 0
    for fi in [0..GAME.Board.Flashes.length]
      if (fi-removed) < GAME.Board.Flashes.length
        if GAME.Board.Flashes[fi-removed].life <= 0
          GAME.Board.Flashes.splice(fi-removed,1)
          removed += 1

  for x in [0..(G.GRID.WIDTH-1)]
    PS.BeadColor x,G.GRID.HEIGHT,0xffffff
    PS.BeadGlyphColor x,G.GRID.HEIGHT,0x000000
    PS.BeadGlyph x,G.GRID.HEIGHT, 0

  PS.BeadGlyph 1,G.GRID.HEIGHT,'$'
  c = Math.min(99,GAME.Player.Credits)
  PS.BeadGlyph 2,G.GRID.HEIGHT, String(Math.floor((c) / 10))
  PS.BeadGlyph 3,G.GRID.HEIGHT, String(Math.floor((c - Math.floor((c) / 10))))
  dec = ['.','⅛','¼','⅜','½','⅝','¾','⅞']
  PS.BeadGlyph 4,G.GRID.HEIGHT, dec[Math.floor((c - Math.floor((c - Math.floor((c) / 10)))) * 8)]

  PS.BeadGlyph 0,G.GRID.HEIGHT,'■'
  PS.BeadData 0,G.GRID.HEIGHT, (xx,yy) ->
    PS.Clock 0
    for x in [0..(G.GRID.WIDTH-1)]
      for y in [0..(G.GRID.HEIGHT)]
        c = Math.floor(Math.random()*100)+50
        PS.BeadColor x,y,c,c,c
        PS.BeadBorderWidth x,y,0
        PS.BeadGlyph x,y,0
        PS.BeadData x,y,0
    t = 'Paused'
    x = Math.floor((G.GRID.WIDTH - t.length) / 2)
    for ti in t
      PS.BeadColor x,4,0xffffff
      PS.BeadGlyphColor x,4,0x000000
      PS.BeadGlyph x,4,ti
      x += 1
    t = 'Resume'
    x = Math.floor((G.GRID.WIDTH - t.length) / 2)
    for ti in t
      PS.BeadColor x,6,0xffffff
      PS.BeadGlyphColor x,6,0x000000
      PS.BeadGlyph x,6,ti
      PS.BeadData x,6, (x,y) ->
        PS.Clock 1
      x += 1
    t = 'Quit'
    x = Math.floor((G.GRID.WIDTH - t.length) / 2)
    for ti in t
      PS.BeadColor x,8,0xffffff
      PS.BeadGlyphColor x,8,0x000000
      PS.BeadGlyph x,8,ti
      PS.BeadData x,8, (x,y) ->
        G.Mode = 'home'
        PS.Init()
      x += 1





  PS.BeadGlyph G.GRID.WIDTH-5,G.GRID.HEIGHT, '1'
  PS.BeadGlyph G.GRID.WIDTH-4,G.GRID.HEIGHT, '⚒'
  PS.BeadData G.GRID.WIDTH-4,G.GRID.HEIGHT, (x,y) ->
    deselect()
    GAME.Player.Hover = new unit(x+GAME.Off_Set.x,y+GAME.Off_Set.y,'p','player')
    GAME.Player.Hover.hover = true
  PS.BeadGlyph G.GRID.WIDTH-2,G.GRID.HEIGHT, '1'
  PS.BeadGlyph G.GRID.WIDTH-1,G.GRID.HEIGHT, '♜'
  PS.BeadData G.GRID.WIDTH-1,G.GRID.HEIGHT, (x,y) ->
    deselect()
    GAME.Player.Hover = new unit(x+GAME.Off_Set.x,y+GAME.Off_Set.y,'d','player')
    GAME.Player.Hover.hover = true
  PS.BeadGlyph G.GRID.WIDTH-8,G.GRID.HEIGHT, '2'
  PS.BeadGlyph G.GRID.WIDTH-7,G.GRID.HEIGHT, '♞'
  PS.BeadData G.GRID.WIDTH-7,G.GRID.HEIGHT, (x,y) ->
    deselect()
    GAME.Player.Hover = new unit(x+GAME.Off_Set.x,y+GAME.Off_Set.y,'a','player')
    GAME.Player.Hover.hover = true

  if GAME.Player.Hover != 0
    GAME.Player.Hover.draw()
deselect = () ->
  GAME.Player.Selected  = 0
  GAME.Player.Hover = 0
  for x in [0..GAME.Board.Width]
    for y in [0..GAME.Board.Height]
      if GAME.Board.Data[x][y].ocupied != 0
        GAME.Board.Data[x][y].ocupied.selected = false
select= () ->
  for x in [GAME.Player.Selected.x..GAME.Player.Selected.w]
    for y in [GAME.Player.Selected.y..GAME.Player.Selected.h]
      if GAME.Board.Data[x][y].ocupied != 0 and GAME.Board.Data[x][y].ocupied.player == 'player'
        GAME.Board.Data[x][y].ocupied.selected = true
  GAME.Player.Selected  = 0

draw_home= () ->
  PS.BeadColor PS.ALL,PS.ALL, 0xffffff
  PS.BeadBorderWidth PS.ALL,PS.ALL,0
  PS.BeadGlyphColor PS.ALL,PS.ALL,0x000000
  PS.BeadGlyph PS.ALL,PS.ALL,0
  PS.BeadData PS.ALL,PS.ALL,0

  t = '♜ ASCii Wars ♜'
  x = Math.floor(((G.GRID.WIDTH - t.length)) / 2)
  for ti in t
    PS.BeadGlyph x,1, ti
    x += 1

  t = 'Tutorial'
  x = 3
  for ti in t
    PS.BeadGlyph x,3, ti
    x += 1

  PS.BeadBorderWidth 1,3,2
  PS.BeadBorderColor 1,3,0x000000
  PS.BeadData 1,3, (event) ->
    if event == 'enter'
      PS.BeadGlyph 1,3,'✔'
    else if event == 'leave'
      PS.BeadGlyph 1,3,' '
    else if event == 'click'
      G.Mode = 'tutorial'
      Settings.Board.Width = 15
      Settings.Board.Height = 14
      PS.Init()

  t = 'New GAME'
  x = 3
  for ti in t
    PS.BeadGlyph x,5, ti
    x += 1

  PS.BeadBorderWidth 1,5,2
  PS.BeadBorderColor 1,5,0x000000
  PS.BeadData 1,5, (event) ->
    if event == 'enter'
      PS.BeadGlyph 1,5,'✔'
    else if event == 'leave'
      PS.BeadGlyph 1,5,' '
    else if event == 'click'
      G.Mode = 'play'
      PS.Init()
  t = 'Bank'
  x = 3
  for ti in t
    PS.BeadGlyph x,6, ti
    x += 1
  PS.BeadBorderWidth x,6,2
  PS.BeadBorderColor x,6,0x000000
  PS.BeadGlyph x,6,'◀'
  PS.BeadData x,6, (event) ->
    if event == 'click'
      Settings.Player_Credits = Math.max(1,Settings.Player_Credits-1)
      draw_home()
  x += 1
  PS.BeadBorderWidth x,6,2
  PS.BeadBorderColor x,6,0x000000
  PS.BeadGlyph x,6,String(Settings.Player_Credits)
  x += 1
  PS.BeadBorderWidth x,6,2
  PS.BeadBorderColor x,6,0x000000
  PS.BeadGlyph x,6,'▶'
  PS.BeadData x,6, (event) ->
    if event == 'click'
      Settings.Player_Credits = Math.min(9,Settings.Player_Credits+1)
      draw_home()
  t = 'Dificulty'
  x = 3
  for ti in t
    PS.BeadGlyph x,7, ti
    x += 1
  PS.BeadBorderWidth x,7,2
  PS.BeadBorderColor x,7,0x000000
  PS.BeadGlyph x,7,'◀'
  PS.BeadData x,7, (event) ->
    if event == 'click'
      Settings.Comp_Credits = Math.max(0,Settings.Comp_Credits-1)
      draw_home()
  x += 1
  PS.BeadBorderWidth x,7,2
  PS.BeadBorderColor x,7,0x000000
  PS.BeadGlyph x,7,String(Settings.Comp_Credits)
  x += 1
  PS.BeadBorderWidth x,7,2
  PS.BeadBorderColor x,7,0x000000
  PS.BeadGlyph x,7,'▶'
  PS.BeadData x,7, (event) ->
    if event == 'click'
      Settings.Comp_Credits = Math.min(9,Settings.Comp_Credits+1)
      draw_home()
  t = 'AI-' + Settings.AI
  x = 2
  for ti in t
    PS.BeadGlyph x,8, ti
    x += 1
  PS.BeadBorderWidth x,8,2
  PS.BeadBorderColor x,8,0x000000
  PS.BeadGlyph x,8,'▶'
  PS.BeadData x,8, (event) ->
    if event == 'click'
      ais = ['Rabbit','Turtle','Wolf','Fish']
      i = ais.indexOf(Settings.AI)
      i = (i + 1) % ais.length
      Settings.AI = ais[i]
      draw_home()

  t = Settings.Map
  x = 2
  for ti in t
    PS.BeadGlyph x,9, ti
    x += 1
  PS.BeadBorderWidth x,9,2
  PS.BeadBorderColor x,9,0x000000
  PS.BeadGlyph x,9,'▶'
  PS.BeadData x,9, (event) ->
    if event == 'click'
      my_index = -1
      names = []
      for name of MAPS
        names.push(name)
        if Settings.Map == name
          my_index = names.length - 1
      i = (my_index+1) % names.length
      Settings.Map = names[i]
      draw_home()

  if Settings.Map == 'Custom'
    t = 'Width'
    x = 4
    for ti in t
      PS.BeadGlyph x,10, ti
      x += 1
    PS.BeadBorderWidth x,10,2
    PS.BeadBorderColor x,10,0x000000
    PS.BeadGlyph x,10,'◀'
    PS.BeadData x,10, (event) ->
      if event == 'click'
        Settings.Board.Width = Math.max(15,Settings.Board.Width - 1)
        draw_home()
    x += 1
    PS.BeadBorderWidth x,10,2
    PS.BeadBorderColor x,10,0x000000
    PS.BeadGlyph x,10,String(Math.floor(Settings.Board.Width / 10))
    x += 1
    PS.BeadBorderWidth x,10,2
    PS.BeadBorderColor x,10,0x000000
    PS.BeadGlyph x,10,String(Settings.Board.Width - 10*Math.floor(Settings.Board.Width / 10))
    x += 1
    PS.BeadBorderWidth x,10,2
    PS.BeadBorderColor x,10,0x000000
    PS.BeadGlyph x,10,'▶'
    PS.BeadData x,10, (event) ->
      if event == 'click'
        Settings.Board.Width = Math.min(99,Settings.Board.Width + 1)
        draw_home()

    t = 'Height'
    x = 4
    for ti in t
      PS.BeadGlyph x,11, ti
      x += 1
    PS.BeadBorderWidth x,11,2
    PS.BeadBorderColor x,11,0x000000
    PS.BeadGlyph x,11,'◀'
    PS.BeadData x,11, (event) ->
      if event == 'click'
        Settings.Board.Height = Math.max(14,Settings.Board.Height - 1)
        draw_home()
    x += 1
    PS.BeadBorderWidth x,11,2
    PS.BeadBorderColor x,11,0x000000
    PS.BeadGlyph x,11,String(Math.floor(Settings.Board.Height / 10))
    x += 1
    PS.BeadBorderWidth x,11,2
    PS.BeadBorderColor x,11,0x000000
    PS.BeadGlyph x,11,String(Settings.Board.Height - 10*Math.floor(Settings.Board.Height / 10))
    x += 1
    PS.BeadBorderWidth x,11,2
    PS.BeadBorderColor x,11,0x000000
    PS.BeadGlyph x,11,'▶'
    PS.BeadData x,11, (event) ->
      if event == 'click'
        Settings.Board.Height = Math.min(99,Settings.Board.Height + 1)
        draw_home()

    t = 'Mountains'
    x = 4
    for ti in t
      PS.BeadGlyph x,12, ti
      x += 1
    PS.BeadBorderWidth 3,12,2
    PS.BeadBorderColor 3,12,0x000000
    PS.BeadGlyph 3,12,'✔' if Settings.Board.Mountains
    PS.BeadData 3,12, (event) ->
      if event == 'enter'
        PS.BeadGlyph 3,12,'✔'
      else if event == 'leave'
        PS.BeadGlyph 3,12,' '
        PS.BeadGlyph 3,12,'✔' if Settings.Board.Mountains
      else if event == 'click'
        if Settings.Board.Mountains
          Settings.Board.Mountains = false
        else
          Settings.Board.Mountains = true
        PS.BeadGlyph 3,12,' '
        PS.BeadGlyph 3,12,'✔' if Settings.Board.Mountains
    t = 'Lakes'
    x = 4
    for ti in t
      PS.BeadGlyph x,13 , ti
      x += 1
    PS.BeadBorderWidth 3,13,2
    PS.BeadBorderColor 3,13,0x000000
    PS.BeadGlyph 3,13,'✔' if Settings.Board.Lakes
    PS.BeadData 3,13, (event) ->
      if event == 'enter'
        PS.BeadGlyph 3,13,'✔'
      else if event == 'leave'
        PS.BeadGlyph 3,13,' '
        PS.BeadGlyph 3,13,'✔' if Settings.Board.Lakes
      else if event == 'click'
        if Settings.Board.Lakes
          Settings.Board.Lakes = false
        else
          Settings.Board.Lakes = true
        PS.BeadGlyph 3,13,' '
        PS.BeadGlyph 3,13,'✔' if Settings.Board.Lakes


reset = () ->
  TUT.current_step = 0
  TUT.current_tip = 0
  PS.StatusText TUT.tips[TUT.current_step].tip[TUT.current_tip]
  TUT.current_tip = 1

  GAME.Off_Set.x = 0
  GAME.Off_Set.y = 0

  GAME.Board.Width = Settings.Board.Width
  GAME.Board.Height = Settings.Board.Height
  GAME.Board.Data = []
  GAME.Board.Bullets = []
  GAME.Board.Flashes = []
  GAME.Board.Shifting.x = 0
  GAME.Board.Shifting.y = 0

  GAME.Player.Credits = Settings.Player_Credits
  GAME.Player.Credits = 12 if G.Mode == 'tutorial'
  GAME.Player.Hover = 0
  GAME.Player.Selected = 0
  GAME.Player.Last.x = 0
  GAME.Player.Last.y = 0

  GAME.Comp.Credits = Settings.Comp_Credits + Settings.Player_Credits
  GAME.Comp.AI = new AI()

  G.Tick = 0

debug = (response) ->
  property_names = ""
  for propertyName of response
    ### propertyName is what you want###
    property_names += propertyName + " = " + response[propertyName] + "\n"
  alert property_names
###------------------------------------------ Global Vars ----------------------------------------- ###

G =
  Sound: true
  GRID:
    WIDTH: 16
    HEIGHT: 15
  COLORS:
    UNIT:
      HOVER_GOOD: 0x00ff00
      HOVER_BAD: 0xff0000
      HOVER_OK: 0xffff00
      SELECTED: 0xffff00
      PLAYER: 0x0000ff
      COMP: 0xff0000
    BATTLE_GROUND:
      BG: ([0x557F50,0x8A661E,0x41700F])
    FLASH:
      DIE: ([0x770000,0xa30000,0xff6800,0xfd9f09,0xb50700])
      SHOOT: {r: 255,g: 255,b: 255}
    NATURE:
      ROCK: ([0x959387,0xbdb5aa,0xf2efeb,0x68635f,0x8d8a83])
      WATER: ([0xb0daff,0x325b7f,0x64b7ff,0x586d7f,0x5092cc])

  SOUNDS:
    PLACE_BUILDING: 'fx_gun'
    SHOOT: 'fx_bang'
    DIE: 'fx_bomb1'
  Scroll_speed: 1
  BALANCE:
    BULLET:
      LIFE: 3
      SUCCESS_RATE: 0.5
    PRODUCTION_RATE: 0.01
    SHOOTING_FEQ: 15
    FLASH:
      DIE: 5
      SHOOT: 2
  Tick: 0
  Mode: 'home'
TUT =
  current_step: 0
  current_tip: 0
  tips: [{tip: ['The bar at the bottom shows main game controls.','$ are used to build units.','⚒ units produce income.','To build one click on the icon, then in the field.','Units can only be built adjacent to stationary allies.'],done: false},
          {tip: ['♜ units are defensive and can not move.','Build one now.'],done: false},
          {tip: ['♞ units are offensive and can move.','Build one now.'], done: false},
          {tip: ['To select a ♞ click on it.','Then to move it, click another square.'], done: false}
          {tip: ['Now that we know the basics, defeat red.','To build faster use the hotkeys: a->♞, s->⚒, d->♜','Click and drag to select multiple units.'], done: false}
        ]
Settings =
  Board:
    Width: 15
    Height: 14
    Mountains: false
    Lakes: false
  Player_Credits: 4
  Comp_Credits: 2
  AI: 'Fish'
  Map: 'Great_Lake'
GAME =
  Off_Set:
    x: 0
    y: 0
  Board:
    Width: 15
    Height: 14
    Data: []
    Bullets: []
    Flashes: []
    Shifting:
      x: 0
      y: 0
  Player:
    Credits: 12
    Hover: 0
    Selected: 0
    Last: {x: 0,y: 0}
  Comp:
    Credits: 4
    AI: new AI()
r = -2
b = -1
MAPS =
  Custom: 0
  Great_Lake: #name of level (_ instead of Space) limit 10 characters
    w: 15 #needs to be one less than actual  (or start cound at 0)
    h: 14
    data: [  #1 => water,2 => rock, 0 => grass, b => blue start, r => red start red gets a D up and to the left one
      ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,b,0,0,0,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,1,1,0,0,1,1,0,0,0,0]),
      ([0,0,0,0,0,1,1,1,1,1,1,1,0,0,0,0]),
      ([0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0]),
      ([0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0]),
      ([0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0]),
      ([0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,1,1,1,0,0,0,0,0,r,0,0,0]),
      ([0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0])
    ]
  Twin_Peaks: #name of level (_ instead of Space) limit 10 characters
    w: 15 #needs to be one less than actual  (or start cound at 0)
    h: 14
    data: [  #1 => water,2 => rock, 0 => grass, b => blue start, r => red start red gets a D up and to the left one
      ([0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,2,2,0,0,0,0,0,0,0]),
      ([0,0,b,0,0,0,2,2,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,2,2,2,2,0,0,0,0,0,0,0]),
      ([0,0,0,0,2,2,2,2,2,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,2,2,2,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,2,2,2,2,2,0,0,0,0]),
      ([0,0,0,0,0,0,2,2,2,2,2,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,2,2,2,2,0,0,r,0,0]),
      ([0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0])
    ]

  The_Island: #name of level (_ instead of Space) limit 10 characters
    w: 15 #needs to be one less than actual  (or start cound at 0)
    h: 14
    data: [  #1 => water,2 => rock, 0 => grass, b => blue start, r => red start red gets a D up and to the left one
      ([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]),
      ([1,1,1,1,1,0,0,1,1,0,0,0,1,1,1,1]),
      ([1,1,1,0,0,0,0,1,1,0,0,0,0,0,0,1]),
      ([1,1,0,0,0,0,0,0,1,0,0,0,0,1,1,1]),
      ([1,1,0,0,b,0,0,0,0,0,0,0,0,1,0,1]),
      ([1,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1]),
      ([1,0,0,0,0,0,0,0,2,0,0,0,0,0,1,1]),
      ([1,1,0,0,0,0,0,0,2,2,0,0,0,0,0,1]),
      ([1,1,1,0,0,0,0,2,2,0,0,0,0,0,0,1]),
      ([1,1,1,0,0,0,2,2,0,0,0,0,0,0,0,1]),
      ([1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,1]),
      ([1,1,1,1,1,0,0,0,0,0,0,r,0,0,1,1]),
      ([1,1,1,1,1,1,0,0,0,0,0,0,0,1,1,1]),
      ([1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1]),
      ([1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1])
    ]

  Island_Chain:
    w: 15
    h: 14
    data: [
      ([b,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1]),
      ([0,0,0,1,1,1,1,1,1,1,0,0,2,2,1,1]),
      ([0,0,1,1,1,1,0,0,0,0,0,0,0,2,2,1]),
      ([0,1,1,1,0,0,0,1,1,1,0,0,0,0,2,1]),
      ([0,1,1,0,0,0,0,0,1,1,1,0,0,2,1,1]),
      ([0,0,1,0,0,0,0,1,1,1,1,1,0,1,1,1]),
      ([0,0,0,0,0,0,1,1,1,1,1,1,0,1,1,1]),
      ([0,0,1,1,1,1,1,1,1,1,2,0,0,0,1,1]),
      ([1,1,1,1,1,0,0,0,2,2,2,0,0,0,0,1]),
      ([1,1,1,1,0,0,0,0,0,2,0,0,0,0,0,1]),
      ([0,0,0,1,1,1,1,0,0,0,0,0,0,0,1,1]),
      ([0,0,0,0,1,1,1,1,1,0,0,1,1,1,1,1]),
      ([0,0,0,0,1,1,1,1,1,0,1,1,1,1,1,1]),
      ([0,0,0,0,0,1,1,1,0,0,0,1,1,1,1,1]),
      ([0,r,0,0,0,0,0,0,0,0,1,1,1,1,1,1])
    ]

  Battlefield:
    w:15
    h:14
    data: [
      ([b,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,1,1,1,1,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,1,1,1,1,0,0,0,0,0,0,1,0,1]),
      ([0,1,1,1,1,1,0,0,0,0,0,2,1,1,0,0]),
      ([0,0,1,1,1,1,0,0,0,0,2,2,1,0,0,0]),
      ([0,0,1,1,0,0,0,0,0,0,0,1,1,0,0,0]),
      ([0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0]),
      ([0,0,0,0,0,0,1,1,1,1,1,0,0,0,0,0]),
      ([0,0,0,1,1,1,1,2,2,0,0,0,0,0,0,0]),
      ([1,0,1,1,0,0,2,2,0,0,2,2,2,2,0,0]),
      ([0,0,0,0,0,0,0,0,0,0,2,1,1,1,1,0]),
      ([0,0,0,0,0,0,0,0,0,2,2,1,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,0,2,2,1,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,2,2,2,1,0,0,0,r])
    ]

  Last_Stand:
    w:15
    h:14
    data: [
      ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]),
      ([0,r,0,0,0,0,0,0,0,0,0,0,0,0,r,0]),
      ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,2,0,0,0,2,0,0,0,0]),
      ([0,0,0,0,0,2,2,2,2,2,0,2,2,0,0,0]),
      ([0,0,0,0,2,2,0,0,0,2,0,0,0,0,0,0]),
      ([0,0,2,0,2,0,0,b,0,0,0,2,0,0,0,0]),
      ([0,0,2,0,0,0,b,2,b,0,2,2,0,0,0,0]),
      ([0,0,2,2,0,0,0,b,0,0,2,0,0,0,0,0]),
      ([0,0,0,2,0,0,0,0,0,2,2,0,0,0,0,0]),
      ([0,0,0,2,2,0,0,0,2,2,0,0,0,0,0,0]),
      ([0,0,0,0,2,2,0,0,0,0,0,0,0,0,0,0]),
      ([0,0,0,0,0,0,0,0,2,2,0,0,0,0,0,0]),
      ([0,r,0,0,0,0,2,2,2,0,0,0,0,0,r,0]),
      ([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]),
    ]

###------------------------------------------ PS Events ----------------------------------------- ###
PS.Init = ->
  PS.GridSize G.GRID.WIDTH, G.GRID.HEIGHT+1
  PS.BeadFlash PS.ALL,PS.ALL,false
  PS.StatusFade false
  PS.StatusText 'ASCii Wars'

  if G.Mode == 'home'
    PS.Clock(0)
    draw_home()
  else
    reset()
    PS.StatusText 'ASCii Wars' if G.Mode != 'tutorial'
    build_blank_board()
    PS.Clock(1)

PS.Click = (x, y, data) ->
  "use strict"
  if typeof data == "function"
    PS.AudioPlay 'fx_click'
    if G.Mode == 'home'
      data('click',x,y)
    else
      data(x,y)
  else if GAME.Player.Hover != 0
    if y <= G.GRID.HEIGHT - 1
      if GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y].ocupied == 0
        test_a = GAME.Player.Hover.x - 1 >= 0 and GAME.Board.Data[GAME.Player.Hover.x - 1][GAME.Player.Hover.y].ocupied != 0 and GAME.Board.Data[GAME.Player.Hover.x - 1][GAME.Player.Hover.y].ocupied.player == 'player' and GAME.Board.Data[GAME.Player.Hover.x - 1][GAME.Player.Hover.y].ocupied.kind != 'a'
        test_b = GAME.Player.Hover.x+1 <= GAME.Board.Width and GAME.Board.Data[GAME.Player.Hover.x + 1][GAME.Player.Hover.y].ocupied != 0  and GAME.Board.Data[GAME.Player.Hover.x + 1][GAME.Player.Hover.y].ocupied.player == 'player' and GAME.Board.Data[GAME.Player.Hover.x + 1][GAME.Player.Hover.y].ocupied.kind != 'a'
        test_c = GAME.Player.Hover.y - 1 >= 0 and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y - 1].ocupied != 0  and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y - 1].ocupied.player == 'player' and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y - 1].ocupied.kind != 'a'
        test_d = GAME.Player.Hover.y+1 <= GAME.Board.Height and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y + 1].ocupied != 0 and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y + 1].ocupied.player == 'player' and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y + 1].ocupied.kind != 'a'
        if GAME.Player.Hover.kind != 'a'
          test_a = GAME.Player.Hover.x - 1 >= 0 and GAME.Board.Data[GAME.Player.Hover.x - 1][GAME.Player.Hover.y].ocupied != 0 and GAME.Board.Data[GAME.Player.Hover.x - 1][GAME.Player.Hover.y].ocupied.player == 'player'
          test_b = GAME.Player.Hover.x+1 <= GAME.Board.Width and GAME.Board.Data[GAME.Player.Hover.x + 1][GAME.Player.Hover.y].ocupied != 0  and GAME.Board.Data[GAME.Player.Hover.x + 1][GAME.Player.Hover.y].ocupied.player == 'player'
          test_c = GAME.Player.Hover.y - 1 >= 0 and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y - 1].ocupied != 0  and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y - 1].ocupied.player == 'player'
          test_d = GAME.Player.Hover.y+1 <= GAME.Board.Height and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y + 1].ocupied != 0 and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y + 1].ocupied.player == 'player'
        if test_a or test_b or test_c or test_d
          if (GAME.Player.Credits >= 1 and GAME.Player.Hover.kind != 'a') or GAME.Player.Credits >= 2
            GAME.Player.Credits -= 1
            GAME.Player.Credits -= 1 if GAME.Player.Hover.kind == 'a'

            GAME.Player.Hover.hover = false
            GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y].ocupied = GAME.Player.Hover
            PS.AudioPlay G.SOUNDS.PLACE_BUILDING
            if G.Mode == 'tutorial'
              if TUT.current_step == 0 and GAME.Player.Hover.kind == 'p'
                TUT.current_step = 1
                TUT.current_tip = 0
              else if TUT.current_step == 1 and GAME.Player.Hover.kind == 'd'
                TUT.current_step = 2
                TUT.current_tip = 0
              else if TUT.current_step == 2 and GAME.Player.Hover.kind == 'a'
                TUT.current_step = 3
                TUT.current_tip = 0
            GAME.Player.Hover = 0

    else
      GAME.Player.Hover = 0
  else if y <= G.GRID.HEIGHT - 1
    if GAME.Player.Selected  == 0
      GAME.Player.Selected = {x: x + GAME.Off_Set.x, y: y + GAME.Off_Set.y,w: x + GAME.Off_Set.x, h: y + GAME.Off_Set.y}
    else
      GAME.Player.Selected.w = x + GAME.Off_Set.x
      GAME.Player.Selected.h = y + GAME.Off_Set.y


PS.Release = (x, y, data) ->
  "use strict"
  if G.Mode != 'home'
    if GAME.Player.Selected  != 0
      if GAME.Player.Selected.x == GAME.Player.Selected.w and GAME.Player.Selected.y == GAME.Player.Selected.h
        moved = 0
        for x in [0..GAME.Board.Width]
          for y in [0..GAME.Board.Height]
            if GAME.Board.Data[x][y].ocupied != 0 and GAME.Board.Data[x][y].ocupied.player == 'player' and GAME.Board.Data[x][y].ocupied.selected
              GAME.Board.Data[x][y].ocupied.dest = {x: GAME.Player.Selected.x,y: GAME.Player.Selected.y}
              moved += 1
        if moved > 0
          deselect()
        else
          select()
      else
        select()

PS.Enter = (xx, yy, data) ->
  "use strict"
  if typeof data == "function"
    if G.Mode == 'home'
      data('enter',xx,yy)
  GAME.Player.Last.x = xx
  GAME.Player.Last.y = yy

  if GAME.Player.Selected != 0
    GAME.Player.Selected.w = xx + GAME.Off_Set.x
    GAME.Player.Selected.h = yy + GAME.Off_Set.y

  if GAME.Player.Hover != 0
    GAME.Player.Hover.x = xx + GAME.Off_Set.x
    GAME.Player.Hover.y = yy + GAME.Off_Set.y
    GAME.Player.Hover.dest.x = GAME.Player.Hover.x
    GAME.Player.Hover.dest.y = GAME.Player.Hover.y
  if xx == 0
    GAME.Board.Shifting.x = -1
    if yy == 0
      GAME.Board.Shifting.y = -1
    else if yy == G.GRID.HEIGHT - 1
      GAME.Board.Shifting.y = 1
    else
      GAME.Board.Shifting.y = 0
  else if xx == G.GRID.WIDTH - 1
    GAME.Board.Shifting.x = 1
    if yy == 0
      GAME.Board.Shifting.y = -1
    else if yy == G.GRID.HEIGHT - 1
      GAME.Board.Shifting.y = 1
    else
      GAME.Board.Shifting.y = 0
  else
    GAME.Board.Shifting.x = 0
    if yy == 0
      GAME.Board.Shifting.y = -1
    else if yy == G.GRID.HEIGHT - 1
      GAME.Board.Shifting.y = 1
    else
      GAME.Board.Shifting.y = 0


PS.Leave = (x, y, data) ->
  "use strict"
  if typeof data == "function"
    if G.Mode == 'home'
      data('leave',x,y)

PS.KeyDown = (key, shift, ctrl) ->
  "use strict"
  if key == 27
    deselect()
  else if key == 68
    PS.Click G.GRID.WIDTH-1,G.GRID.HEIGHT,PS.BeadData G.GRID.WIDTH-1,G.GRID.HEIGHT
    PS.Enter GAME.Player.Last.x,GAME.Player.Last.y
  else if key == 65
    PS.Click G.GRID.WIDTH-7,G.GRID.HEIGHT,PS.BeadData G.GRID.WIDTH-7,G.GRID.HEIGHT
    PS.Enter GAME.Player.Last.x,GAME.Player.Last.y
  else if key == 83
    PS.Click G.GRID.WIDTH-4,G.GRID.HEIGHT,PS.BeadData G.GRID.WIDTH-4,G.GRID.HEIGHT
    PS.Enter GAME.Player.Last.x,GAME.Player.Last.y



PS.KeyUp = (key, shift, ctrl) ->
  "use strict"

PS.Wheel = (dir) ->
  "use strict"

PS.Tick = ->
  "use strict"
  ###every hour reset clock ###
  G.Tick += 1
  G.Tick = 0 if G.Tick >= 216000
  if G.Tick % G.Scroll_speed == 0
    GAME.Off_Set.x = Math.max(0,Math.min(GAME.Board.Width-G.GRID.WIDTH+1,GAME.Off_Set.x + GAME.Board.Shifting.x))
    GAME.Off_Set.y = Math.max(0,Math.min(GAME.Board.Height-G.GRID.HEIGHT+1,GAME.Off_Set.y + GAME.Board.Shifting.y))
  draw_game()
  if G.Tick % 15 == 0
    move_game()
  if GAME.Player.Selected != 0
    for x in [GAME.Player.Selected.x..GAME.Player.Selected.w]
      for y in [GAME.Player.Selected.y..GAME.Player.Selected.h]
        if x-GAME.Off_Set.x >= 0 and x-GAME.Off_Set.x < G.GRID.WIDTH
          if y-GAME.Off_Set.y >= 0 and y-GAME.Off_Set.y < G.GRID.HEIGHT
            PS.BeadBorderColor x-GAME.Off_Set.x,y-GAME.Off_Set.y,0x00ffff
            PS.BeadBorderWidth x-GAME.Off_Set.x,y-GAME.Off_Set.y,2
  GAME.Comp.AI.think() if G.Mode == 'play'

  if G.Mode == 'tutorial'
    if G.Tick % 180 == 0
      PS.StatusText TUT.tips[TUT.current_step].tip[TUT.current_tip]
      TUT.current_tip = (TUT.current_tip+1)% TUT.tips[TUT.current_step].tip.length



### END OF GAME CODE ###