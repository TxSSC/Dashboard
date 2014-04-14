class Dashing.Weather extends Dashing.Widget
  @accessor "temperature", ->
    if @get('weather')?.temp_f?
      "#{@get('weather').temp_f}"

  ready: ->
    @renderImage()
    setInterval(@startTime, 1000)

  onData: ->
    @renderImage()

  startTime: =>
    today = new Date()

    h = today.getHours()
    m = today.getMinutes()
    p = if h < 12 then 'am' else 'pm'
    @set('meridian', p)
    @set('date', @formatDate(today))
    @set('time', "#{@formatHour(h)}:#{@formatTime(m)}")

  formatTime: (i) ->
    if i < 10 then "0" + i else i

  formatHour: (h) ->
    h = h % 12
    if h is 0 then 12 else h

  formatDate: (d) ->
    weekday = switch d.getDay()
      when 0 then "Sunday"
      when 1 then "Monday"
      when 2 then "Tuesday"
      when 3 then "Wednesday"
      when 4 then "Thursday"
      when 5 then "Friday"
      when 6 then "Saturday"

    month = switch d.getMonth()
      when 0 then "January"
      when 1 then "Febuary"
      when 2 then "March"
      when 3 then "April"
      when 4 then "May"
      when 5 then "June"
      when 6 then "July"
      when 7 then "August"
      when 8 then "September"
      when 9 then "October"
      when 10 then "November"
      when 11 then "December"

    "#{weekday} #{month} #{d.getDate()}, #{d.getFullYear()}"

  renderImage: ->
    if @get('weather')?.icon?
      el = $(@node).find('.weather')
      el.html(@getImage(@get('weather').icon))

  getImage: (cond) ->
    switch cond.toLowerCase()
      when 'cloudy'
        WeatherIcons.cloudy()
      when 'tstorms', 'chancetstorms'
        WeatherIcons.thunderStorms()
      when 'sunny', 'clear'
        WeatherIcons.clear()
      when 'snow', 'chancesnow'
        WeatherIcons.snow()
      when 'sleet', 'flurries', 'chancesleet', 'chanceflurries'
        WeatherIcons.sleet()
      when 'rain', 'chancerain'
        WeatherIcons.rain()
      when 'partlycloudy', 'mostlysunny'
        WeatherIcons.partlyCloudy()
      when 'partlysunny', 'mostlycloudy'
        WeatherIcons.mostlyCloudy()
      when 'hazy'
        WeatherIcons.hazy()
      when 'fog'
        WeatherIcons.fog()
      else
        WeatherIcons.unknown()
