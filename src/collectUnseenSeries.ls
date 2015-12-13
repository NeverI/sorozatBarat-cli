require! \rx
require! \./watchlist

export only-started = ->
  interested-series -> it.watched and it.watched isnt it.total
    .toArray!
    .subscribe do
      ->
        it.sort ((a, b) -> (a.total - a.watched) - (b.total - b.watched))
          ..map ->
            console.log "#{it.title}: #{it.watched}/#{it.total}"
      , ->
        console.log if it.stack then it.stack else it

interested-series = (predicate) ->
  watchlist
    .get-series!
    .flatMap (aSeries) ->
      aSeries
        .seasons
        .last!
        .flatMap -> it.episodes
        .reduce (p, v) ->
          p.watched += if v.watched => 1 else 0
          p.total++
          return p
        , total: 0, watched: 0, title: aSeries.title
        .filter predicate

export only-new = ->
  interested-series -> not it.watched
    .toArray!
    .subscribe do
      ->
        it.sort ((a, b) -> a.total - b.total)
          ..map ->
            console.log "#{it.title}: #{it.total}"
      , ->
        console.log if it.stack then it.stack else it
