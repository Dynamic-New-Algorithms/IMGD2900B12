### oppen to puplic use
    Dynamic New Algorithms
    William Decker
    Peter Lepper
###

class Light
  constructor: (x,y,r) ->
    @x = y
    @y = x
    @r = r

  get_color: (x,y) ->
    d = Math.max(0.00001,Math.sqrt(Math.pow((x-@x),2)+Math.pow((y-@y),2)))
    a = 1
    a = 1.1-1.1*(G.bright / (d/@r) )if (d/@r) > 0
    return Math.min(100,Math.max(0,a*100))

class Obj
  constructor: (x,y,data) ->
    @x = y
    @y = x
    @data = data
    @interact = null

  get_color: (x,y,level,pos) ->
    r =  @data[level][pos].data[y*@data[level][pos].width*@data[level][pos].pixelSize+x*@data[level][pos].pixelSize]
    g =  @data[level][pos].data[y*@data[level][pos].width*@data[level][pos].pixelSize+x*@data[level][pos].pixelSize + 1]
    b =  @data[level][pos].data[y*@data[level][pos].width*@data[level][pos].pixelSize+x*@data[level][pos].pixelSize + 2]
    a =  @data[level][pos].data[y*@data[level][pos].width*@data[level][pos].pixelSize+x*@data[level][pos].pixelSize + 3]
    return {r: r,g: g,b: b,a: a}

class Player
  constructor: (x,y,fx,fy) ->
    @x = x
    @y = y
    @fx = fx
    @fy = fy
    @health = 2.3
    @beat = 0
    @mx = 15
    @my = 15
    @high_low = 0
    @light = new Light(@x,@y,15,1)
    @max_h = 7.27
    @min_h = 2.25
    @max_b = 5

  draw_heart: (x,y) ->
    @beat += @health
    if @beat >= 138
      px = @x
      py = @y
      mx = Monster.x
      my = Monster.y
      d = Math.sqrt(Math.pow(mx-px,2)+Math.pow(my-py,2))
      @health = Math.max(@min_h,@health - Math.pow(0.25,d))
      @high_low = 0
      @beat = 0
    if @beat >= 68 and @high_low == 0
      PS.AudioPlay 'perc_drum_tom3', (@health/(@max_h-@min_h))
      @high_low = 1
    if @beat >= 89 and @high_low == 1
      PS.AudioPlay 'perc_drum_tom4', (@health/(@max_h-@min_h))
      @high_low = 2
    if PS.BeadData(x,y) == -1
      PS.BeadData x,y,PS.BeadColor(x,y)
    PS.BeadBorderColor x,y,PS.BeadData(x,y)
    PS.BeadColor x,y,Math.floor(100*(1-this.get_heart_size(@beat)))+125,0,Math.floor(20*(this.get_heart_size(@beat)))
    PS.BeadBorderWidth x,y,Math.floor((1-this.get_heart_size(@beat)) * @max_b)

  get_heart_size: (x) ->
    if 0 <= x and x < 51
      return 45/100.0
    else if 51 <= x and x < 55
      return (-1.25*x+108.75) / 100.0
    else if 55 <= x and x < 60
      return (2*x-70) / 100.0
    else if 60 <= x and x < 63
      return 50/100.0
    else if 63 <= x and x < 65
      return  (1.5*x-44.5) / 100.0
    else if 65 <= x and x < 71
      return (-8.833*x+627.166) / 100.0
    else if 71 <= x and x < 72
      return (100*x-7100) / 100.0
    else if 72 <= x and x < 76
      return (-13.25*x+1054) / 100.0
    else if 76 <= x and x < 82
      return (-1.167*x+135.667) / 100.0
    else if 82 <= x and x < 89
      return (-2.429*x+239.143) / 100.0
    else if 89 <= x and x < 97
      return (5.75*x-488.75) / 100.0
    else if 97 <= x and x < 110
      return (-1.846*x+248.077) / 100.0
    else
      return 45/100.0


