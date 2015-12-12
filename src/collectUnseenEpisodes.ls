require! \rx
require! \./watchlist

export only-started = ->
  interested-serias -> it.watched and it.watched isnt it.total
    .toArray!
    .subscribe ->
      it.sort ((a, b) -> (a.total - a.watched) - (b.total - b.watched))
        ..map ->
          console.log "#{it.title}: #{it.total - it.watched}/#{it.total}"

interested-serias = (predicate) ->
  watchlist
    .get-series!
    .flatMap (seria) ->
      seria
        .seasons
        .last!
        .flatMap -> it.episodes
        .reduce (p, v) ->
          p.watched += if v.watched => 1 else 0
          p.total++
          return p
        , total: 0, watched: 0, title: seria.title
        .filter predicate

export only-new = ->
  interested-serias -> not it.watched
    .toArray!
    .subscribe ->
      it.sort ((a, b) -> a.total - b.total)
        ..map ->
          console.log "#{it.title}: #{it.total}"
