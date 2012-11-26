### oppen to puplic use
    Dynamic New Algorithms
    William Decker
    Peter Lepper
###

class Light
  constructor: (x,y,r) ->
    @x = x
    @y = y
    @r = r

  get_color: (x,y,scale) ->
    d = Math.sqrt(Math.pow((x-@x),2)+Math.pow((y-@y),2))
    a = 0
    a = 1-10/(d/@r*scale) if (d/@r*scale) > 0
    a = 1 if d == 0 and @r*scale < 0.1
    return Math.min(100,Math.max(0,a*100))

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
    @light = new Light(15,15,2)

  draw_heart: (x,y) ->
    @beat += @health
    if @beat >= 138
      @high_low = 0
      @beat = 0
    if @beat >= 68 and @high_low == 0
      PS.AudioPlay 'perc_drum_tom3'
      @high_low = 1
    if @beat >= 89 and @high_low == 1
      PS.AudioPlay 'perc_drum_tom4'
      @high_low = 2
    if PS.BeadData(x,y) == -1
      PS.BeadData x,y,PS.BeadColor(x,y)
    PS.BeadBorderColor x,y,PS.BeadData(x,y)
    PS.BeadColor x,y,Math.floor(100*(1-this.get_heart_size(@beat)))+125,0,Math.floor(20*(this.get_heart_size(@beat)))
    PS.BeadBorderWidth x,y,Math.floor((1-this.get_heart_size(@beat)) * 5)

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
  constructor: (data,sx,sy,sfx,sfy) ->
    @player = new Player(sx,sy,sfx,sfy)
    @data = data

  draw: (my_light) ->
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
    for ply in offsets
      ply.lights.push(ply_count)
      v1 = false
      v2 = false
      h1 = false
      h2 = false
      ply_h1 = light_offsets[(ply_count + 1)%light_offsets.length]
      ply_h1 = light_offsets[(ply_count - 1)%light_offsets.length] if ply_count%3 != 0
      
      ply_h2 = light_offsets[(ply_count + 2)%light_offsets.length]
      ply_h2 = light_offsets[(ply_count + 1)%light_offsets.length] if ply_count%3 == 1
      ply_h2 = light_offsets[(ply_count - 2)%light_offsets.length] if ply_count%3 == 2
      
      ply_v1 = light_offsets[((ply_count + 3)%light_offsets.length)%light_offsets.length]
      
      ply_v2 = light_offsets[((ply_count + 6)%light_offsets.length)%light_offsets.length]

      ply_d1 = light_offsets[((ply_count + 3)%light_offsets.length + 1)%light_offsets.length]
      ply_d1 = light_offsets[((ply_count + 3)%light_offsets.length - 1)%light_offsets.length] if ply_count%3 != 0

      ply_d2 = light_offsets[((ply_count + 3)%light_offsets.length + 2)%light_offsets.length]
      ply_d2 = light_offsets[((ply_count + 3)%light_offsets.length + 1)%light_offsets.length] if ply_count%3 == 1
      ply_d2 = light_offsets[((ply_count + 3)%light_offsets.length - 2)%light_offsets.length] if ply_count%3 == 2
      
      ply_d3 = light_offsets[((ply_count + 6)%light_offsets.length + 1)%light_offsets.length]
      ply_d3 = light_offsets[((ply_count + 6)%light_offsets.length - 1)%light_offsets.length] if ply_count%3 != 0

      ply_d4 = light_offsets[((ply_count + 6)%light_offsets.length + 2)%light_offsets.length]
      ply_d4 = light_offsets[((ply_count + 6)%light_offsets.length + 1)%light_offsets.length] if ply_count%3 == 1
      ply_d4 = light_offsets[((ply_count + 6)%light_offsets.length - 2)%light_offsets.length] if ply_count%3 == 2

      #h1
      if @player.y+ply_h1.po >= 0 and @player.y+ply_h1.po < @data.length
        if @player.x+ply_h1.l >= 0 and @player.x+ply_h1.l < @data[@player.y+ply_h1.po].length
          offsets[(ply_count + 1)%offsets.length].lights.push(ply_count) if ply_count%3 == 0
          offsets[(ply_count - 1)%offsets.length].lights.push(ply_count) if ply_count%3 != 0
          h1 =  @data[@player.y+ply_h1.po][@player.x+ply_h1.l][ply_h1.level][ply_h1.pos].wall == null
      #h2
      if @player.y+ply_h2.po >= 0 and @player.y+ply_h2.po < @data.length
        if @player.x+ply_h2.l >= 0 and @player.x+ply_h2.l < @data[@player.y+ply_h2.po].length
          if ply.pos == 'center' or h1
            offsets[(ply_count + 2)%offsets.length].lights.push(ply_count) if ply_count%3 == 0
            offsets[(ply_count + 1)%offsets.length].lights.push(ply_count) if ply_count%3 == 1
            offsets[(ply_count - 2)%offsets.length].lights.push(ply_count) if ply_count%3 == 2
          h2 =  @data[@player.y+ply_h2.po][@player.x+ply_h2.l][ply_h2.level][ply_h2.pos].wall == null
          h2 = h2 and h1 if ply.pos != 'center'
      #v1  
      if @player.y+ply_v1.po >= 0 and @player.y+ply_v1.po < @data.length
        if @player.x+ply_v1.l >= 0 and @player.x+ply_v1.l < @data[@player.y+ply_v1.po].length
          if ply.level != 'alpha'
            offsets[((ply_count + 3)%offsets.length)].lights.push(ply_count)
            v1 = @data[@player.y+ply_v1.po][@player.x+ply_v1.l][ply_v1.level][ply_v1.pos].wall == null
          else
            if @player.y+ply_v2.po >= 0 and @player.y+ply_v2.po < @data.length
              if @player.x+ply_v2.l >= 0 and @player.x+ply_v2.l < @data[@player.y+ply_v2.po].length
                if @data[@player.y+ply_v2.po][@player.x+ply_v2.l][ply_v2.level][ply_v2.pos].wall == null
                  offsets[((ply_count + 3)%offsets.length)].lights.push(ply_count)
                  v1 =  @data[@player.y+ply_v1.po][@player.x+ply_v1.l][ply_v1.level][ply_v1.pos].wall == null and @data[@player.y+ply_v2.po][@player.x+ply_v2.l][ply_v2.level][ply_v2.pos].wall == null
      #v2    
      if @player.y+ply_v2.po >= 0 and @player.y+ply_v2.po < @data.length
        if @player.x+ply_v2.l >= 0 and @player.x+ply_v2.l < @data[@player.y+ply_v2.po].length
          if ply.level != 'gama' or v1
            offsets[((ply_count + 6)%offsets.length)].lights.push(ply_count)
          v2 =  @data[@player.y+ply_v2.po][@player.x+ply_v2.l][ply_v2.level][ply_v2.pos].wall == null
          v2 = v2 and v1 if ply.level == 'gama'
      #d1 
      if @player.y+ply_d1.po >= 0 and @player.y+ply_d1.po < @data.length
        if @player.x+ply_d1.l >= 0 and @player.x+ply_d1.l < @data[@player.y+ply_d1.po].length
          if h1 or v1
            offsets[((ply_count + 3)%offsets.length + 1)%offsets.length].lights.push(ply_count) if ply_count%3 == 0
            offsets[((ply_count + 3)%offsets.length - 1)%offsets.length].lights.push(ply_count) if ply_count%3 != 0
      #d2
      if @player.y+ply_d2.po >= 0 and @player.y+ply_d2.po < @data.length
        if @player.x+ply_d2.l >= 0 and @player.x+ply_d2.l < @data[@player.y+ply_d2.po].length
          if h2 or v1
            offsets[((ply_count + 3)%offsets.length + 2)%offsets.length].lights.push(ply_count) if ply_count%3 == 0
            offsets[((ply_count + 3)%offsets.length + 1)%offsets.length].lights.push(ply_count) if ply_count%3 == 1
            offsets[((ply_count + 3)%offsets.length - 2)%offsets.length].lights.push(ply_count) if ply_count%3 == 2
      #d3   
      if @player.y+ply_d3.po >= 0 and @player.y+ply_d3.po < @data.length
        if @player.x+ply_d3.l >= 0 and @player.x+ply_d3.l < @data[@player.y+ply_d3.po].length
          if h1 or v2
            offsets[((ply_count + 6)%offsets.length + 1)%offsets.length].lights.push(ply_count) if ply_count%3 == 0
            offsets[((ply_count + 6)%offsets.length - 1)%offsets.length].lights.push(ply_count) if ply_count%3 != 0
      #d4 
      if @player.y+ply_d4.po >= 0 and @player.y+ply_d4.po < @data.length
        if @player.x+ply_d4.l >= 0 and @player.x+ply_d4.l < @data[@player.y+ply_d4.po].length
          if h2 or v1
            offsets[((ply_count + 6)%offsets.length + 2)%offsets.length].lights.push(ply_count) if ply_count%3 == 0
            offsets[((ply_count + 6)%offsets.length + 1)%offsets.length].lights.push(ply_count) if ply_count%3 == 1
            offsets[((ply_count + 6)%offsets.length - 2)%offsets.length].lights.push(ply_count) if ply_count%3 == 2
      ply_count = ply_count + 1
      

    for y in [0..31]
      for x in [0..31]
        c = {r:0, g:0, b:0,a:100}
        my_light_a = my_light.get_color(x,y,1)
        #PS.Debug x + ', ' + y + ' = ' + c.r + ', '+ c.g + ', '+ c.b + ' -> '
        for ply in offsets

          for type in ['floor','roof','wall']
            if @player.y+ply.po >= 0 and @player.y+ply.po < @data.length
              if @player.x+ply.l >= 0 and @player.x+ply.l < @data[@player.y+ply.po].length
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
                  for light in ply.lights
                    light = light % light_offsets.length
                    dddddd = dddddd + '(' + light_offsets[light].level + ', ' + light_offsets[light].pos + ')['
                    if @player.y+light_offsets[light].po >= 0 and @player.y+light_offsets[light].po < @data.length
                      if @player.x+light_offsets[light].l >= 0 and @player.x+light_offsets[light].l < @data[@player.y+light_offsets[light].po].length
                        dddddd = dddddd + ' Yurp ]; ' if @data[@player.y+light_offsets[light].po][@player.x+light_offsets[light].l].lights.length > 0
                        dddddd = dddddd + ' Nope ]; ' if @data[@player.y+light_offsets[light].po][@player.x+light_offsets[light].l].lights.length == 0
                        for al in @data[@player.y+light_offsets[light].po][@player.x+light_offsets[light].l].lights
                          no_light = false
                          if ply.level == 'alpha'
                            light_a = light_a - (100-al.get_color(x,y,3/3))
                          else if ply.level == 'beta'
                            light_a = light_a - (100-al.get_color(x,y,2/3))
                          else if ply.level == 'gama'
                            light_a = light_a - (100-al.get_color(x,y,1/3))

                  #alert dddddd + ' || ' + no_light
                  light_a = light_a - (100-my_light_a)
                  light_a = Math.min(Math.max(0,light_a),100)
                  #light_a = 100 if no_light
                  #PS.Debug  light_a
                  c.r = c.r*(1-light_a/100) + 0*(light_a/100) unless new_c_r == 0 and new_c_g == 0 and new_c_b == 0 # or new_c_a != 100
                  c.g = c.g*(1-light_a/100) + 0*(light_a/100) unless new_c_r == 0 and new_c_g == 0 and new_c_b == 0 # or new_c_a != 100
                  c.b = c.b*(1-light_a/100) + 0*(light_a/100) unless new_c_r == 0 and new_c_g == 0 and new_c_b == 0 # or new_c_a != 100
          #PS.Debug  ' -> ' + c.r + ', '+ c.g + ', '+ c.b + '\n'
        img.data.push Math.floor(c.r)
        img.data.push Math.floor(c.g)
        img.data.push Math.floor(c.b)
        img.data.push Math.floor(c.a)
    PS.ImageBlit(img)



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
w = DNA.VOID.example_wall
f = DNA.VOID.example_floor
l = DNA.VOID.example_light
l.lights.push(new Light(10,10,1))