class World
  constructor: (data,sx,sy,sfx,sfy,light_data,obj_data) ->
    @player = new Player(sx,sy,sfx,sfy)
    @data = data
    @light_data = light_data
    @obj_data = obj_data

  draw: (my_light) ->
    PS.BeadGlyph PS.ALL,PS.ALL,0
    img = {width: 32, height: 32, pixelSize: 4, data: []}

    offsets = [
      {level: 'gama',pos: 'left',l: 2,po: -1, lights: []},
      {level: 'gama',pos: 'center',l: 3,po: 0, lights: []},
      {level: 'gama',pos: 'right',l: 2,po: 1, lights: []},
      {level: 'beta',pos: 'left',l: 1,po: -1, lights: []},
      {level: 'beta',pos: 'center',l: 2,po: 0, lights: []},
      {level: 'beta',pos: 'right',l: 1,po: 1, lights: []},
      {level: 'alpha',pos: 'left',l: 0,po: -1, lights: []},
      {level: 'alpha',pos: 'center',l: 1,po: 0, lights: []},
      {level: 'alpha',pos: 'right',l: 0,po: 1, lights: []}
    ]
    light_offsets = [
      {level: 'gama',pos: 'left',l: 2,po: -1, lights: []},
      {level: 'gama',pos: 'center',l: 2,po: 0, lights: []},
      {level: 'gama',pos: 'right',l: 2,po: 1, lights: []},
      {level: 'beta',pos: 'left',l: 1,po: -1, lights: []},
      {level: 'beta',pos: 'center',l: 1,po: 0, lights: []},
      {level: 'beta',pos: 'right',l: 1,po: 1, lights: []},
      {level: 'alpha',pos: 'left',l: 0,po: -1, lights: []},
      {level: 'alpha',pos: 'center',l: 0,po: 0, lights: []},
      {level: 'alpha',pos: 'right',l: 0,po: 1, lights: []}
    ]
    if @player.fx == -1
      offsets = [
        {level: 'gama',pos: 'left',l: -2,po: 1, lights: []},
        {level: 'gama',pos: 'center',l: -3,po: 0, lights: []},
        {level: 'gama',pos: 'right',l: -2,po: -1, lights: []},
        {level: 'beta',pos: 'left',l: -1,po: 1, lights: []},
        {level: 'beta',pos: 'center',l: -2,po: 0, lights: []},
        {level: 'beta',pos: 'right',l: -1,po: -1, lights: []},
        {level: 'alpha',pos: 'left',l: 0,po: 1, lights: []},
        {level: 'alpha',pos: 'center',l: -1,po: 0, lights: []},
        {level: 'alpha',pos: 'right',l: 0,po: -1, lights: []}
      ]
      light_offsets = [
        {level: 'gama',pos: 'left',l: -2,po: -1, lights: []},
        {level: 'gama',pos: 'center',l: -2,po: 0, lights: []},
        {level: 'gama',pos: 'right',l: -2,po: 1, lights: []},
        {level: 'beta',pos: 'left',l: -1,po: -1, lights: []},
        {level: 'beta',pos: 'center',l: -1,po: 0, lights: []},
        {level: 'beta',pos: 'right',l: -1,po: 1, lights: []},
        {level: 'alpha',pos: 'left',l: 0,po: -1, lights: []},
        {level: 'alpha',pos: 'center',l: 0,po: 0, lights: []},
        {level: 'alpha',pos: 'right',l: 0,po: 1, lights: []}
      ]
    else if @player.fy == 1
      offsets = [
        {level: 'gama',pos: 'left',l: 1,po: 2, lights: []},
        {level: 'gama',pos: 'center',l: 0,po: 3, lights: []},
        {level: 'gama',pos: 'right',l: -1,po: 2, lights: []},
        {level: 'beta',pos: 'left',l: 1,po: 1, lights: []},
        {level: 'beta',pos: 'center',l: 0,po: 2, lights: []},
        {level: 'beta',pos: 'right',l: -1,po: 1, lights: []},
        {level: 'alpha',pos: 'left',l: 1,po: 0, lights: []},
        {level: 'alpha',pos: 'center',l: 0,po: 1, lights: []},
        {level: 'alpha',pos: 'right',l: -1,po: 0, lights: []}
      ]
      light_offsets = [
        {level: 'gama',pos: 'left',l: 1,po: 2, lights: []},
        {level: 'gama',pos: 'center',l: 0,po: 2, lights: []},
        {level: 'gama',pos: 'right',l: -1,po: 2, lights: []},
        {level: 'beta',pos: 'left',l: 1,po: 1, lights: []},
        {level: 'beta',pos: 'center',l: 0,po: 1, lights: []},
        {level: 'beta',pos: 'right',l: -1,po: 1, lights: []},
        {level: 'alpha',pos: 'left',l: 1,po: 0, lights: []},
        {level: 'alpha',pos: 'center',l: 0,po: 0, lights: []},
        {level: 'alpha',pos: 'right',l: -1,po: 0, lights: []}
      ]
    else if @player.fy == -1
      offsets = [
        {level: 'gama',pos: 'left',l: -1,po: -2, lights: []},
        {level: 'gama',pos: 'center',l: 0,po: -3, lights: []},
        {level: 'gama',pos: 'right',l: 1,po: -2, lights: []},
        {level: 'beta',pos: 'left',l: -1,po: -1, lights: []},
        {level: 'beta',pos: 'center',l: 0,po: -2, lights: []},
        {level: 'beta',pos: 'right',l: 1,po: -1, lights: []},
        {level: 'alpha',pos: 'left',l: -1,po: 0, lights: []},
        {level: 'alpha',pos: 'center',l: 0,po: -1, lights: []},
        {level: 'alpha',pos: 'right',l: 1,po: 0, lights: []}
      ]
      light_offsets = [
        {level: 'gama',pos: 'left',l: -1,po: -2, lights: []},
        {level: 'gama',pos: 'center',l: 0,po: -2, lights: []},
        {level: 'gama',pos: 'right',l: 1,po: -2, lights: []},
        {level: 'beta',pos: 'left',l: -1,po: -1, lights: []},
        {level: 'beta',pos: 'center',l: 0,po: -1, lights: []},
        {level: 'beta',pos: 'right',l: 1,po: -1, lights: []},
        {level: 'alpha',pos: 'left',l: -1,po: 0, lights: []},
        {level: 'alpha',pos: 'center',l: 0,po: 0, lights: []},
        {level: 'alpha',pos: 'right',l: 1,po: 0, lights: []}
      ]
    #figure out lights
    ply_count = 0
    for ply in light_offsets
      #alert @player.y + ', ' + @player.x
      sx = @player.y+ply.po
      sy = @player.x+ply.l
      if sx >= 0 and sx < @data.length
        if sy >= 0 and sy < @data[sx].length
          for light in @light_data
            #try walking x then y
            x = 0
            y = 0
            for xi in [sx..light.y]
              x = xi
              if @data[x][sy][ply.level][ply.pos].wall != null
                break
            if x == light.y
              for yi in [sy..light.x]
                y = yi
                if @data[x][y][ply.level][ply.pos].wall != null
                  break
              if x == light.y and y == light.x
                light_offsets[ply_count].lights.push([x,y])
            else
              #alert 'after h ' + sx + ', ' + sy + ') ' + ply.level + ', ' + ply.pos + ' (' + x + ', ' + y   + ')' + light.y + ', ' + light.x
              x = 0
              y = 0
              #try walking y then x
              for yi in [sy..light.x]
                y = yi
                if @data[sx][y][ply.level][ply.pos].wall != null
                  break
              if y == light.x
                for xi in [sx..light.y]
                  x = xi
                  if @data[x][y][ply.level][ply.pos].wall != null
                    break
                if x == light.y and y == light.x
                  light_offsets[ply_count].lights.push([x,y])


      ply_count += 1


    for y in [0..31]
      for x in [0..31]
        c = {r:0, g:0, b:0,a:100}
        my_light_a = my_light.get_color(x,y)
        #PS.Debug x + ', ' + y + ' = ' + c.r + ', '+ c.g + ', '+ c.b + ' -> '
        ply_count = -1
        have_monster = null
        for ply in offsets
          ply_count += 1
          if ply_count%3 == 0
            have_monster = null
          if @player.y+ply.po >= 0 and @player.y+ply.po < @data.length
            if @player.x+ply.l >= 0 and @player.x+ply.l < @data[@player.y+ply.po].length

              for type in ['floor','roof','wall']
                new_c_r == 0
                new_c_g == 0
                new_c_b == 0
                new_c_a == 0
                if  @data[@player.y+ply.po][@player.x+ply.l][ply.level][ply.pos][type] != null
                  new_c_r = @data[@player.y+ply.po][@player.x+ply.l][ply.level][ply.pos][type].data[img.data.length]
                  new_c_g = @data[@player.y+ply.po][@player.x+ply.l][ply.level][ply.pos][type].data[img.data.length+1]
                  new_c_b = @data[@player.y+ply.po][@player.x+ply.l][ply.level][ply.pos][type].data[img.data.length+2]
                  new_c_a = @data[@player.y+ply.po][@player.x+ply.l][ply.level][ply.pos][type].data[img.data.length+3]
                  c.r = c.r*(1-new_c_a/100) + new_c_r*(new_c_a/100)
                  c.g = c.g*(1-new_c_a/100) + new_c_g*(new_c_a/100)
                  c.b = c.b*(1-new_c_a/100) + new_c_b*(new_c_a/100)
                  light_a = 100
                  no_light = true
                  dddddd = ply.level + ', ' + ply.pos + ' -> '
                  light_set = light_offsets[ply_count].lights
                  light_set = light_offsets[ply_count-1].lights if ply.pos == 'right'
                  light_set = light_offsets[ply_count+1].lights if ply.pos == 'left'
                  if ply.level != 'alpha' and @data[@player.y+ply.po][@player.x+ply.l][ply.level][ply.pos].wall != null
                    light_set = light_offsets[ply_count-1+3].lights if ply.pos == 'right'
                    light_set = light_offsets[ply_count+1+3].lights if ply.pos == 'left'
                  for light_pos in light_set
                    for light in @light_data
                      if Math.floor(light.x) == light_pos[1] and Math.floor(light.y) == light_pos[0]
                        light_a = light_a - (100-light.get_color(x,y))
                  #alert dddddd + ' || ' + no_light
                  light_a = light_a - (100-my_light_a)
                  light_a = Math.min(Math.max(0,light_a),100)
                  light_a = 100 unless G.lights
                  light_a = 0 if G.won
                  #light_a = 100 if no_light
                  #PS.Debug  light_a
                  c.r = c.r*(1-light_a/100) + 0*(light_a/100) unless new_c_r == 0 and new_c_g == 0 and new_c_b == 0 and new_c_a == 0
                  c.g = c.g*(1-light_a/100) + 0*(light_a/100) unless new_c_r == 0 and new_c_g == 0 and new_c_b == 0 and new_c_a == 0
                  c.b = c.b*(1-light_a/100) + 0*(light_a/100) unless new_c_r == 0 and new_c_g == 0 and new_c_b == 0 and new_c_a == 0
          for obj in @obj_data
            if obj.data.name == 'monster'
              t = obj.x
              obj.x = obj.y
              obj.y = t
            this_ply = ply
            this_ply = light_offsets[ply_count] if ply.pos == 'center'
            if Math.floor(obj.x) == @player.y+this_ply.po and Math.floor(obj.y) == @player.x+this_ply.l or (obj.data.name == 'monster' and have_monster != null)
              new_c = obj.get_color(x,y,this_ply.level,this_ply.pos)
              new_c = obj.get_color(x,y,this_ply.level,have_monster) if have_monster != null
              new_c_r = new_c.r
              new_c_g = new_c.g
              new_c_b = new_c.b
              new_c_a = new_c.a
              c.r = c.r*(1-new_c_a/100) + new_c_r*(new_c_a/100)
              c.g = c.g*(1-new_c_a/100) + new_c_g*(new_c_a/100)
              c.b = c.b*(1-new_c_a/100) + new_c_b*(new_c_a/100)

              if obj.data.name != 'monster'
                light_a = 100
                no_light = true
                dddddd = this_ply.level + ', ' + this_ply.pos + ' -> '
                light_set = light_offsets[ply_count].lights
                light_set = light_offsets[ply_count-1].lights if ply.pos == 'right'
                light_set = light_offsets[ply_count+1].lights if ply.pos == 'left'
                if ply.level != 'alpha' and @data[@player.y+ply.po][@player.x+ply.l][ply.level][ply.pos].wall != null
                  light_set = light_offsets[ply_count-1+3].lights if ply.pos == 'right'
                  light_set = light_offsets[ply_count+1+3].lights if ply.pos == 'left'
                for light_pos in light_set
                  for light in @light_data
                    if Math.floor(light.x) == light_pos[1] and Math.floor(light.y) == light_pos[0]
                      light_a = light_a - (100-light.get_color(x,y))
                #alert dddddd + ' || ' + no_light
                light_a = light_a - (100-my_light_a)
                light_a = Math.min(Math.max(0,light_a),100)
                #light_a = 100 if no_light
                #PS.Debug  light_a
                light_a = 100 unless G.lights
                light_a = 0 if G.won
                c.r = c.r*(1-light_a/100) + 0*(light_a/100) unless new_c_r == 0 and new_c_g == 0 and new_c_b == 0 and new_c_a == 0
                c.g = c.g*(1-light_a/100) + 0*(light_a/100) unless new_c_r == 0 and new_c_g == 0 and new_c_b == 0 and new_c_a == 0
                c.b = c.b*(1-light_a/100) + 0*(light_a/100) unless new_c_r == 0 and new_c_g == 0 and new_c_b == 0 and new_c_a == 0
              else
                have_monster = this_ply.pos if have_monster == null
            if obj.data.name == 'monster'
              t = obj.x
              obj.x = obj.y
              obj.y = t

        #PS.Debug  ' -> ' + c.r + ', '+ c.g + ', '+ c.b + '\n'
        img.data.push Math.floor(c.r)
        img.data.push Math.floor(c.g)
        img.data.push Math.floor(c.b)
        img.data.push Math.floor(c.a)
    PS.ImageBlit(img)
    PS.BeadBorderColor my_light.x,my_light.y,PS.BeadColor(my_light.x,my_light.y)
    PS.BeadBorderWidth my_light.x,my_light.y,0
    PS.BeadData my_light.x,my_light.y,-1

