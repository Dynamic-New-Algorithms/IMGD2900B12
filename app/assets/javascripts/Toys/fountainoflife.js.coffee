### oppen to puplic use
William Decker
###
#------------------------------------ Classes -------------------------------------
class fountain
  constructor: (r,g,b) ->
    @red_out = r
    @green_out = g
    @blue_out = b
    @health = health_max
    @last_udate = 1


  update:(x,y) ->
    @last_update = -1 * @last_update
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

    if @health < 0
      PS.BeadData x,y,0

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
      bw: 0
      name: 'north'
    south =
      x: x
      y: y + 1
      g: 0
      c: 0
      bc: 0
      bw: 0
      name: 'south'
    east =
      x: x + 1
      y: y
      g: 0
      c: 0
      bc: 0
      bw: 0
      name: 'east'
    west =
      x: x - 1
      y: y
      g: 0
      c: 0
      bc: 0
      bw: 0
      name: 'west'

    north.y = GRID_SIZE - 5 if north.y < 0
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

    north.bw = PS.BeadBorderWidth north.x,north.y
    south.bw = PS.BeadBorderWidth south.x,south.y
    east.bw = PS.BeadBorderWidth east.x,east.y
    west.bw = PS.BeadBorderWidth west.x,west.y

    r = Math.random()
    sides = [north,south,east,west]
    sides = [north, south, west, east] if r >= 1/24
    sides = [north, east, south, west] if r >= 2/24
    sides = [north, east, west, south] if r >= 3/24
    sides = [north, west, south, east] if r >= 4/24
    sides = [north, west, east, south] if r >= 5/24
    sides = [south, north, east, west] if r >= 6/24
    sides = [south, north, west, east] if r >= 7/24
    sides = [south, east, north, west] if r >= 8/24
    sides = [south, east, west, north] if r >= 9/24
    sides = [south, west, north, east] if r >= 10/24
    sides = [south, west, east, north] if r >= 11/24
    sides = [east, north, south, west] if r >= 12/24
    sides = [east, north, west, south] if r >= 13/24
    sides = [east, south, north, west] if r >= 14/24
    sides = [east, south, west, north] if r >= 15/24
    sides = [east, west, north, south] if r >= 16/24
    sides = [east, west, south, north] if r >= 17/24
    sides = [west, north, south, east] if r >= 18/24
    sides = [west, north, east, south] if r >= 19/24
    sides = [west, south, north, east] if r >= 20/24
    sides = [west, south, east, north] if r >= 21/24
    sides = [west, east, north, south] if r >= 22/24
    sides = [west, east, south, north] if r >= 23/24
    got_to = ''
    if center.d.health >= @health.low and center.d.health <= @health.high
      got_to = got_to + 'health, '
      if (center.c.r >= @red.low and center.c.r <= @red.high) or (center.c.g >= @green.low and center.c.g <= @green.high) or (center.c.b >= @blue.low and center.c.b <= @blue.high)
        got_to = got_to + 'color, '
        for s in sides
          if (s.c.r >= @side.color.red.low and s.c.r <= @side.color.red.high) or (s.c.g >= @side.color.green.low and s.c.g <= @side.color.green.high) or (s.c.b >= @side.color.blue.low and s.c.b <= @side.color.blue.high)
            got_to = got_to + 's color, '
            if s.g <= @side.glyph.low or s.g >= @side.glyph.high
              got_to = got_to + 's glyph, '
              if s.bw == 0
                return s.name
              if (s.bc.r >= @side.border_color.red.low and s.bc.r <= @side.border_color.red.high) or (s.bc.g >= @side.border_color.green.low and s.bc.g <= @side.border_color.green.high) or (s.bc.b >= @side.border_color.blue.low and s.bc.b <= @side.border_color.blue.high)
                got_to = got_to + 's bc color, '
                alert got_to if DEBUG
                return s.name

    alert got_to if DEBUG
    return 'none'

  make_copy: () ->

    h = @health
    r = @red
    g = @green
    b = @blue
    sr = @side.color.red
    sb = @side.color.blue
    sg = @side.color.green
    sy = @side.glyph
    sbr = @side.border_color.red
    sbg = @side.border_color.green
    sbb = @side.border_color.blue

    h = mutate(@health.low,@health.high,0,health_max)  if Math.random() < mutation_factor
    r = mutate(@red.low,@red.high,0,255)  if Math.random() < mutation_factor
    g = mutate(@green.low,@green.high,0,255)  if Math.random() < mutation_factor
    b = mutate(@blue.low,@blue.high,0,255)  if Math.random() < mutation_factor

    sr = mutate(@side.color.red.low,@side.color.red.high,0,255) if Math.random() < mutation_factor
    sb = mutate(@side.color.blue.low,@side.color.blue.high,0,255) if Math.random() < mutation_factor
    sg = mutate(@side.color.green.low,@side.color.green.high,0,255) if Math.random() < mutation_factor
    sy = mutate(@side.glyph.low,@side.glyph.high,33,126) if Math.random() < mutation_factor
    sbr = mutate(@side.border_color.red.low,@side.border_color.red.high,0,255) if Math.random() < mutation_factor
    sbg = mutate(@side.border_color.green.low,@side.border_color.green.high,0,255) if Math.random() < mutation_factor
    sbb = mutate(@side.border_color.blue.low,@side.border_color.blue.high,0,255) if Math.random() < mutation_factor
    return new life_action(h.low, h.high,r.low,r.high,g.low,g.high,b.low,b.high,sr.low,sr.high,sg.low,sg.high,sb.low,sg.high,sy.low,sy.high,sbr.low,sbr.high,sbg.low,sbg.high,sbb.low,sbb.high)


