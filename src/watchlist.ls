require! \rx
require! \./site
require! \cheerio
require! \./seria


series = undefined

sorted-series =
  news: undefined
  starteds: undefined

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

  return series

export get-news = ->
  return sorted-series.news if sorted-series.news
  sort-series get-series! .news

export get-starteds = ->
  return sorted-series.starteds if sorted-series.starteds
  sort-series get-series! .starteds

export sort-series = (series) ->
  return sorted-series if sorted-series

  sorted-series =
    news: new rx.ReplaySubject()
    starteds: new rx.ReplaySubject()

  serias.each (seria-data) ->
    seria
      .load seria-data
      .then (parsed-seria) ->
        if parsed-seria.seasons.last!seen
          sorted-serias.started.on-next parsed-seria
        else
          sorted-serias.news.on-next parsed-seria

  sorted-series