class Note
  constructor: (text) ->
    @text = text
    @curser = {x: 7,y: 4}
    @min = {x: 7,y: 4}
    @max = {x: 24,y: 27}
    @auto_type = text
    @clear = true

  type: (sound) ->

    if @auto_type.length > 0
      l = @auto_type[0]
      @auto_type = @auto_type.substr(1)
      if l != '$' and l != '#' and l != '%'
        if @clear and l != ' '
          PS.StatusText('')
          @clear = false
        PS.StatusText(PS.StatusText()+l) unless @clear
        PS.BeadGlyphColor @curser.x,@curser.y,0x000000
        PS.BeadGlyph @curser.x,@curser.y,l
        PS.AudioPlay 'fx_click' if l != ' ' and sound
        @curser.x += 1
        if @curser.x >= @max.x
          @curser.y += 1
          @curser.x = @min.x
          PS.StatusText('')
          if @curser.y >= @max.y
            @curser.y = @min.y
            PS.BeadGlyph PS.ALL,PS.ALL, 0
      else if l == '#'
        @clear = true
        @curser.y += 1
        @curser.x = @min.x
        PS.StatusText('')
        if @curser.y >= @max.y
          @curser.y = @min.y
          PS.BeadGlyph PS.ALL,PS.ALL, 0
      else if l == '%'
        PS.AudioPlay 'fx_drip2' if sound
        PS.BeadGlyphColor @curser.x,@curser.y,0xff0000
        PS.BeadGlyph @curser.x,@curser.y,'☁'
        PS.BeadGlyph @curser.x,@curser.y,'❦' if Math.random() > 0.05
        @curser.x += 1
        if @curser.x >= @max.x
          @curser.y += 1
          @curser.x = @min.x
          PS.StatusText('')
          if @curser.y >= @max.y
            @curser.y = @min.y
            PS.BeadGlyph PS.ALL,PS.ALL, 0

    else
      PS.StatusText 'Trapped in the Void'

