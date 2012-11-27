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

  get_color: (x,y) ->
    d = Math.sqrt(Math.pow((x-@x),2)+Math.pow((y-@y),2))
    a = 0
    a = 1-1/(d/@r) if (d/@r) >= 1
    return {r: 0,g: 0,b: 0,a: a}

class Player
  constructor: (x,y,fx,fy) ->
    @x = x
    @y = y
    @fx = fx
    @fy = fy
    @health = 2
    @beat = 0
    @mx = 15
    @my = 15
    @sound = 0
    @light = new Light(15,15,2)

  draw_heart: () ->
    @beat += @health
    if @beat >= 138
      @sound = 0
      @beat = 0
    if @beat >= 68 and @sound == 0
      PS.AudioPlay 'perc_drum_tom3'
      @sound = 1
    if @beat >= 89 and @sound == 1
      PS.AudioPlay 'perc_drum_tom4'
      @sound = 2

    PS.BeadColor 1,1,Math.floor(100*(1-this.get_heart_size(@beat)))+125,0,Math.floor(20*(this.get_heart_size(@beat)))
    PS.BeadBorderWidth 1,1,Math.floor((1-this.get_heart_size(@beat)) * 50)

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



loader = (data) ->
  PS.Debug(" {width: #{String(data.width)}, height: #{String(data.height)}, pixelSize: #{String(data.pixelSize)}, data: [#{String(data.data)}]}")
  G.done_load = true

debug = (response) ->
  property_names = ""
  for propertyName of response
    ### propertyName is what you want###
    property_names += propertyName + " = " + response[propertyName] + "\n"
  alert property_names

draw_room = () ->
  PS.DebugClear()
  if p.fx == 1
    img = {width: 32, height: 32, pixelSize: 4, data: []}
    l = 2
    for level in ['gama','beta','alpha']
      po = -1
      for pos in ['left','center','right']
        PS.Debug '('+(p.x+l)+','+(p.y+po)+') '+ level + ', ' + pos + ' is ' + world_data[p.y+po][p.x+l].name + '\n'
        for type in ['floor','roof','wall']
          PS.ImageBlit world_data[p.y+po][p.x+l][level][pos][type] if world_data[p.y+po][p.x+l][level][pos][type] != null
        po += 1
      l -= 1
  else if p.fx == -1
    img = {width: 32, height: 32, pixelSize: 4, data: []}
    l = 2
    for level in ['gama','beta','alpha']
      po = 1
      for pos in ['left','center','right']
        PS.Debug '('+(p.x-l)+','+(p.y+po)+') '+ level + ', ' + pos + ' is ' + world_data[p.y+po][p.x-l].name + '\n'
        for type in ['floor','roof','wall']
          PS.ImageBlit world_data[p.y+po][p.x-l][level][pos][type] if world_data[p.y+po][p.x-l][level][pos][type] != null
        po -= 1
      l -= 1
  else if p.fy == -1
    img = {width: 32, height: 32, pixelSize: 4, data: []}
    l = 2
    for level in ['gama','beta','alpha']
      po = -1
      for pos in ['left','center','right']
        PS.Debug '('+(p.x+po)+','+(p.y-l)+') '+ level + ', ' + pos + ' is ' + world_data[p.y-l][p.x+po].name + '\n'
        for type in ['floor','roof','wall']
          PS.ImageBlit world_data[p.y-l][p.x+po][level][pos][type] if world_data[p.y-l][p.x+po][level][pos][type] != null
        po += 1
      l -= 1
  else if p.fy == 1
    img = {width: 32, height: 32, pixelSize: 4, data: []}
    l = 2
    for level in ['gama','beta','alpha']
      po = 1
      for pos in ['left','center','right']
        PS.Debug '('+(p.x+po)+','+(p.y+l)+') '+ level + ', ' + pos + ' is ' + world_data[p.y+l][p.x+po].name + '\n'
        for type in ['floor','roof','wall']
          PS.ImageBlit world_data[p.y+l][p.x+po][level][pos][type] if world_data[p.y+l][p.x+po][level][pos][type] != null
        po -= 1
      l -= 1

###------------------------------------------ Global Vars ----------------------------------------- ###
w = DNA.VOID.example_wall
f = DNA.VOID.example_floor

world_data = [
                ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w]),
                ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w]),
                ([w,w,w,w,w,f,w,w,w,w,w,w,w,w,w]),
                ([w,w,w,f,f,f,f,f,f,f,f,w,w,w,w]),
                ([w,w,w,w,f,w,w,w,w,w,f,w,w,w,w]),
                ([w,w,w,w,f,f,f,f,w,w,f,w,w,w,w]),
                ([w,w,w,f,f,w,f,f,w,w,f,w,w,w,w]),
                ([w,w,w,w,f,f,f,f,w,w,f,w,w,w,w]),
                ([w,w,w,w,w,w,w,f,f,f,f,w,w,w,w]),
                ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w]),
                ([w,w,w,w,w,w,w,w,w,w,w,w,w,w,w])
             ]
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
  PS.BeadBorderWidth PS.ALL,PS.ALL,0
  PS.BeadBorderColor PS.ALL,PS.ALL,0x000000
  PS.GridBGColor 0x0000
  PS.StatusFade false
  PS.StatusText 'Stuck in the Void: toy 7'
  PS.StatusColor(0xffffff)
  draw_room()

  PS.Clock 1

PS.Click = (x, y, data) ->
  "use strict"
  PS.DebugClear()

  PS.ImageLoad "/assets/Void/test_alpha.png", loader,4



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
  if key == 87 or key == 119
    if world_data[p.y + p.fy][p.x + p.fx].standable
      p.x += p.fx
      p.y += p.fy
  else if key == 83 or key == 115
    if world_data[p.y - p.fy][p.x - p.fx].standable
      p.x -= p.fx
      p.y -= p.fy
  else if key == 68 or key == 100
    tx = p.fx
    ty = p.fy
    p.fx = -1*ty
    p.fy = 1*tx
  else if key == 65 or key == 97
    tx = p.fx
    ty = p.fy
    p.fx = 1*ty
    p.fy = -1*tx


  PS.Debug key + '\n'

  draw_room()

PS.Wheel = (dir) ->
  "use strict"

PS.Tick = ->
  "use strict"



### END OF GAME CODE ###