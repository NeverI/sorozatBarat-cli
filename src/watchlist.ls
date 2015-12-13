require! \rx
require! \./site
require! \cheerio
require! './series': seriesModule

series = undefined

export get-series = ->
  return series if series

  series = new rx.ReplaySubject()

  site
    .get \/notification
    .then (body) ->
      $ = cheerio.load body
      $ '.series .title a' .each (i, item) ->
        series.on-next do
          uri: item.attribs.href
          title: $ item .text!

      series.on-completed!

  return series.flatMap -> seriesModule.load it