draw_bright = () ->
  PS.StatusText 'Please adjust the brigtness.'
  PS.BeadGlyph(PS.ALL,PS.ALL,0)
  PS.BeadGlyphColor(PS.ALL,PS.ALL,0x000000)
  PS.BeadColor(PS.ALL,PS.ALL,0x000000)
  text = ['Not Visible',
    '...',
    'Barly Visible',
    '...',
    'Visible',
    '...',
    'Very Visible',
    '...',
    'Extreamly Visible',
    '...',
    'Very Visible',
    '...',
    'Visible',
    '...',
    'Barly Visible',
    '...',
    'Not Visible']

  light = new Light(15,text.length / 2,1)
  for y in [0..text.length-1]
    for x in [0..31]
      a = light.get_color(y,x)
      PS.BeadColor x,y, 256*(1-a/100) + 0 * (a/100),256*(1-a/100) + 0 * (a/100),256*(1-a/100) + 0 * (a/100)
    x = Math.floor((31-text[y].length) / (2))
    for l in text[y]
      PS.BeadGlyph x,y,l
      x = x+1

  for x in [0..31]
    PS.BeadColor x,text.length,Math.floor(255*x/31),Math.floor(255*x/31),Math.floor(255*x/31)
    PS.BeadBorderWidth(x,text.length,4)
    if G.bright == x / 16
      PS.BeadBorderColor(x,text.length,0xffff00)
    else
      PS.BeadBorderColor(x,text.length,0x000000)
    PS.BeadData PS.ALL,text.length, (x,y) ->
      G.bright = x / 16
      draw_bright()
  y = text.length + 2
  text = ' Enter the void. '
  x = Math.floor((31-text.length) / (2))
  for l in text
    PS.BeadColor x,y,0xffffff
    PS.BeadGlyphColor x,y,0x000000
    PS.BeadGlyph x,y,l
    PS.BeadData x,y, (x,y) ->
      PS.StatusText 'Trapped in the Void'
      PS.BeadBorderWidth PS.ALL,PS.ALL,0
      PS.BeadGlyph PS.ALL,PS.ALL,0
      G.mode = 'start'
      my_l.r = 0
      test_world.draw(my_l)

    x = x + 1


draw_map = () ->
  PS.ImageBlit(DNA.VOID.map)
  PS.BeadGlyph PS.ALL,PS.ALL,0
  PS.BeadBorderWidth PS.ALL,PS.ALL,0
  PS.BeadColor test_world.player.x,test_world.player.y,0x22aa00
  PS.BeadGlyphColor test_world.player.x,test_world.player.y,0x000000
  PS.BeadGlyph test_world.player.x,test_world.player.y,'↑' if test_world.player.fy == -1
  PS.BeadGlyph test_world.player.x,test_world.player.y,'↓' if test_world.player.fy == 1
  PS.BeadGlyph test_world.player.x,test_world.player.y,'←' if test_world.player.fx == -1
  PS.BeadGlyph test_world.player.x,test_world.player.y,'→' if test_world.player.fx == 1


  PS.BeadColor Monster.x,Monster.y,0x22aaff

  PS.BeadGlyphColor 2,1,0x000000
  PS.BeadGlyph 2,1,'✘' if G.levers[0]

  PS.BeadGlyphColor 2,1,0x000000
  PS.BeadGlyph 2,20,'✘' if G.levers[1]

  PS.BeadGlyphColor 2,1,0x000000
  PS.BeadGlyph 22,21,'✘' if G.levers[2]

  PS.BeadGlyphColor 2,1,0x000000
  PS.BeadGlyph 29,28,'✘' if G.levers[3]