class cell
  constructor: (ri,bi,gi,gl,ew,mw,aw,cw,start_health) ->
    @red_in = ri
    @blue_in = bi
    @green_in = gi
    @glyph = gl
    @health = start_health
    @eat_when = ew
    @attack_when = aw
    @move_when = mw
    @copy_when = cw

    @last_update = 1

  update: (x,y,data) ->
    #draw
    PS.BeadBorderColor x,y, PS.MakeRGB(Math.floor(@red_in),Math.floor(@blue_in),Math.floor(@green_in))
    PS.BeadBorderWidth x,y,1
    PS.BeadGlyphColor x,y,PS.MakeRGB(Math.floor(@red_in),Math.floor(@blue_in),Math.floor(@green_in))
    PS.BeadGlyph x,y,@glyph
    if @last_update == data
      #shift update
      @last_udate = @last_update * -1
      #check health
      if @health > 0
        #do copy
        m = @copy_when.do_test(x,y)
        if m != 'none'
          @health = @health - 16
          if m == 'north'
            yi = y - 1
            yi = GRID_SIZE - 5 if y <= 0
            nd = PS.BeadData x,yi
            if nd == 0 or nd == 'undefined'
              PS.BeadData x,yi,this.make_copy()
            return true
          else if m == 'south'
            yi = y + 1
            yi = 0 if y > GRID_SIZE - 5
            nd = PS.BeadData x,yi
            if nd == 0 or nd == 'undefined'
              PS.BeadData x,yi,this.make_copy()
              PS.BeadData x,y,0
            return true
          else if m == 'east'
            xi = x + 1
            xi = 0 if xi > GRID_SIZE - 1
            nd = PS.BeadData xi,y
            if nd == 0 or nd == 'undefined'
              PS.BeadData xi,y,this.make_copy()
            return true
          else if m == 'west'
            xi = x - 1
            xi = GRID_SIZE - 1 if x <= 0
            nd = PS.BeadData xi,y
            if nd == 0 or nd == 'undefined'
              PS.BeadData xi,y,this.make_copy()
            return true
        #do attack
        m = @attack_when.do_test(x,y)
        if m != 'none'
          @health = @health - 8
          if m == 'north'
            yi = y - 1
            yi = GRID_SIZE - 5 if y <= 0
            nd = PS.BeadData x,yi
            if nd != 0 or nd != 'undefined'
              nd.health = nd.health - 16
            return true
          else if m == 'south'
            yi = y + 1
            yi = 0 if y > GRID_SIZE - 5
            nd = PS.BeadData x,yi
            if nd == 0 or nd == 'undefined'
              nd.health = nd.health - 16
            return true
          else if m == 'east'
            xi = x + 1
            xi = 0 if xi > GRID_SIZE - 1
            nd = PS.BeadData xi,y
            if nd == 0 or nd == 'undefined'
              nd.health = nd.health - 16
            return true
          else if m == 'west'
            xi = x - 1
            xi = GRID_SIZE - 1 if x <= 0
            nd = PS.BeadData xi,y
            if nd == 0 or nd == 'undefined'
              nd.health = nd.health - 16
            return true
        #do move
        m = @move_when.do_test(x,y)
        if m != 'none'
          @health = @health - 4
          if m == 'north'
            yi = y - 1
            yi = GRID_SIZE - 5 if y <= 0
            nd = PS.BeadData x,yi
            if nd == 0 or nd == 'undefined'
              PS.BeadData x,yi,this
              PS.BeadData x,y,0
            return true
          else if m == 'south'
            yi = y + 1
            yi = 0 if y > GRID_SIZE - 5
            nd = PS.BeadData x,yi
            if nd == 0 or nd == 'undefined'
              PS.BeadData x,yi,this
              PS.BeadData x,y,0
            return true
          else if m == 'east'
            xi = x + 1
            xi = 0 if xi > GRID_SIZE - 1
            nd = PS.BeadData xi,y
            if nd == 0 or nd == 'undefined'
              PS.BeadData xi,y,this
              PS.BeadData x,y,0
            return true
          else if m == 'west'
            xi = x - 1
            xi = GRID_SIZE - 1 if x <= 0
            nd = PS.BeadData xi,y
            if nd == 0 or nd == 'undefined'
              PS.BeadData xi,y,this
              PS.BeadData x,y,0
            return true
        #do eat
        if @eat_when.do_test(x,y) != 'none'
          c = PS.UnmakeRGB PS.BeadColor x,y
          @health = @health + Math.min(health_max,Math.floor((@red_in/255)*c.r))
          c.r = c.r - Math.floor((@red_in/255)*c.r)
          @health = @health + Math.min(health_max,Math.floor((@green_in/255)*c.g))
          c.g = c.g - Math.floor((@green_in/255)*c.g)
          @health = @health + Math.min(health_max,Math.floor((@blue_in/255)*c.b))
          c.b = c.b - Math.floor((@blue_in/255)*c.b)
          PS.BeadColor x,y,PS.MakeRGB c.r, c.g, c.b
          @health = @health - 2

          return true
      else
        this.Click(x,y,this)
      @health = @health - 1

      return true

  make_copy: () ->
    ri = @red_in
    gi = @green_in
    bi = @blue_in
    glyph = @glyph
    ew = @eat_when
    aw = @attack_when
    mw = @move_when
    cw = @copy_when

    ri = mutate_2(ri,0,255) if Math.random() < mutation_factor
    gi = mutate_2(gi,0,255) if Math.random() < mutation_factor
    bi = mutate_2(bi,0,255) if Math.random() < mutation_factor
    glyph = Math.floor(mutate_2(glyph,33,126))  if Math.random() < mutation_factor
    while ri + gi + bi > 255
      ri = Math.max(0,ri - 1)
      gi = Math.max(0,gi - 1)
      bi = Math.max(0,bi - 1)


    ew = ew.make_copy() if Math.random() < mutation_factor
    aw = aw.make_copy() if Math.random() < mutation_factor
    mw = mw.make_copy() if Math.random() < mutation_factor
    cw = cw.make_copy() if Math.random() < mutation_factor

    c = new cell(ri,gi,bi,glyph,ew,mw,aw,cw,@health)
    c.last_update = @last_update
    return c



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
  if new_high < new_low
    r.low = new_high
    r.high = new_low
  return r
