require! \fs

dir = \/tmp

request = (func, url) -->
  path = "#{dir}/#{cleanup url}"
  isExists path
    .then (exists) ->
      return read path if exists

      func url
        .then (content) ->
          write path, content

cleanup = (url) ->
  url.replace /[.:\/]/g, '_'

isExists = (path) ->
  new Promise (resolve, reject) ->
    fs.access path, fs.R_OK, (err) ->
      resolve !err

read  = (path) ->
  new Promise (resolve, reject) ->
    fs.readFile path, \utf8, (err, content) ->
      return reject err if err
      resolve content

write = (path, content) ->
  new Promise (resolve, reject) ->
    fs.writeFile path, content, (err) ->
      return reject err if err
      resolve content

export wrap = (subject) !->
  for own prop of subject
    subject[prop] = request subject[prop]