move_moster = () ->
  px = test_world.player.x
  py = test_world.player.y
  mx = Monster.x
  my = Monster.y
  dest = {x: px,y: py}
  dest = {x: 15 + Math.floor(Math.random()*5),y:14 + Math.floor(Math.random()*5)} if my_l.r == 0 and G.mode != 'map'
  d = Math.sqrt(Math.pow(mx-px,2)+Math.pow(my-py,2))
  if d <= 5
    G.flicker.seq = ''
    while d >= 0
      for x in [0..Math.floor(Math.pow(1 + G.dificulty / 60,d))]
        if Math.random() > d/5
          G.flicker.seq += '1'
        else
          G.flicker.seq += '0'
      d -= 1


  PS.Debug '-----------------\n'
  PS.Debug px + ', ' + py + '\n'
  PS.Debug mx + ', ' + my + '\n'
  if mx == px and my == py
    G.GRID.HEIGHT = 0

    G.mode = 'die'
  else if (mx == dest.x and my == dest.y) == false
    good_xy = (x,y) ->
      return (x>=0 and y >= 0 and x < test_world.data.length and y < test_world.data[0].length)
    size = 1
    lowest = String(mx+','+my)
    goal = String(dest.x+','+dest.y)
    apple = { }
    h = Math.abs(dest.x - mx) + Math.abs(dest.y - my)
    apple[String(mx+','+my)] = {v: h, moves: 0,history: '',explored: false}

    while lowest != goal and size < 512
      size += 1
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
      if good_xy(x,y-1)
        north = Math.abs(dest.x - x) + Math.abs(dest.y - (y-1)) + m + 1 if test_world.data[y-1][x].standable
      if good_xy(x,y+1)
        south = Math.abs(dest.x - x) + Math.abs(dest.y - (y+1)) + m + 1 if test_world.data[y+1][x].standable
      if good_xy(x-1,y)
        west = Math.abs(dest.x - (x-1)) + Math.abs(dest.y - y) + m + 1 if test_world.data[y][x-1].standable
      if good_xy(x+1,y)
        east = Math.abs(dest.x - (x+1)) + Math.abs(dest.y - y) + m + 1 if test_world.data[y][x+1].standable

      apple[String(x+','+(y-1))] = {v: north, moves: m+1,history: hi+'n',explored: false} if north != -1 and (apple[String(x+','+(y-1))] is undefined or apple[String(x+','+(y-1))].v > north )
      apple[String(x+','+(y+1))] = {v: south, moves: m+1,history: hi+'s',explored: false} if south != -1 and (apple[String(x+','+(y+1))] is undefined or apple[String(x+','+(y+1))].v > south )
      apple[String((x+1)+','+y)] = {v: east, moves: m+1,history: hi+'e',explored: false} if east != -1 and (apple[String((x+1)+','+y)] is undefined or apple[String((x+1)+','+y)].v > east )
      apple[String((x-1)+','+y)] = {v: west, moves: m+1,history: hi+'w',explored: false} if west != -1 and (apple[String((x-1)+','+y)] is undefined or apple[String((x-1)+','+y)].v > west )

      lowest_v = 64*64
      options = []
      for node of apple
        if apple[node].v == lowest_v and apple[node].explored == false
          options.push(node)
        else if  apple[node].v < lowest_v and apple[node].explored == false
          options = [node]
          lowest_v = apple[node].v
      lowest = options[Math.floor(Math.random()*options.length)]
      if apple[lowest] == undefined
        break
    if apple[lowest] != undefined
      move = apple[lowest].history[0]
      dx = 0
      dy = 0
      dx = 1 if move == 'e'
      dx = -1 if move == 'w'
      dy = -1 if move == 'n'
      dy = 1 if move == 's'
      Monster.x = Monster.x + dx
      Monster.y = Monster.y + dy
      PS.AudioPlay 'perc_cymbal_crash4',1/Math.max(1,d)
      PS.AudioPlay 'fx_magnum',1/Math.max(1,d)
      test_world.draw(my_l) if G.mode != 'map'

draw_dealth = () ->
  PS.DebugClose()
  PS.StatusColor(0x000000)
  my_l.x = Math.floor((G.GRID.WIDTH-1)/ 2)
  my_l.y = Math.floor((G.GRID.WIDTH-1)/ 2)
  test_world.player.health = test_world.player.max_h
  test_world.player.max_b = (480 / G.GRID.WIDTH) / 2
  test_world.player.draw_heart(my_l.x,my_l.y)
  if test_world.player.beat == 0
    if G.GRID.HEIGHT <= 0
      G.GRID.WIDTH = Math.max(1,G.GRID.WIDTH - 2)
      G.GRID.HEIGHT = Math.max(1,G.GRID.WIDTH - 2)
      PS.GridSize G.GRID.WIDTH, G.GRID.HEIGHT
      PS.BeadFlash PS.ALL,PS.ALL,false
      PS.BeadColor PS.ALL,PS.ALL,0x000000
      PS.BeadData PS.ALL,PS.ALL,-1
      PS.BeadBorderWidth PS.ALL,PS.ALL,0
      PS.BeadBorderColor PS.ALL,PS.ALL,0x000000
      if G.GRID.WIDTH == 1
        PS.GridBGColor(0x8A0707)
        PS.BeadColor(0,0,0x8A0707)
        PS.AudioPlay 'fx_bang'
        PS.Clock 0
        G.mode = 'done'
    else
      G.GRID.HEIGHT -= 5



loader = (data) ->
  PS.Debug(" {width: #{String(data.width)}, height: #{String(data.height)}, pixelSize: #{String(data.pixelSize)}, data: [#{String(data.data)}]}")
  G.done_load = true

debug = (response) ->
  property_names = ""
  for propertyName of response
    ### propertyName is what you want###
    property_names += propertyName + " = " + response[propertyName] + "\n"
  alert property_names

###------------------------------------------ Global Vars ----------------------------------------- ###
w = DNA.VOID.brown_wall
m = DNA.VOID.white_wall
f = DNA.VOID.brown_floor

