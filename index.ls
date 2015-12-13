require! \./src/site

require(\./src/requestCache) .wrap site

site
  .login \http://www.sorozat-barat.info
  .then ->
    require \./src/collectUnseenSeries .only-started!
  .catch (err) ->
    console.log if err.stack then err.stack else err
