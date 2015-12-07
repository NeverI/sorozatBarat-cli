require! 'request'
auth = require './auth.json'
auth['redirect'] = '/'
auth['loginsubmit'] = true

url = 'http://www.sorozat-barat.info'

request = request.defaults jar: true
request.post do
  uri: "#{url}/login"
  body: require('querystring').stringify(auth)
  headers: 'content-type': 'application/x-www-form-urlencoded'
  , (err, res, body) ->
    return console.log err if err
    require('./src/collectUnseenEpisodes') url, request