mutate_2 = (v,min,max) ->
  range = max-min
  new_v = Math.max(min,Math.min(max,(v + 0.01*Math.random()*range - 0.01*Math.random()*range)))
  return new_v

make_random_cell = (glyph) ->
  h = mutate(0,health_max,0,health_max)
  r = mutate(0,255,0,255)
  g = mutate(0,255,0,255)
  b = mutate(0,255,0,255)
  sr = mutate(0,255,0,255)
  sb =  mutate(0,255,0,255)
  sg =  mutate(0,255,0,255)
  sy =  mutate(33,33,33,126)
  sbr =  mutate(0,255,0,255)
  sbg =  mutate(0,255,0,255)
  sbb =  mutate(0,255,0,255)
  ew = new life_action(h.low, h.high,r.low,r.high,g.low,g.high,b.low,b.high,sr.low,sr.high,sg.low,sg.high,sb.low,sb.high,sy.low,sy.high,sbr.low,sbr.high,sbg.low,sbg.high,sbb.low,sbb.high)

  h = mutate(0.75*health_max,health_max,0,health_max)
  r = mutate(0,255,0,255)
  g = mutate(0,255,0,255)
  b = mutate(0,255,0,255)
  sr = mutate(0,255,0,255)
  sb =  mutate(0,255,0,255)
  sg =  mutate(0,255,0,255)
  sy =  mutate(33,126,33,126)
  sbr =  mutate(0,255,0,255)
  sbg =  mutate(0,255,0,255)
  sbb =  mutate(0,255,0,255)
  aw = new life_action(h.low, h.high,r.low,r.high,g.low,g.high,b.low,b.high,sr.low,sr.high,sg.low,sg.high,sb.low,sb.high,sy.low,sy.high,sbr.low,sbr.high,sbg.low,sbg.high,sbb.low,sbb.high)

  h = mutate(0,health_max,0,health_max)
  r = mutate(0,50,0,255)
  g = mutate(0,50,0,255)
  b = mutate(0,50,0,255)
  sr = mutate(50,255,0,255)
  sb =  mutate(50,255,0,255)
  sg =  mutate(50,255,0,255)
  sy =  mutate(33,33,33,126)
  sbr =  mutate(0,255,0,255)
  sbg =  mutate(0,255,0,255)
  sbb =  mutate(0,255,0,255)
  mw = new life_action(h.low, h.high,r.low,r.high,g.low,g.high,b.low,b.high,sr.low,sr.high,sg.low,sg.high,sb.low,sb.high,sy.low,sy.high,sbr.low,sbr.high,sbg.low,sbg.high,sbb.low,sbb.high)

  h = mutate(0.85*health_max,health_max,0,health_max)
  r = mutate(0,255,0,255)
  g = mutate(0,255,0,255)
  b = mutate(0,255,0,255)
  sr = mutate(0,255,0,255)
  sb =  mutate(0,255,0,255)
  sg =  mutate(0,255,0,255)
  sy =  mutate(33,33,33,126)
  sbr =  mutate(0,255,0,255)
  sbg =  mutate(0,255,0,255)
  sbb =  mutate(0,255,0,255)
  cw = new life_action(h.low, h.high,r.low,r.high,g.low,g.high,b.low,b.high,sr.low,sr.high,sg.low,sg.high,sb.low,sb.high,sy.low,sy.high,sbr.low,sbr.high,sbg.low,sbg.high,sbb.low,sbb.high)


  c = new cell(85,85,85,glyph,ew,mw,aw,cw,health_max)


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
GRID_SIZE = 32
DEBUG = false
mutation_factor = 0.1
health_max = 512
cell_start = make_random_cell()
lu = 1

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
  xi = Math.floor(1/6*(GRID_SIZE-1))
  yi = Math.floor(1/4*(GRID_SIZE-5))
  f = new fountain(255,0,0)
  x = Math.floor(1/3*(GRID_SIZE-1)) + xi
  y = 0 + yi
  PS.BeadData x,y,f
  c = make_random_cell(43)
  PS.BeadData x+1,y,c
  f = new fountain(0,255,0)
  x = Math.floor(0/3*(GRID_SIZE-1)) + xi
  y = Math.floor((GRID_SIZE-5) / 2) + yi
  PS.BeadData x,y,f
  c = make_random_cell(44)
  PS.BeadData x+1,y,c
  f = new fountain(0,0,255)
  x = Math.floor(2/3*(GRID_SIZE-1)) + xi
  y = Math.floor((GRID_SIZE-5) / 2) + yi
  PS.BeadData x,y,f
  c = make_random_cell(45)
  PS.BeadData x+1,y,c

  x = Math.floor(1/2*(GRID_SIZE-1))
  y = Math.floor(1/2*(GRID_SIZE-5))
  c = make_random_cell(33)
  PS.BeadData x,y,c
  c = make_random_cell(34)
  PS.BeadData x+1,y,c
  c = make_random_cell(35)
  PS.BeadData x+1,y+1,c
  c = make_random_cell(36)
  PS.BeadData x,y+1,c
  #start the Clock
  PS.Clock 10

PS.Click = (x, y, data) ->
  "use strict"

  if data == 0
    #DEBUG = true
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
  lu = -1 * lu
  for x in [0..(GRID_SIZE-1)]
    for y in [0..(GRID_SIZE-5)]
      d = PS.BeadData x,y
      if d != 0 and d != undefined
        d.update x,y,lu
      else
        PS.BeadBorderWidth x,y,0
        PS.BeadGlyph x,y,0
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









