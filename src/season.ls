require! \rx
require! \./site
require! \cheerio

export load = (season) ->
  site
    .get season.uri
    .then (body) ->
      $ = cheerio.load body
      parse season, $

export parse = (season, $) ->
  return season if season.episodes

  season.episodes = rx.Observable.zip do
    rx.Observable.from $ '.episodes > li > a'
    rx.Observable.from $ '.episodes .watched'
  .map ([episodeData, watchedData]) ->
    episodeData = $ episodeData
    uri: episodeData.attr \herf
    title: episodeData.text!
    watched: $(watchedData).hasClass \active

  return season