world_data = [
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w]),
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w]),
  ([w,w,w,w,w,f,w,w,w,w,w,w,w,w,w]),
  ([w,w,w,f,f,l,f,f,f,f,f,w,w,w,w]),
  ([w,w,w,w,w,w,w,w,w,w,f,w,w,w,w]),
  ([w,w,w,f,f,f,f,f,w,w,f,w,w,w,w]),
  ([w,w,w,f,l,w,f,f,w,w,f,w,w,w,w]),
  ([w,w,w,f,f,f,f,f,w,w,f,w,w,w,w]),
  ([w,w,w,w,w,w,w,f,f,f,f,w,w,w,w]),
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w]),
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w])
]
test_world = new World(world_data,3,3,1,0)
my_l = new Light(15,15,1)
p = new Player(3,3,1,0)
G =
  done_load: true
  GRID:
    WIDTH: 32
    HEIGHT: 32
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
  PS.StatusText 'Stuck in the Void: toy 8'
  PS.StatusColor(0xffffff)
  test_world.draw(my_l)

  PS.Clock 1

PS.Click = (x, y, data) ->
  "use strict"
  my_l.x = x
  my_l.y = y
  if my_l.r == 0
    my_l.r = 0.5
  else
    my_l.r = 0
  test_world.draw(my_l)


