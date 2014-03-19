class Dashing.Clock extends Dashing.Widget

  ready: ->
    date = new Date()
    paper = Raphael("holder", 600, 600)
    R = 200
    init = true
    xorig = 300
    yorig = 300
    circle = paper.circle(xorig, yorig, 215).attr(
      fill: "#222"
      stroke: "#333"
    )
    param =
      stroke: "#fff"
      "stroke-width": 30

    pm = paper.circle(xorig, yorig, 16).attr(
      stroke: "none"
      fill: Raphael.hsb2rgb(15 / 200, 1, .75).hex
    )
    arcs = []
    html = [
      document.getElementById("h")
      document.getElementById("m")
      document.getElementById("s")
      document.getElementById("d")
      document.getElementById("mnth")
      document.getElementById("ampm")
    ]
    html[5].style.color = Raphael.hsb2rgb(15 / 200, 1, .75).hex


    paper.customAttributes.arc = (value, total, R) ->
      alpha = 360 / total * value
      a = (90 - alpha) * Math.PI / 180
      x = xorig + R * Math.cos(a)
      y = yorig - R * Math.sin(a)
      color = "hsb(".concat(Math.round(R) / 200, ",", value / total, ", .75)")
      path = undefined
      if total is value
        path = [
          [
            "M"
            xorig
            yorig - R
          ]
          [
            "A"
            R
            R
            0
            1
            1
            xorig - 0.01
            yorig - R
          ]
        ]
      else
        path = [
          [
            "M"
            xorig
            yorig - R
          ]
          [
            "A"
            R
            R
            0
            +(alpha > 180)
            1
            x
            y
          ]
        ]
      path: path
      stroke: color


    updateVal = (value, total, R, hand, id) ->
      if total is 31 # month
        d = new Date()
        d.setDate 1
        d.setMonth d.getMonth() + 1
        d.setDate -1
        total = d.getDate()
      color = "hsb(".concat(Math.round(R) / 200, ",", value / total, ", .75)")
      if init
        hand.animate
          arc: [
            value
            total
            R
          ]
        , 900, ">"
      else
        if not value or value is total
          value = total
          hand.animate
            arc: [
              value
              total
              R
            ]
          , 750, "bounce", ->
            hand.attr arc: [
              value
              total
              R
            ]
            return

        else
          hand.animate
            arc: [
              value
              total
              R
            ]
          , 750, "ease-in"
      html[id].innerHTML = ((if value < 10 then "0" else "")) + ((if value > 12 then value % total else value))
      html[id].style.color = Raphael.getRGB(color).hex
      return

    i = 0

    while i < 5
      arcs.push paper.path().attr(param).attr(arc: [
        0
        60
        R - 40 * i
      ])
      i++

    redraw = do ->
      d = new Date()
      am = (d.getHours() < 12)
      h = d.getHours() % 12 or 12
      updateVal d.getSeconds(), 60, 200, arcs[0], 2
      updateVal d.getMinutes(), 60, 160, arcs[1], 1
      updateVal h, 12, 120, arcs[2], 0
      updateVal d.getDate(), 31, 80, arcs[3], 3
      updateVal d.getMonth() + 1, 12, 40, arcs[4], 4
      pm[((if am then "hide" else "show"))]()
      html[5].innerHTML = (if am then "AM" else "PM")
      setTimeout arguments.callee, 1000
      init = false