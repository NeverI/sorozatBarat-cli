require! \rx
require! \../site
require! \cheerio
require! \./season

export load = (aSeries) ->
  site
    .get aSeries.uri
    .then (body) ->
      $ = cheerio.load body
      aSeries.seasons = parse-seasons $ if not aSeries.seasons

      activeSeasonUri = $ '.seasons .active a' .attr \href
      aSeries
        .seasons
        .filter -> it.uri is activeSeasonUri
        .do -> season.parse it, $
        .subscribe!

      return aSeries

parse-seasons = ($) ->
  rx.Observable
    .from $('.seasons a').map (i, item) ->
      uri: item.attribs.href
      title: $ item .text!

