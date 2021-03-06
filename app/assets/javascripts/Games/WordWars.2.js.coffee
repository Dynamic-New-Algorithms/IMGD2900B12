### oppen to puplic use ###
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
    if @x - GAME.Off_Set.x >= 0 and  @x - GAME.Off_Set.x < G.GRID.WIDTH and @y - GAME.Off_Set.y >= 0 and  @y - GAME.Off_Set.y < G.GRID.HEIGHT

      x = @x - GAME.Off_Set.x
      y = @y - GAME.Off_Set.y

      test_a = @x - 1 >= 0 and GAME.Board.Data[@x - 1][@y].ocupied != 0 and GAME.Board.Data[@x - 1][@y].ocupied.player == 'player' and GAME.Board.Data[@x - 1][@y].ocupied.kind != 'a'
      test_b = @x+1 <= GAME.Board.Width and GAME.Board.Data[@x + 1][@y].ocupied != 0  and GAME.Board.Data[@x + 1][@y].ocupied.player == 'player' and GAME.Board.Data[@x + 1][@y].ocupied.kind != 'a'
      test_c = @y - 1 >= 0 and GAME.Board.Data[@x][@y - 1].ocupied != 0  and GAME.Board.Data[@x][@y - 1].ocupied.player == 'player' and GAME.Board.Data[@x][@y - 1].ocupied.kind != 'a'
      test_d = @y+1 <= GAME.Board.Height and GAME.Board.Data[@x][@y + 1].ocupied != 0 and GAME.Board.Data[@x][@y + 1].ocupied.player == 'player' and GAME.Board.Data[@x][@y + 1].ocupied.kind != 'a'

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
  shoot: () ->
    if @last_shot + G.BALANCE.SHOOTING_FEQ < G.Tick or G.Tick < @last_shot
      for y in [0..G.BALANCE.BULLET.LIFE]
        break if @y+y > GAME.Board.Height
        if GAME.Board.Data[@x][@y+y].ocupied != 0 and GAME.Board.Data[@x][@y+y].ocupied.player != @player
          GAME.Board.Bullets.push(new bullet(@x,@y,0,1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          return true

      for y in [0..G.BALANCE.BULLET.LIFE]
        break if @y-y < 0
        if GAME.Board.Data[@x][@y-y].ocupied != 0 and GAME.Board.Data[@x][@y-y].ocupied.player != @player
          GAME.Board.Bullets.push(new bullet(@x,@y,0,-1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if @x-x < 0
        if GAME.Board.Data[@x-x][@y].ocupied != 0 and GAME.Board.Data[@x-x][@y].ocupied.player != @player
          GAME.Board.Bullets.push(new bullet(@x,@y,-1,0,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if @x+x > GAME.Board.Width
        if GAME.Board.Data[@x+x][@y].ocupied != 0 and GAME.Board.Data[@x+x][@y].ocupied.player != @player
          GAME.Board.Bullets.push(new bullet(@x,@y,1,0,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if @x+x > GAME.Board.Width or @y+x > GAME.Board.Height
        if GAME.Board.Data[@x+x][@y+x].ocupied != 0 and GAME.Board.Data[@x+x][@y+x].ocupied.player != @player
          GAME.Board.Bullets.push(new bullet(@x,@y,1,1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if @x-x < 0 or @y-x < 0
        if GAME.Board.Data[@x-x][@y-x].ocupied != 0 and GAME.Board.Data[@x-x][@y-x].ocupied.player != @player
          GAME.Board.Bullets.push(new bullet(@x,@y,-1,-1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if @x-x <0  or @y+x > GAME.Board.Height
        if GAME.Board.Data[@x-x][@y+x].ocupied != 0 and GAME.Board.Data[@x-x][@y+x].ocupied.player != @player
          GAME.Board.Bullets.push(new bullet(@x,@y,-1,1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
          return true
      for x in [0..G.BALANCE.BULLET.LIFE]
        break if @x+x > GAME.Board.Width or @y-x < 0
        if GAME.Board.Data[@x+x][@y-x].ocupied != 0 and GAME.Board.Data[@x+x][@y-x].ocupied.player != @player
          GAME.Board.Bullets.push(new bullet(@x,@y,1,-1,@player))
          @last_shot = G.Tick
          PS.AudioPlay G.SOUNDS.SHOOT
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
          north = Math.abs(@dest.x - x) + Math.abs(@dest.y - (y-1)) + m + 1 if y-1 > 0 and (GAME.Board.Data[x][y-1].ocupied == 0)# or GAME.Board.Data[x][y-1].ocupied.player != @player)
          south = Math.abs(@dest.x - x) + Math.abs(@dest.y - (y+1)) + m + 1 if y+1 < GAME.Board.Height and (GAME.Board.Data[x][y+1].ocupied == 0)# or GAME.Board.Data[x][y+1].ocupied.player != @player)
          east = Math.abs(@dest.x - (x+1)) + Math.abs(@dest.y - y) + m + 1 if x+1 < GAME.Board.Width and (GAME.Board.Data[x+1][y].ocupied == 0)# or GAME.Board.Data[x+1][y].ocupied.player != @player)
          west = Math.abs(@dest.x - (x-1)) + Math.abs(@dest.y - y) + m + 1 if x-1 > 0 and (GAME.Board.Data[x-1][y].ocupied == 0)# or GAME.Board.Data[x-1][y].ocupied.player != @player)
          nort = m+1 if y-1 == @dest.y and x == @dest.x
          south = m+1 if y+1 == @dest.y and x == @sext.x
          east = m+1 if y == @dest.y and x+1 == @dest.x
          west = m+1 if y == @dest.y and x-1 == @dest.x
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
            if @x < @dest.x and GAME.Board.Data[@x+1][@y].ocupied == 0
              options.push(String((@x+1)+','+@y))
            if @x > @dest.x and GAME.Board.Data[@x-1][@y].ocupied == 0
              options.push(String((@x-1)+','+@y))
            if @y > @dest.y and GAME.Board.Data[@x][@y-1].ocupied == 0
              options.push(String((@x)+','+(@y-1)))
            if @y < @dest.y and GAME.Board.Data[@x][@y+1].ocupied == 0
              options.push(String((@x)+','+(@y+1)))
            return false if options.length == 0
            lowest = options[Math.floor(Math.random()*options.length)]
            break
          lowest = options[Math.floor(Math.random()*options.length)]
        move = apple[lowest].history[0]
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
          GAME.Player.Selected = {x: @x,y: @y} if @selected


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
    if @x + @vx >=0 and @x + @vx < GAME.Board.Width and @y + @vy >=0 and @y + @vy < GAME.Board.Height
      @x += @vx
      @y += @vy
      return GAME.Board.Data[@x][@y].ocupied != 0
    else
      return true

class AI
  constructor: () ->
    p = Math.random()
    d = (Math.random()*(1-p))
    a = 1 - p - d
    @next_build = {p: p,d: d,a: a}
    @attack_feq = Math.floor(Math.random()*18000)

  think: () ->
    force_attack = false
    if GAME.Comp.Credits >= 3
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
        nb = 'p'
        nb = 'a' if their_p / (their_a+their_d+their_p) > @next_build.p
        nb = 'd' if their_a / (their_a+their_d+their_p) > @next_build.a
        nb = 'p' if my_p <= 5
        GAME.Comp.Credits -= 1
        GAME.Comp.Credits -= 1 if nb == 'a'
        loc = options[Math.floor(Math.random()*options.length)]
        nb = new unit(loc.x,loc.y,nb,'comp')
        nb.dest.x = loc.x
        nb.dest.y = loc.y
        GAME.Board.Data[nb.x][nb.y].ocupied = nb
        force_attack = true if my_a / (my_a+my_d+my_p) > @next_build.a
    if G.Tick % @attack_feq == 0 or force_attack
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
      for a in my_a
        d = move_op[Math.floor(Math.random()*(move_op.length))]
        GAME.Board.Data[a.x][a.y].ocupied.dest.x = d.x
        GAME.Board.Data[a.x][a.y].ocupied.dest.y = d.y







###------------------------------------------ Helper functions ----------------------------------------- ###
build_blank_board = () ->
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
  GAME.Board.Data[4][4].ocupied = new unit(4,4,'p','player')
  GAME.Board.Data[GAME.Board.Width-5][GAME.Board.Height-5].ocupied = new unit(GAME.Board.Width-5,GAME.Board.Height-5,'p','comp')
  GAME.Board.Data[GAME.Board.Width-6][GAME.Board.Height-5].ocupied = new unit(GAME.Board.Width-6,GAME.Board.Height-5,'d','comp')

move_game= () ->
  player_unit_count = 0
  comp_unit_count = 0
  for x in [0..GAME.Board.Width]
    for y in [0..GAME.Board.Height]
      if GAME.Board.Data[x][y].ocupied != 0
        GAME.Board.Data[x][y].ocupied.move() if GAME.Board.Data[x][y].ocupied.has_moved == false
        player_unit_count += 1 if GAME.Board.Data[x][y].ocupied.player == 'player'
        comp_unit_count += 1 if GAME.Board.Data[x][y].ocupied.player == 'comp'

  if player_unit_count == 0
    PS.Clock 0
    alert 'Loser'
    window.location.reload()
  if comp_unit_count == 0
    PS.Clock 0
    alert 'Winner'
    window.location.reload()
  if GAME.Board.Bullets.length > 0
    for bi in [0..GAME.Board.Bullets.length-1]
      b = GAME.Board.Bullets[bi]
      if b.has_moved == false
        hit = b.move()
        if hit
          if GAME.Board.Data[b.x][b.y].ocupied != 0
            if GAME.Board.Data[b.x][b.y].ocupied.player != b.player
              if Math.random() <= G.BALANCE.BULLET.SUCCESS_RATE
                GAME.Board.Data[b.x][b.y].ocupied = 0
                PS.AudioPlay G.SOUNDS.DIE
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
  for x in [GAME.Off_Set.x..(GAME.Off_Set.x+G.GRID.WIDTH-1)]
    for y in [GAME.Off_Set.y..(GAME.Off_Set.y+G.GRID.HEIGHT-1)]
      PS.BeadColor x-GAME.Off_Set.x,y-GAME.Off_Set.y,GAME.Board.Data[x][y].color
      PS.BeadGlyph x-GAME.Off_Set.x,y-GAME.Off_Set.y,0
      PS.BeadBorderWidth x-GAME.Off_Set.x,y-GAME.Off_Set.y,0
      if GAME.Board.Data[x][y].ocupied != 0
        GAME.Board.Data[x][y].ocupied.draw()

  if GAME.Board.Bullets.length > 0
    for b in GAME.Board.Bullets
      if GAME.Board.Data[b.x][b.y].ocupied == 0
        b.draw()

  if GAME.Player.Hover != 0
    GAME.Player.Hover.draw()
  for x in [0..(G.GRID.WIDTH-1)]
    PS.BeadColor x,G.GRID.HEIGHT,0xffffff
    PS.BeadGlyphColor x,G.GRID.HEIGHT,0x000000

  PS.BeadGlyph 0,G.GRID.HEIGHT,'$'
  c = GAME.Player.Credits
  PS.BeadGlyph 1,G.GRID.HEIGHT, String(Math.floor(c/100))
  PS.BeadGlyph 2,G.GRID.HEIGHT, String(Math.floor((c - Math.floor(c/100)*100) / 10))
  PS.BeadGlyph 3,G.GRID.HEIGHT, String(Math.floor(c) - (Math.floor((c - Math.floor(c/100)*100) / 10))*10 - Math.floor(c/100)*100)

  PS.BeadGlyph G.GRID.WIDTH-8,G.GRID.HEIGHT, '1'
  PS.BeadGlyph G.GRID.WIDTH-7,G.GRID.HEIGHT, '⚒'
  PS.BeadData G.GRID.WIDTH-7,G.GRID.HEIGHT, (x,y) ->
    deselect()
    GAME.Player.Hover = new unit(x+GAME.Off_Set.x,y+GAME.Off_Set.y,'p','player')
    GAME.Player.Hover.hover = true
  PS.BeadGlyph G.GRID.WIDTH-5,G.GRID.HEIGHT, '1'
  PS.BeadGlyph G.GRID.WIDTH-4,G.GRID.HEIGHT, '♜'
  PS.BeadData G.GRID.WIDTH-4,G.GRID.HEIGHT, (x,y) ->
    deselect()
    GAME.Player.Hover = new unit(x+GAME.Off_Set.x,y+GAME.Off_Set.y,'d','player')
    GAME.Player.Hover.hover = true
  PS.BeadGlyph G.GRID.WIDTH-2,G.GRID.HEIGHT, '2'
  PS.BeadGlyph G.GRID.WIDTH-1,G.GRID.HEIGHT, '♞'
  PS.BeadData G.GRID.WIDTH-1,G.GRID.HEIGHT, (x,y) ->
    deselect()
    GAME.Player.Hover = new unit(x+GAME.Off_Set.x,y+GAME.Off_Set.y,'a','player')
    GAME.Player.Hover.hover = true

deselect = () ->
  GAME.Player.Selected  = 0
  GAME.Player.Hover = 0
  for x in [GAME.Off_Set.x..(GAME.Off_Set.x+G.GRID.WIDTH-1)]
    for y in [GAME.Off_Set.y..(GAME.Off_Set.y+G.GRID.HEIGHT-1)]
      if GAME.Board.Data[x][y].ocupied != 0
        GAME.Board.Data[x][y].ocupied.selected = false
select= () ->
  for x in [GAME.Player.Selected.x..GAME.Player.Selected.w]
    for y in [GAME.Player.Selected.y..GAME.Player.Selected.h]
      if GAME.Board.Data[x][y].ocupied != 0 and GAME.Board.Data[x][y].ocupied.player == 'player'
        GAME.Board.Data[x][y].ocupied.selected = true
  GAME.Player.Selected  = 0



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
  Tick: 0
  Mode: 'home'
GAME =
  Off_Set:
    x: 0
    y: 0
  Board:
    Width: 16
    Height: 15
    Data: []
    Bullets: []
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
###------------------------------------------ PS Events ----------------------------------------- ###
PS.Init = ->
  PS.GridSize G.GRID.WIDTH, G.GRID.HEIGHT+1
  PS.BeadFlash PS.ALL,PS.ALL,false
  PS.StatusText 'ASCii Wars'

  build_blank_board()
  PS.Clock(1)

PS.Click = (x, y, data) ->
  "use strict"
  if typeof data == "function"
    data(x,y)
  else if GAME.Player.Hover != 0
    if y <= G.GRID.HEIGHT - 1
      if GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y].ocupied == 0
        test_a = GAME.Player.Hover.x - 1 >= 0 and GAME.Board.Data[GAME.Player.Hover.x - 1][GAME.Player.Hover.y].ocupied != 0 and GAME.Board.Data[GAME.Player.Hover.x - 1][GAME.Player.Hover.y].ocupied.player == 'player' and GAME.Board.Data[GAME.Player.Hover.x - 1][GAME.Player.Hover.y].ocupied.kind != 'a'
        test_b = GAME.Player.Hover.x+1 <= GAME.Board.Width and GAME.Board.Data[GAME.Player.Hover.x + 1][GAME.Player.Hover.y].ocupied != 0  and GAME.Board.Data[GAME.Player.Hover.x + 1][GAME.Player.Hover.y].ocupied.player == 'player' and GAME.Board.Data[GAME.Player.Hover.x + 1][GAME.Player.Hover.y].ocupied.kind != 'a'
        test_c = GAME.Player.Hover.y - 1 >= 0 and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y - 1].ocupied != 0  and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y - 1].ocupied.player == 'player' and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y - 1].ocupied.kind != 'a'
        test_d = GAME.Player.Hover.y+1 <= GAME.Board.Height and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y + 1].ocupied != 0 and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y + 1].ocupied.player == 'player' and GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y + 1].ocupied.kind != 'a'
        if test_a or test_b or test_c or test_d
          if (GAME.Player.Credits >= 1 and GAME.Player.Hover.kind != 'a') or GAME.Player.Credits >= 2
            GAME.Player.Credits -= 1
            GAME.Player.Credits -= 1 if GAME.Player.Hover.kind == 'a'

            GAME.Player.Hover.hover = false
            GAME.Board.Data[GAME.Player.Hover.x][GAME.Player.Hover.y].ocupied = GAME.Player.Hover
            PS.BeadFlashColor x,y,0xffffff
            PS.BeadFlash x,y
            PS.AudioPlay G.SOUNDS.PLACE_BUILDING
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

PS.KeyDown = (key, shift, ctrl) ->
  "use strict"
  if key == 27
    deselect()
  else if key == 65
    PS.Click G.GRID.WIDTH-1,G.GRID.HEIGHT,PS.BeadData G.GRID.WIDTH-1,G.GRID.HEIGHT
    PS.Enter GAME.Player.Last.x,GAME.Player.Last.y
  else if key == 83
    PS.Click G.GRID.WIDTH-7,G.GRID.HEIGHT,PS.BeadData G.GRID.WIDTH-7,G.GRID.HEIGHT
    PS.Enter GAME.Player.Last.x,GAME.Player.Last.y
  else if key == 68
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
    GAME.Off_Set.x = Math.max(0,Math.min(GAME.Board.Width-G.GRID.WIDTH,GAME.Off_Set.x + GAME.Board.Shifting.x))
    GAME.Off_Set.y = Math.max(0,Math.min(GAME.Board.Height-G.GRID.HEIGHT,GAME.Off_Set.y + GAME.Board.Shifting.y))
  draw_game()
  if G.Tick % 5 == 0
    move_game()
  if GAME.Player.Selected != 0
    for x in [GAME.Player.Selected.x..GAME.Player.Selected.w]
      for y in [GAME.Player.Selected.y..GAME.Player.Selected.h]
        PS.BeadBorderColor x+GAME.Off_Set.x,y+GAME.Off_Set.y,0x00ffff
        PS.BeadBorderWidth x+GAME.Off_Set.x,y+GAME.Off_Set.y,2
  GAME.Comp.AI.think()



### END OF GAME CODE ###