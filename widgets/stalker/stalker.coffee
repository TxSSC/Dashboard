class Dashing.Stalker extends Dashing.Widget

  onData: (data) ->
    @set 'users', @sort(data.users)
    console.dir(@get('users'))

  sort: (users) ->
    users.sort (a, b) ->
      if a.returning?.length
        return -1
      if a.name < b.name
        return 0
      return 1