world_data = [
  # 0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,0,1
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w]), #0
  ([w,f,f,f,w,w,w,f,w,w,w,f,f,f,w,w,w,w,f,f,f,f,f,f,f,w,w,w,f,f,f,w]), #1
  ([w,f,f,f,w,w,f,f,f,w,w,f,f,f,w,w,w,w,f,f,f,f,f,f,f,f,f,f,f,f,f,w]), #2
  ([w,f,f,f,w,w,f,f,f,w,w,f,f,f,w,w,w,w,f,f,f,f,f,f,f,w,w,w,f,f,f,w]), #3
  ([w,w,f,w,w,w,w,f,w,w,w,w,f,w,w,w,w,w,w,f,w,w,w,w,w,w,w,w,w,f,w,w]), #4
  ([w,w,f,w,w,f,f,f,f,f,w,w,f,w,w,w,w,w,w,f,w,w,w,w,w,w,w,w,f,f,f,w]), #5
  ([w,w,f,f,f,f,f,f,f,f,f,f,f,w,w,w,w,w,w,f,w,w,w,w,w,w,w,w,f,f,f,w]), #6
  ([w,w,f,w,w,f,f,f,f,f,w,w,f,w,w,w,w,w,w,f,w,w,w,w,w,w,w,w,f,w,f,w]), #7
  ([w,w,f,w,w,w,w,w,w,w,w,w,f,w,w,w,w,w,f,f,f,w,f,f,f,f,f,w,f,f,f,w]), #8
  ([w,f,f,f,w,w,w,w,w,w,w,f,f,f,w,w,w,w,f,f,f,f,f,f,f,f,f,w,f,w,f,w]), #9
  ([w,f,f,f,w,f,f,f,f,f,w,f,f,f,w,w,w,w,f,f,f,w,f,f,f,f,f,w,f,f,f,w]), #0
  ([w,f,f,f,f,f,f,f,f,f,f,f,f,f,w,w,w,w,w,w,w,w,w,w,w,f,w,w,f,f,f,w]), #1
  ([w,f,f,f,w,f,f,f,f,f,w,f,f,f,w,w,w,w,w,w,w,w,w,w,w,f,w,w,w,f,w,w]), #2
  ([w,f,f,f,w,w,w,w,w,w,w,f,f,f,w,w,w,w,w,w,w,w,w,w,w,f,w,w,f,f,f,w]), #3
  ([w,w,f,w,w,w,w,w,w,w,w,w,f,w,w,f,f,f,f,f,w,w,w,w,w,f,w,w,f,f,f,w]), #4
  ([w,w,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,w,w,w,w,f,f,f,w,f,f,f,w]), #5
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,f,f,f,f,f,f,f,f,f,f,f,f,w,f,f,f,w]), #6
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,f,f,f,f,f,w,w,w,w,f,f,f,w,f,f,f,w]), #7
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,f,f,f,f,f,w,w,w,w,w,w,w,w,f,f,f,w]), #8
  ([w,w,f,f,f,w,f,f,f,f,f,w,w,w,w,w,w,f,w,w,w,w,w,w,w,w,w,w,w,f,w,w]), #9
  ([w,w,f,f,f,f,f,f,f,f,f,w,w,w,w,w,w,f,w,w,w,w,f,f,f,f,f,w,f,f,f,w]), #0
  ([w,w,f,f,f,w,f,f,f,f,f,w,w,w,w,w,w,f,w,w,w,w,f,f,f,f,f,f,f,f,f,w]), #1
  ([w,w,w,w,w,w,w,w,f,w,w,w,w,w,w,w,w,f,w,w,w,w,f,f,f,f,f,w,f,f,f,w]), #2
  ([w,w,f,f,f,w,f,f,f,f,f,w,w,w,w,w,f,f,f,w,w,w,w,w,w,w,w,w,w,f,w,w]), #3
  ([w,w,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,w,w,w,w,w,w,w,w,w,f,f,f,w]), #4
  ([w,w,f,f,f,w,f,f,f,f,f,w,w,w,w,w,f,f,f,w,w,w,w,w,w,w,w,w,f,f,f,w]), #5
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,f,f,f,w]), #6
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,f,f,f,w]), #7
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,f,f,f,w]), #8
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w]), #9
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w]), #0
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w,w])  #1
]
l_data = []#new Light(1,7,8,1)]
note_1 = new Obj(7,7,DNA.VOID.table)
note_1.interact = () ->
  PS.AudioPlay 'fx_swoosh'
  test_world.draw(my_l)
  PS.BeadBorderWidth PS.ALL,PS.ALL, 0
  my_l.x = 6
  my_l.y = 4
  G.mode = 'note'
  G.current_note = new Note('Day 3#They came from the darkness. One by one, our cities disappeared, lost to the blackness.##Curtis said that we’re all that’s left.  If we fail to hold this wall, the world will fall to ruin.## I hope he’s wrong, but some of the things I’ve seen make me believe$.$.$. Monsters as big as a city block$.$.$.$## Shit.  I can hear them.  They’re coming.')
  PS.ImageBlit(DNA.VOID.note)
note_2 = new Obj(19,1,DNA.VOID.table)
note_2.interact = () ->
  PS.AudioPlay 'fx_swoosh'
  test_world.draw(my_l)
  PS.BeadBorderWidth PS.ALL,PS.ALL, 0
  my_l.x = 6
  my_l.y = 4
  G.mode = 'note'
  G.current_note = new Note('Transcript of dialogue with Sgt.##James Walker:#Cpt.: Sergeant, tell me what you saw.#Walker: Can’t say. Won’t say.  Killed Thompson.  And Williams.  Now it’s coming for me.#Cpt: Calm down, Sergeant.  You’re safe here.#Sgt: Not safe! Never safe!  IT CAN SEE ME!#Cpt: That’s it. We’re done here.')
  PS.ImageBlit(DNA.VOID.note)
note_3 = new Obj(28,28,DNA.VOID.table)
note_3.interact = () ->
  PS.AudioPlay 'fx_swoosh'
  test_world.draw(my_l)
  PS.BeadBorderWidth PS.ALL,PS.ALL, 0
  my_l.x = 6
  my_l.y = 4
  G.mode = 'note'
  G.current_note = new Note('RE: Intelligence?##Captain, In response to your earlier question, no. The creatures seem to possess no individual sense of consciousness, and instead have evidenced a kind of hive mind.##This is both good and bad news for humanity.##I trust you understand the implications.')
  PS.ImageBlit(DNA.VOID.note)
note_4 = new Obj(26,16,DNA.VOID.table)
note_4.interact = () ->
  PS.AudioPlay 'fx_swoosh'
  test_world.draw(my_l)
  PS.BeadBorderWidth PS.ALL,PS.ALL, 0
  my_l.x = 6
  my_l.y = 4
  G.mode = 'note'
  G.current_note = new Note('They’re dead. They’re all dead. I watched the Captain get his guts torn out right in front of me.## Now I’m dying too. I can feel it creeping up on me. This will be my last epitaph.##I %%%    %$%  % %   %$$$% $$$$%')
  PS.ImageBlit(DNA.VOID.note)
