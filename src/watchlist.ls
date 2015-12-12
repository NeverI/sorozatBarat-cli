require! \rx
require! \./site
require! \./seria
require! \cheerio

series = undefined

export get-series = ->
  return series if series

  series = new rx.ReplaySubject()

  site
    .get \/notification
    .then (body) ->
      $ = cheerio.load body
      $ '.series .title a' .each (i, elem) ->
        series.on-next do
          uri: elem.attribs.href
          title: elem.children.0.data

      series.on-completed!

  return series.flatMap -> seria.load it
