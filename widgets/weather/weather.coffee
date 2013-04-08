class Dashing.Weather extends Dashing.Widget
  @accessor 'image', ->
      return @get('weather')?.weather

  ready: ->
    setInterval(@startTime, 1000)

  startTime: =>
    today = new Date()

    h = today.getHours()
    m = today.getMinutes()
    p = if h < 12 then 'am' else 'pm'
    @set('time', @formatHour(h) + ":" + @formatTime(m))
    @set('date', today.toDateString())
    @set('post', p)

  formatTime: (i) ->
    if i < 10 then "0" + i else i

  formatHour: (h) ->
    h = h % 12
    if h is 0 then 12 else h