note_5 = new Obj(17,25,DNA.VOID.table)
note_5.interact = () ->
  PS.AudioPlay 'fx_swoosh'
  test_world.draw(my_l)
  PS.BeadBorderWidth PS.ALL,PS.ALL, 0
  my_l.x = 6
  my_l.y = 4
  G.mode = 'note'
  G.current_note = new Note('They’re right outside. I can hear them. They’re right outside.##I’m going to die. I’m going to die.##No one left. No help coming.##I’m going to die.')
  PS.ImageBlit(DNA.VOID.note)

lever_1 = new Obj(2,1,DNA.VOID.lever_up)
lever_1.interact = () ->
  if G.levers[0]
    PS.AudioPlay 'fx_gun'
    G.levers[0] = false
    @data = DNA.VOID.lever_up
  else
    PS.AudioPlay 'fx_silencer'
    G.levers[0] = true
    @data = DNA.VOID.lever_down

lever_2 = new Obj(2,20,DNA.VOID.lever_up)
lever_2.interact = () ->
  if G.levers[1]
    PS.AudioPlay 'fx_gun'
    G.levers[1] = false
    @data = DNA.VOID.lever_up
  else
    PS.AudioPlay 'fx_silencer'
    G.levers[1] = true
    @data = DNA.VOID.lever_down
lever_3 = new Obj(22,21,DNA.VOID.lever_up)
lever_3.interact = () ->
  if G.levers[2]
    PS.AudioPlay 'fx_gun'
    G.levers[2] = false
    @data = DNA.VOID.lever_up
  else
    PS.AudioPlay 'fx_silencer'
    G.levers[2] = true
    @data = DNA.VOID.lever_down
lever_4 = new Obj(29,28,DNA.VOID.lever_up)
lever_4.interact = () ->
  if G.levers[3]
    PS.AudioPlay 'fx_gun'
    G.levers[3] = false
    lever_4.data = DNA.VOID.lever_up
  else
    PS.AudioPlay 'fx_silencer'
    G.levers[3] = true
    @data = DNA.VOID.lever_down
lever_f = new Obj(17,14,DNA.VOID.lever_up)
lever_f.interact = () ->
  if G.levers[0] and G.levers[1] and G.levers[2] and G.levers[2] and G.levers[3]
    PS.AudioPlay 'fx_silencer'
    G.levers[1] = false
    lever_f.data = DNA.VOID.lever_down
    G.mode = 'win'
  else
    PS.StatusText 'Not all primers switches are active.'
    PS.AudioPlay 'fx_gun'
    lever_f.data = DNA.VOID.lever_up

Monster = new Obj(16,16,DNA.VOID.monster)


o_data = [note_1,note_2,note_3,note_4,note_5,lever_1,lever_2,lever_3,lever_4,lever_f,Monster]
test_world = new World(world_data,7,1,0,1,l_data,o_data)
my_l = new Light(15,15,1)
p = new Player(3,3,1,0)
G =
  Tick: 0
  dificulty: 30
  won: false
  done_load: true
  GRID:
    WIDTH: 32
    HEIGHT: 32
  mode: 'brightness'
  bright: 1
  current_note: null
  levers: [false,false,false,false]
  lights: true
  flicker:
    seq: ''
  music:
    score: 0
    current_index: 0
    next_note: 0
    scrores: [
      (['15','13','12','13','15','12','10','12','13','12','10','12','13','10','011','10','15','13','15','12','15','10','15','011','08','011','15','13','15','13','10','13']),
      (['15','17','15','17','13','15','13','15','13','15','12','13','12','13','15','12','13','12','13','10','12','10','12','011','01','011','10','09','011','09','011','10','12','13','15','17','111','17','15'])
    ]
###------------------------------------------ PS Events ----------------------------------------- ###
PS.Init = ->
  PS.GridSize G.GRID.WIDTH, G.GRID.HEIGHT
  PS.BeadFlash PS.ALL,PS.ALL,false
  PS.BeadColor PS.ALL,PS.ALL,0x000000
  PS.BeadData PS.ALL,PS.ALL,-1
  PS.BeadBorderWidth PS.ALL,PS.ALL,0
  PS.BeadBorderColor PS.ALL,PS.ALL,0x000000
  PS.GridBGColor 0x0000
  PS.StatusFade false
  PS.StatusText 'Trapped in the Void'
  PS.StatusColor(0xffffff)
  #test_world.draw(my_l)

  PS.Clock 1

PS.Click = (x, y, data) ->
  "use strict"
  if G.mode == 'brightness'
    if typeof data == "function"
      data(x,y)
  else if G.mode == 'game'
    my_l.x = x
    my_l.y = y
    if my_l.r == 0
      my_l.r = 2
    else
      my_l.r = 0
    test_world.draw(my_l)
  else if G.mode == 'note'
    if G.current_note.auto_type.length > 0
      while G.current_note.auto_type.length > 0
        G.current_note.type(false)
    else
      PS.BeadGlyph PS.ALL,PS.ALL,0
      G.mode = 'game'
      test_world.draw(my_l)




PS.Release = (x, y, data) ->
  "use strict"

PS.Enter = (x, y, data) ->
  "use strict"
  if G.mode == 'game' or G.mode == 'brightness'
    PS.BeadBorderWidth my_l.x,my_l.y,0
    PS.BeadData my_l.x,my_l.y,-1
    my_l.x = x
    my_l.y = y
    test_world.draw(my_l) if G.mode == 'game'


PS.Leave = (x, y, data) ->
  "use strict"

  if G.mode == 'game' or G.mode == 'note'
    PS.BeadBorderWidth x,y,0
    PS.BeadData x,y,-1




PS.KeyDown = (key, shift, ctrl) ->
  "use strict"
  if key == 13
    PS.AudioPlay 'perc_cymbal_crash4'
    PS.AudioPlay 'fx_magnum'
    PS.ImageBlit(DNA.VOID.note)