PS.Release = (x, y, data) ->
  "use strict"

PS.Enter = (x, y, data) ->
  "use strict"
  my_l.x = x
  my_l.y = y

  test_world.draw(my_l)

PS.Leave = (x, y, data) ->
  "use strict"
  PS.BeadBorderWidth x,y,0
  PS.BeadData x,y,-1

PS.KeyDown = (key, shift, ctrl) ->
  "use strict"

PS.KeyUp = (key, shift, ctrl) ->
  "use strict"
  if key == 87 or key == 119
    if world_data[test_world.player.y + test_world.player.fy][test_world.player.x + test_world.player.fx].standable
      test_world.player.x += test_world.player.fx
      test_world.player.y += test_world.player.fy
  else if key == 83 or key == 115
    if world_data[test_world.player.y - test_world.player.fy][test_world.player.x - test_world.player.fx].standable
      test_world.player.x -= test_world.player.fx
      test_world.player.y -= test_world.player.fy
  else if key == 68 or key == 100
    tx = test_world.player.fx
    ty = test_world.player.fy
    test_world.player.fx = -1*ty
    test_world.player.fy = 1*tx
  else if key == 65 or key == 97
    tx = test_world.player.fx
    ty = test_world.player.fy
    test_world.player.fx = 1*ty
    test_world.player.fy = -1*tx


  PS.Debug '(' + test_world.player.x + ',' + test_world.player.y + ') -> ' + test_world.player.fx + ',' + test_world.player.fy + '\n'

  test_world.draw(my_l)

PS.Wheel = (dir) ->
  "use strict"
  my_l.r = my_l.r + dir*0.1
  my_l.r = Math.max(0,my_l.r)

  test_world.draw(my_l)

PS.Tick = ->
  "use strict"
  test_world.player.draw_heart(my_l.x,my_l.y)



### END OF GAME CODE ###