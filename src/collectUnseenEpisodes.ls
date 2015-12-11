require! 'cheerio'
require! \./site

module.exports = ->
  site
    .get '/notification'
    .then (body) ->
      $ = cheerio.load body
      $ '.series .title a' .each (i, elem) ->
        site
          .get elem.attribs.href
          .then (body) ->
            $ = cheerio.load body
            episodes = $ 'a.watched'
            unseen =  episodes.length - episodes.filter '.active' .length
            return if not unseen or unseen is episodes.length
            console.log $('h2.navTitle').text!, 'unseen: ', unseen,  'episodes: ', episodes.length