PS.KeyUp = (key, shift, ctrl) ->
  "use strict"
  if G.mode == 'game'
    PS.StatusText 'Trapped in the Void'
    if key == 87 or key == 119
      if world_data[test_world.player.y + test_world.player.fy][test_world.player.x + test_world.player.fx].standable
        test_world.player.x += test_world.player.fx
        test_world.player.y += test_world.player.fy
    else if key == 83 or key == 115
      if world_data[test_world.player.y - test_world.player.fy][test_world.player.x - test_world.player.fx].standable
        test_world.player.x -= test_world.player.fx
        test_world.player.y -= test_world.player.fy
    else if key == 68 or key == 100
      px = test_world.player.x
      py = test_world.player.y
      mx = Monster.x
      my = Monster.y
      d = Math.sqrt(Math.pow(mx-px,2)+Math.pow(my-py,2))
      test_world.player.health = Math.min(test_world.player.max_h,test_world.player.health + Math.pow(0.25,d))
      tx = test_world.player.fx
      ty = test_world.player.fy
      test_world.player.fx = -1*ty
      test_world.player.fy = 1*tx
    else if key == 65 or key == 97
      px = test_world.player.x
      py = test_world.player.y
      mx = Monster.x
      my = Monster.y
      d = Math.sqrt(Math.pow(mx-px,2)+Math.pow(my-py,2))
      test_world.player.health = Math.min(test_world.player.max_h,test_world.player.health + Math.pow(0.25,d))
      tx = test_world.player.fx
      ty = test_world.player.fy
      test_world.player.fx = 1*ty
      test_world.player.fy = -1*tx
    else if key == 77 or key == 109
      G.mode = 'map'
    else if key == 32
      for obj in test_world.obj_data
        if test_world.player.x  == obj.y and test_world.player.y == obj.x
          obj.interact() if obj.interact != null
    #PS.Debug test_world.player.x + ', ' + test_world.player.y + ' | ' + test_world.light_data[0].x + ', ' + test_world.light_data[0].y + '\n'
    test_world.draw(my_l)
  else if G.mode == 'map'
    G.mode = 'game'
    test_world.draw(my_l)
  else if G.mode == 'note'
    if G.current_note.auto_type.length > 0
      while G.current_note.auto_type.length > 0
        G.current_note.type(false)
    else
      if G.won
        PS.StatusText 'Thanks for playing'
      G.mode = 'game'
      test_world.draw(my_l)
      PS.BeadGlyph PS.ALL,PS.ALL,0



PS.Wheel = (dir) ->
  "use strict"

PS.Tick = ->
  "use strict"
  G.Tick += 1
  if G.Tick >= G.music.next_note
    i = G.music.scrores[G.music.score][G.music.current_index]

    oc = 4 + Number(i[0])
    i = i.substr(1)
    n = Number(i)
    PS.AudioPlay(DNA_MUSIC.Piano_l[oc][n]) if G.music.score == 0
    PS.AudioPlay(DNA_MUSIC.Piano[oc][n]) if G.music.score == 1
    G.music.next_note = G.Tick + 15 if G.music.score == 0
    G.music.next_note = G.Tick + 3 if G.music.score == 1

    G.music.current_index = (G.music.current_index+1)%G.music.scrores[G.music.score].length
  if G.mode == 'brightness'
    draw_bright()
  else if G.mode == 'start'
    PS.BeadFlash PS.ALL,PS.ALL,false
    PS.BeadColor PS.ALL,PS.ALL,0x000000
    PS.BeadData PS.ALL,PS.ALL,-1
    PS.BeadBorderWidth PS.ALL,PS.ALL,0
    PS.BeadBorderColor PS.ALL,PS.ALL,0x000000
    PS.GridBGColor 0x0000
    PS.StatusFade false
    PS.StatusText 'Trapped in the Void'
    PS.StatusColor(0xffffff)
    my_l.x = 6
    my_l.y = 4
    G.current_note = new Note("The world is engulfed in darkness. Outside a couple safe zones, nothing remains but the endless night. And now, the dark is closing in. Your safe house's defense system failed, so you had to move to another. Find and activate the four primer switches so you can turn the defense grid on. Other survivors may have left notes along your path.######But hurry,#because you are#   not alone$$.$$$.$$$$$.")
    G.mode = 'note'
  else if G.mode == 'win'
    PS.BeadFlash PS.ALL,PS.ALL,false
    PS.BeadColor PS.ALL,PS.ALL,0x000000
    PS.BeadData PS.ALL,PS.ALL,-1
    PS.BeadBorderWidth PS.ALL,PS.ALL,0
    PS.BeadBorderColor PS.ALL,PS.ALL,0x000000
    PS.GridBGColor 0x0000
    PS.StatusFade false
    PS.StatusText 'Trapped in the Void'
    PS.StatusColor(0xffffff)
    my_l.x = 6
    my_l.y = 4
    G.current_note = new Note("I don’t know if anyone’s still alive out there$.$$.$$$. I don’t know if anyone could possibly be alive, after all that’s happened. Whenever I look out the window, all I see is the neverending storm and the tide of darkness that washes over our world. But if, by some miracle or freak of chance, someone out there is hearing this$.$$.$$$. the defense system is on. Gunnarson’s plan worked. I’m safe$.$$.$$$.#for now.")
    G.mode = 'note'
    G.won = true
    test_world.obj_data.pop()
  else if G.mode == 'die'
    draw_dealth()
  else
    test_world.player.draw_heart(my_l.x,my_l.y)
    if G.Tick % 6 == 0
      if G.mode == 'note'
        PS.ImageBlit(DNA.VOID.note)  if PS.BeadColor(7,4) != 0xE0E0C7
        G.current_note.type(true)
      if G.mode == 'map' and PS.BeadColor(test_world.player.x,test_world.player.y) != 0x22aa00
        my_l.x = 17
        my_l.y = 12
        draw_map()
    if G.mode == 'game' or G.mode == 'map'
      if G.flicker.seq.length > 0
        G.mode = 'game'
        G.lights = G.flicker.seq[0] == '1'
        G.flicker.seq = G.flicker.seq.substr(1)
        test_world.draw(my_l)
      else
        G.lights = true

    if G.Tick % G.dificulty == 0 and (G.mode == 'game' or G.mode == 'map')
      move_moster() unless G.won





### END OF GAME CODE ###