NaturalLanguageUnderstandingV1 = require('watson-developer-cloud/natural-language-understanding/v1.js')
natural_language_understanding = new NaturalLanguageUnderstandingV1(
    'username': Meteor.settings.private.language.username
    'password': Meteor.settings.private.language.password
    'version_date': '2017-02-27')

Meteor.methods 
    call_watson: (parameters, doc_id) ->
        natural_language_understanding.analyze parameters, Meteor.bindEnvironment((err, response) ->
            if err
                console.log 'error:', err
            else
                keyword_array = _.pluck(response.keywords, 'text')
                lowered_keywords = keyword_array.map (tag)-> tag.toLowerCase()
                # console.dir response
                Docs.update { _id: doc_id }, 
                    $set:
                        watson: response
                        watson_keywords: lowered_keywords
                        doc_sentiment_score: response.sentiment.document.score
                        doc_sentiment_label: response.sentiment.document.label
            return
        )
        
        # Meteor.call 'create_transaction', 'tk5W7DukuCZjB7262', doc_id
        
        return
        
        
