require! \rx
require! \../site
require! \cheerio

export load = (episode) ->
  site
    .get episode.uri
    .then (body) ->
      $ = cheerio.load body
      parse episode, $

parse = (episode, $) ->
  episode.uploads = rx.Observable.from do
    $ '#hosts tr' .filter ->
      $ @ .find 'td' .length is 5
  .map ->
    item = $ it
    url: item.find 'td:last-child a' .attr \href
    title: item.children!eq 1 .text!toLowerCase!replace /^([\w.-]+)#?\s?.+$/, '$1'
    lang: item.find 'td:first-child img:first-child' .attr \src .replace /^.+\/(.+)\.png$/, '$1'
    views: parseInt(item.children!eq 2 .text!replace /^(\d+).+/, '$1')

  return episode
