SyncedCron.config
    log: true
    collectionName: 'cron_history'
    utc: false
    collectionTTL: 17280

# if Meteor.isProduction
SyncedCron.add(
    {
        name: 'famous quotes'
        schedule: (parser) ->
            parser.text 'every 10 seconds'
        job: ->
            console.log 'pulling 10 famous quotes'
            Meteor.call 'movie_quote', (err,res)->
                if err then console.error err
    }
    {
        name: 'field crawler'
        schedule: (parser) ->
            parser.text 'every 1 hour'
        job: ->
            console.log 'crawling doc fields'
            Meteor.call 'movie_quote', (err,res)->
                if err then console.error err
    }
)


# if Meteor.isProduction
# SyncedCron.start()
