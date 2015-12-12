require! \rx
require! \./site
require! \cheerio
require! \./season

export load = (seria) ->
  site
    .get seria.uri
    .then (body) ->
      $ = cheerio.load body
      seria.seasons = parse-seasons $ if not seria.seasons

      activeSeasonUri = $ '.seasons .active a' .attr \href
      seria
        .seasons
        .filter -> it.uri is activeSeasonUri
        .do -> season.parse it, $
        .subscribe!

      return seria

parse-seasons = ($) ->
  rx.Observable
    .from $('.seasons a').map (i, elem) ->
      uri: elem.attribs.href
      title: $ elem .text!

