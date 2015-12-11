require! \rx
require! \./site
require! \cheerio
require! \./season

export load = (data) ->
  site
    .get seria.uri
    .then (body) ->
      $ = cheerio.load body
      data.seasons = parse-seasons $
      last-season = data.seasons.last!

parse-seasons = ($) ->
  rx.Observable
    .from $ '.seasons a' .map (i, elem) ->
      uri: elem.attribs.href
      name: elem.text!

