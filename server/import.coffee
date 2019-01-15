# unirest = require('unirest') 


# Meteor.methods
#     imdb: (iid)->
#         # console.log unirest
#         unirest.get("https://innocentabi-imdb-grabber-v1.p.rapidapi.com/imdb/#{iid}").header('X-RapidAPI-Key', 'MwkK2zjrEFmsh75gjcFekcmnQgUfp1V3vYjjsns5chPqEsUmAH').end (result) ->
#             console.log result.status, result.headers, result.body
            
    
    
#     famous_quote: ()->
#         unirest.post('https://andruxnet-random-famous-quotes.p.rapidapi.com/?count=10&cat=famous').header('X-RapidAPI-Key', 'MwkK2zjrEFmsh75gjcFekcmnQgUfp1V3vYjjsns5chPqEsUmAH').header('Content-Type', 'application/x-www-form-urlencoded').end Meteor.bindEnvironment((result) ->
#             for quote in result.body
#                 new_quote_doc = Docs.findOne quote
                
#                 unless new_quote_doc
#                     quote_id = Docs.insert quote
#                     console.log 'added quote', quote
#                 else
#                     console.log 'existing quote', quote
#         )       

    
#     movie_quote: ()->
#         unirest.post('https://andruxnet-random-famous-quotes.p.rapidapi.com/?count=10&cat=movies').header('X-RapidAPI-Key', 'MwkK2zjrEFmsh75gjcFekcmnQgUfp1V3vYjjsns5chPqEsUmAH').header('Content-Type', 'application/x-www-form-urlencoded').end Meteor.bindEnvironment((result) ->
#             for quote in result.body
#                 console.log quote
#                 new_quote_doc = Docs.findOne quote
                
#                 unless new_quote_doc
#                     quote_id = Docs.insert quote
#                     console.log 'added quote', quote
#                 else
#                     console.log 'existing quote', quote
#         )