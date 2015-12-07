require! 'cheerio'

module.exports = (url, request) ->
  request "#{url}/notification", (err, res, body) ->
      return console.log err if err

      $ = cheerio.load body
      $ '.series .title a' .each (i, elem) ->
        request "#{url}/#{elem.attribs.href}", (err, res, body) ->
          return console.log err if err

          $ = cheerio.load body
          episodes = $ 'a.watched'
          unseen =  episodes.length - episodes.filter '.active' .length
          return if not unseen or unseen is episodes.length
          console.log $('h2.navTitle').text!, 'unseen: ', unseen,  'episodes: ', episodes.length
