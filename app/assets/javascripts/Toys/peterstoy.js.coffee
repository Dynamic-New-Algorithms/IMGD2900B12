jQuery ->
  if jQuery('#name').html() == 'PetersToy'

    PS.Init = ->
      "use strict"

      # change to the dimensions you want
      PS.GridSize 1, 1
      PS.StatusText "Peter's Piano"
      PS.Clock 90


    PS.Click = (x, y, data) ->
      "use strict"

    PS.Release = (x, y, data) ->
      "use strict"


    PS.Enter = (x, y, data) ->
      "use strict"


    PS.Leave = (x, y, data) ->
      "use strict"

    PS.KeyDown = (key, shift, ctrl) ->
      "use strict"
      if key is 81
        PS.AudioPlay "piano_a3"
        PS.BeadColor 0, 0, 0x00ffff
        PS.BeadGlyph 0, 0, 0
      else if key is 87
        PS.AudioPlay "piano_b3"
        PS.BeadColor 0, 0, 0x00000F
        PS.BeadGlyph 0, 0, 0
      else if key is 69
        PS.AudioPlay "piano_c4"
        PS.BeadColor 0, 0, 0x0000FF
        PS.BeadGlyph 0, 0, 0
      else if key is 82
        PS.AudioPlay "piano_d4"
        PS.BeadColor 0, 0, 0xF00000
        PS.BeadGlyph 0, 0, 0
      else if key is 84
        PS.AudioPlay "piano_e4"
        #0xRRGGBB
        PS.BeadColor 0, 0, 0xFF0000
        PS.BeadGlyph 0, 0, 0
      else if key is 89
        PS.AudioPlay "piano_f4"
        PS.BeadColor 0, 0, 0xFFF000
        PS.BeadGlyph 0, 0, 0
      else if key is 85
        PS.AudioPlay "piano_g4"
        PS.BeadColor 0, 0, 0xFFFF00
        PS.BeadGlyph 0, 0, 0
      else if key is 73
        PS.AudioPlay "piano_a4"
        PS.BeadColor 0, 0, 0xFFFFF0
        PS.BeadGlyph 0, 0, 0
      else if key is 65
        PS.AudioPlay "piano_a3"
        PS.AudioPlay "piano_db4"
        PS.AudioPlay "piano_e4"
        PS.BeadGlyph 0, 0, "A"
      else if key is 83
        PS.AudioPlay "piano_b3"
        PS.AudioPlay "piano_eb4"
        PS.AudioPlay "piano_gb4"
        PS.BeadGlyph 0, 0, "B"
      else if key is 68
        PS.AudioPlay "piano_c4"
        PS.AudioPlay "piano_e4"
        PS.AudioPlay "piano_c5"
        PS.BeadGlyph 0, 0, "C"
      else if key is 70
        PS.AudioPlay "piano_d4"
        PS.AudioPlay "piano_gb4"
        PS.AudioPlay "piano_a4"
        PS.BeadGlyph 0, 0, "D"
      else if key is 71
        PS.AudioPlay "piano_e4"
        PS.AudioPlay "piano_ab4"
        PS.AudioPlay "piano_b4"
        PS.BeadGlyph 0, 0, "E"
      else if key is 72
        PS.AudioPlay "piano_f4"
        PS.AudioPlay "piano_c5"
        PS.AudioPlay "piano_a5"
        PS.BeadGlyph 0, 0, "F"
      else if key is 74
        PS.AudioPlay "piano_a4"
        PS.AudioPlay "piano_db5"
        PS.AudioPlay "piano_e5"
        PS.BeadGlyph 0, 0, "A"


    PS.KeyUp = (key, shift, ctrl) ->
      "use strict"


    PS.Wheel = (dir) ->
      "use strict"


    PS.Tick = ->
      "use strict"
      PS.AudioPlay "perc_drum_bass", 0.7
