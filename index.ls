require \livescript
require! \./src/site

require(\./src/requestCache) .wrap site

site
  .login \http://www.sorozat-barat.info
  .then ->
    console.log \buu
    require \./src/watchlist .series!
  .catch (err) ->
    console.log if err.stack then err.stack else err
