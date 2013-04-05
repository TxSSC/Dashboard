class Dashing.Stalker extends Dashing.Widget
  @accessor 'users', ->
    @sort(@get 'data')

  sort: (users) ->
    users.sort (a, b) ->
      if a.name > b.name
        return 1
      if a.name < b.name
        return -1
      return 0