ToneAnalyzerV3 = require('watson-developer-cloud/tone-analyzer/v3')
# VisualRecognitionV3 = require('watson-developer-cloud/visual-recognition/v3')
NaturalLanguageUnderstandingV1 = require('watson-developer-cloud/natural-language-understanding/v1.js')
PersonalityInsightsV3 = require('watson-developer-cloud/personality-insights/v3')

tone_analyzer = new ToneAnalyzerV3(
    username: Meteor.settings.private.tone.username
    password: Meteor.settings.private.tone.password
    version_date: '2017-09-21')

natural_language_understanding = new NaturalLanguageUnderstandingV1(
    username: Meteor.settings.private.language.username
    password: Meteor.settings.private.language.password
    version_date: '2017-02-27')

# visual_recognition = new VisualRecognitionV3(
#     version:'2018-03-19'
#     api_key: Meteor.settings.private.visual.api_key)

personality_insights = new PersonalityInsightsV3(
    username: Meteor.settings.private.personality.username
    password: Meteor.settings.private.personality.password
    version_date: '2017-10-13')

Meteor.methods
    call_personality: (doc_id)->
        self = @
        doc = Docs.findOne doc_id
        if doc.html
            params =
                content: doc.html,
                content_type: 'text/html',
                consumption_preferences: true,
                raw_scores: false
            personality_insights.profile params, Meteor.bindEnvironment((err, response)->
                if err
                    # console.log err
                    Docs.update { _id: doc_id},
                        $set:
                            personality: false
                else
                    # console.dir response
                    Docs.update { _id: doc_id},
                        $set:
                            personality: response
                    # console.log(JSON.stringify(response, null, 2))
            )
        else return 
        
        
    call_tone: (doc_id)->
        self = @
        doc = Docs.findOne doc_id
        # console.log doc.html
        if doc.html
            # stringed = JSON.stringify(doc.html, null, 2)
            params =
                text:doc.html
                content_type:'text/html'
            tone_analyzer.tone params, Meteor.bindEnvironment((err, response)->
                if err
                    console.log err
                else
                    # console.dir response
                    Docs.update { _id: doc_id},
                        $set:
                            tone: response
                    # console.log(JSON.stringify(response, null, 2))
            )
        else return 
        
    call_visual: (doc_id)->
        self = @
        doc = Docs.findOne doc_id
        if doc.image_id
            params =
                url:"https://res.cloudinary.com/facet/image/upload/#{doc.image_id}"
                # images_file: images_file
                # classifier_ids: classifier_ids
            visual_recognition.classify params, Meteor.bindEnvironment((err, response)->
                if err
                    console.log err
                else
                    Docs.update { _id: doc_id},
                        $set:
                            visual: response.images[0].classifiers[0].classes
                    # console.log(JSON.stringify(response.images[0].classifiers[0].classes[0].class, null, 2))
            )
        else return 
        
    call_watson: (doc_id) ->
        # console.log 'calling watson'
        self = @
        doc = Docs.findOne doc_id
        if doc.html
            parameters = 
                html: doc.html
                features:
                    entities:
                        emotion: false
                        sentiment: false
                        # limit: 2
                    keywords:
                        emotion: false
                        sentiment: false
                        # limit: 2
                    concepts: {}
                    # categories: {}
                    emotion: {}
                    # # metadata: {}
                    # relations: {}
                    # semantic_roles: {}
                    sentiment: {}

            natural_language_understanding.analyze parameters, Meteor.bindEnvironment((err, response) ->
                if err
                    console.log 'error:', err
                else
                    # console.log response
                    keyword_array = _.pluck(response.keywords, 'text')
                    lowered_keywords = keyword_array.map (keyword)-> keyword.toLowerCase()
                    
                    concept_array = _.pluck(response.concepts, 'text')
                    lowered_concepts = concept_array.map (concept)-> concept.toLowerCase()
                    Docs.update { _id: doc_id }, 
                        $set:
                            watson: response
                            watson_concepts: lowered_concepts
                            watson_keywords: lowered_keywords
                            doc_sentiment_score: response.sentiment.document.score
                            doc_sentiment_label: response.sentiment.document.label
                return
            )
            Meteor.call 'call_tone', doc_id, ->
            Meteor.call 'call_personality', doc_id, ->
        return
        

    pull_site: (doc_id, url)->
        this_id = doc_id
        doc = Docs.findOne doc_id
        # console.log url
        parameters = 
            url: url
            features:
                entities:
                    emotion: false
                    sentiment: false
                    # limit: 2
                keywords:
                    emotion: false
                    sentiment: false
                    # limit: 2
                concepts: {}
                # categories: {}
                emotion: {}
                # metadata: {}
                # relations: {}
                # semantic_roles: {}
                sentiment: {}
            return_analyzed_text: true

        natural_language_understanding.analyze parameters, Meteor.bindEnvironment((err, response) =>
            if err
                console.log 'error:', err
            else
                console.log response
                keyword_array = _.pluck(response.keywords, 'text')
                lowered_keywords = keyword_array.map (keyword)-> keyword.toLowerCase()
                
                concept_array = _.pluck(response.concepts, 'text')
                lowered_concepts = concept_array.map (concept)-> concept.toLowerCase()
                Docs.update {_id:this_id},
                    $set:
                        # schema:'website'
                        watson: response
                        watson_keywords: lowered_keywords
                        watson_concepts: lowered_concepts
                        doc_sentiment_score: response.sentiment.document.score
                        doc_sentiment_label: response.sentiment.document.label
                        html: response.analyzed_text
        )