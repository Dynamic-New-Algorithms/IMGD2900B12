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
    @diff = 1.6

  get_color: (x,y,scale) ->
    scale = scale * @diff
    d = Math.sqrt(Math.pow((x-@x),2)+Math.pow((y-@y),2)) * (1/scale)
    d = (1/scale)*@diff if d == 0
    a = 0
    a = 1-1/(d/@r*(1/scale)) if (d/@r*(1/scale)) > 0
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
      @healeth = (@health + 2/3) / 2
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
    for ply in light_offsets

      sx = @player.y+ply.po
      h_left = 0
      h_right = 0
      sy = @player.x+ply.l
      v_up = 0
      v_down = 0
      if sx >=0 and sx < @data.length
        if sy >= 0 and sy <  @data[sx].length
          #PS.Debug("#{ply.level},#{ply.pos} ---- (#{sx},#{sy})\n")
          #h
          while sx-h_left > 0
            h_left = h_left + 1
            if @data[sx-h_left][sy][ply.level][ply.pos].wall != null
              break
          while sx+h_right < @data.length-1
            h_right = h_right + 1
            if @data[sx+h_right][sy][ply.level][ply.pos].wall != null
              break
          #v
          while sy-v_up > 0
            v_up = v_up + 1
            if @data[sx][sy-v_up][ply.level][ply.pos].wall != null
              break

          while sy+v_down <  @data[sx].length-1
            v_down = v_down + 1
            if @data[sx][sy+v_down][ply.level][ply.pos].wall != null
              break

          #PS.Debug((sx-h_left) + " \<= x \<= " + (sx+h_right) + ' and ' + (sy-v_up) + " \<= y \<= " + (sy+v_down) + '\n')
          for x in [(sx-h_left)..(sx+h_right)]
            for y in [(sy-v_up)..(sy+v_down)]

              #done witch diagonal checking
              if true
                d = Math.max(1,Math.sqrt(Math.pow((sx-x),2)+Math.pow((sy-y),2)))
                offsets[ply_count].lights.push([x,y,d])
                #PS.Debug(String([x,y,d])+'\n')
      ply_count += 1


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
                  for light_pos in ply.lights
                    dddddd = dddddd + ' Yurp ]; ' if @data[light_pos[0]][light_pos[1]].lights.length > 0
                    dddddd = dddddd + ' Nope ]; ' if @data[light_pos[0]][light_pos[1]].lights.length == 0
                    for al in @data[light_pos[0]][light_pos[1]].lights
                      if @player.fx == 1 or @player.fy == 1
                        no_light = false
                        light_a = light_a - (100-al.get_color(x,y,1/light_pos[2]))
                      else if @player.fx == -1 or @player.fy == -1
                        no_light = false
                        light_a = light_a - (100-al.get_color(32-x,y,1/light_pos[2]))
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
    PS.BeadBorderColor my_light.x,my_light.y,PS.BeadColor(my_light.x,my_light.y)
    PS.BeadBorderWidth my_light.x,my_light.y,0
    PS.BeadData my_light.x,my_light.y,-1



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
f = DNA.VOID.brown_floor
debug(w.alpha.left.floor)
world_data = [
  ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w]),
  ([w,f,f,f,f,w,f,f,f,f,f,f,f,f,w]),
  ([w,f,f,w,w,f,w,w,w,w,w,w,w,f,w]),
  ([w,f,w,f,f,f,f,f,f,f,f,w,w,f,w]),
  ([w,f,w,w,w,w,w,w,w,w,f,w,f,f,w]),
  ([w,f,w,f,f,f,f,f,w,w,f,w,w,f,w]),
  ([w,f,f,f,f,w,f,f,w,w,f,f,f,f,w]),
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
    my_l.r = 1
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