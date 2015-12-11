require! \querystring

siteUrl = undefined
loggedInRequest = undefined

export login = (url) ->
  require! \request
  siteUrl := url
  loggedInRequest := request.defaults jar: true

  require! '../auth.json'
  auth[\redirect] = '/'
  auth[\loginsubmit] = true

  new Promise (resolve, reject) ->
    loggedInRequest.post do
      uri: "#{url}/login"
      body: querystring.stringify auth
      headers: 'content-type': 'application/x-www-form-urlencoded'
      , handleResponse resolve, reject

handleResponse = (resolve, reject) ->
  (err, res, body) ->
    return reject err if err
    resolve body

request = (method, uri) -->
  url = "#{siteUrl}/#{uri}"
  if typeof uri is \string
    uri = url
  else
    uri.uri = url

  new Promise (resolve, reject) ->
    loggedInRequest[method] uri, handleResponse resolve, reject


export get = request 'get'
export post = request 'post'
