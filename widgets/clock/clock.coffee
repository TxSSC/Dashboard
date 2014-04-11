class Dashing.Clock extends Dashing.Widget

  ready: ->
    date = new Date()
    paper = Raphael(@node.getElementsByClassName("canvas")[0], 600, 600)
    R = 200
    init = true
    xorig = 300
    yorig = 240
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
    html =
      hour: $(@node).find(".time .hour")
      minute: $(@node).find(".time .minute")
      second: $(@node).find(".time .second")
      meridian: $(@node).find(".time .meridian")
      month: $(@node).find(".time .month")
      day: $(@node).find(".time .day")

    paper.customAttributes.arc = (value, total, R) ->
      alpha = 360 / total * value
      a = (90 - alpha) * Math.PI / 180
      x = xorig + R * Math.cos(a)
      y = yorig - R * Math.sin(a)
      color = "hsb(".concat(Math.round(R) / 200, ",", value / total, ", .75)")
      path = null
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
      html[id].html(((if value < 10 then "0" else "")) + ((if value is 60 then "00" else value)))
      html[id].css({ color: Raphael.getRGB(color).hex })
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
      h = d.getHours() % 12 or 12
      updateVal(d.getSeconds(), 60, 200, arcs[0], "second")
      updateVal(d.getMinutes(), 60, 160, arcs[1], "minute")
      updateVal(h, 12, 120, arcs[2], "hour")
      updateVal(d.getDate(), 31, 80, arcs[3], "month")
      updateVal(d.getMonth() + 1, 12, 40, arcs[4], "day")
      html["meridian"].html(if d.getHours() < 12 then "AM" else "PM")
      setTimeout arguments.callee, 1000
      init = false
