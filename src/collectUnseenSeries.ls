require! \rx
require! \./model/series
require! \./model/watchlist

export only-started = ->
  interested-series -> it.watched and it.watched isnt it.total
    .toArray!
    .toPromise!
    .then ->
      it.sort ((a, b) -> (a.total - a.watched) - (b.total - b.watched))
        ..map ->
          console.log "#{it.title}: #{it.watched}/#{it.total}"

interested-series = (predicate) ->
  watchlist
    .get-series!
    .flatMap -> series.load it if not it.seasons
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
    .toPromise!
    .then ->
      it.sort ((a, b) -> a.total - b.total)
        ..map ->
          console.log "#{it.title}: #{it.total}"
