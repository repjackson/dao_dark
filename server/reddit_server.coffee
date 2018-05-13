# ToneAnalyzerV3 = require('watson-developer-cloud/tone-analyzer/v3');
# VisualRecognitionV3 = require('watson-developer-cloud/visual-recognition/v3');
# NaturalLanguageUnderstandingV1 = require('watson-developer-cloud/natural-language-understanding/v1.js')
# PersonalityInsightsV3 = require('watson-developer-cloud/personality-insights/v3');

# tone_analyzer = new ToneAnalyzerV3(
#     username: Meteor.settings.private.tone.username
#     password: Meteor.settings.private.tone.password
#     version_date: '2017-09-21'
#     )


# natural_language_understanding = new NaturalLanguageUnderstandingV1(
#     username: Meteor.settings.private.language.username
#     password: Meteor.settings.private.language.password
#     version_date: '2017-02-27')

# visual_recognition = new VisualRecognitionV3(
#     version:'2018-03-19'
#     api_key: Meteor.settings.private.visual.api_key)

# personality_insights = new PersonalityInsightsV3(
#     username: Meteor.settings.private.personality.username
#     password: Meteor.settings.private.personality.password
#     version_date: '2017-10-13')

Meteor.methods
    call_reddit: (subreddit)->
        response = HTTP.get('http://reddit.com/r/' + subreddit + '.json')
        # return response.content
        
        _.each(response.data.data.children, (item)-> 
            data = item.data
            len = 200

            reddit_post =
                reddit_id: data.id
                url: data.url
                domain: data.domain
                comment_count: data.num_comments
                permalink: data.permalink
                title: data.title
                selftext: false
                thumbnail: false
                site: 'reddit'
                type: 'reddit'
                
            # console.log reddit_post
            existing_doc = Docs.findOne reddit_id:data.id
            unless existing_doc
                new_reddit_post_id = Docs.insert reddit_post
                Meteor.call 'get_reddit_post', new_reddit_post_id, data.id
                
        )
        
    get_reddit_post: (doc_id, reddit_id)->
        HTTP.get "http://reddit.com/by_id/t3_#{reddit_id}.json", (err,res)->
            if err then console.error err
            else
                if res.data.data.children[0].data.selftext
                    Docs.update doc_id, 
                        $set: html: res.data.data.children[0].data.selftext
                if res.data.data.children[0].data.url
                    Docs.update doc_id, 
                        $set: reddit_url: res.data.data.children[0].data.url
                # Docs.update doc_id, 
                #     $set: reddit_data: res.data.data.children[0].data
                # console.log res.data.children[0].data.selftext
#     {  
#   "kind":"Listing",
#   "data":{  
#       "modhash":"dj4zcvwvpv12ce724b7a1e2e6fbeac92985a7a78b9ea222cc9",
#       "dist":1,
#       "children":[  
#          {  
#             "kind":"t3",
#             "data":{  
#               "approved_at_utc":null,
#               "subreddit":"technology",
#               "selftext":"We have posted this before, but this needs to be reiterated.\n\nWe understand that many of you are emotionally driven to discuss your feelings on recent events, most notably the repeal of Net Neutrality - however inciting violence towards others is never ok. It is upsetting that we even have to post this. \n\nDo we enjoy banning people for these types of offences? No... Many of us feel as if the system has failed and want some form of repercussion. But threats of violence and harassment are not the answer here.\n\nAnd to be clear - here are some examples of what will get you banned:\n\n&gt; I hope this PoS dies in a car fire\n\n&gt; I want to punch him in the face til his teeth fall out\n\nAnd if you are trying to be slick by using this form\n\n&gt; I never condone violence but...\n\n&gt; I would never say he should die but...\n\n&gt; Im not one to wish death upon but...\n\n\nLet's keep the threads civil.\n\n**If you violate this rule, you will be banned for 30 days, no exceptions** ",

        
        
        # self = @
        # doc = Docs.findOne doc_id
        # if doc.incident_details
        #     params =
        #         content: doc.incident_details,
        #         content_type: 'text/plain',
        #         consumption_preferences: true,
        #         raw_scores: false
        #     personality_insights.profile params, Meteor.bindEnvironment((err, response)->
        #         if err
        #             # console.log err
        #             Docs.update { _id: doc_id},
        #                 $set:
        #                     personality: false
        #         else
        #             # console.dir response
        #             Docs.update { _id: doc_id},
        #                 $set:
        #                     personality: response
        #             # console.log(JSON.stringify(response, null, 2))
        #     )
        # else return 
        
        
#     call_tone: (doc_id)->
#         self = @
#         doc = Docs.findOne doc_id
#         # console.log doc.incident_details
#         if doc.incident_details
#             # stringed = JSON.stringify(doc.incident_details, null, 2)
#             params =
#                 text:doc.incident_details
#                 content_type:'text/plain'
#             tone_analyzer.tone params, Meteor.bindEnvironment((err, response)->
#                 if err
#                     console.log err
#                 else
#                     # console.dir response
#                     Docs.update { _id: doc_id},
#                         $set:
#                             tone: response
#                     # console.log(JSON.stringify(response, null, 2))
#             )
#         else return 
        
        
        
        
#     call_visual: (doc_id)->
#         self = @
#         doc = Docs.findOne doc_id
#         if doc.image_id
#             params =
#                 url:"https://res.cloudinary.com/facet/image/upload/#{doc.image_id}"
#                 # images_file: images_file
#                 # classifier_ids: classifier_ids
#             visual_recognition.classify params, Meteor.bindEnvironment((err, response)->
#                 if err
#                     console.log err
#                 else
#                     Docs.update { _id: doc_id},
#                         $set:
#                             visual: response.images[0].classifiers[0].classes
#                     # console.log(JSON.stringify(response.images[0].classifiers[0].classes[0].class, null, 2))
#             )
#         else return 
        
#     call_watson: (doc_id) ->
#         # console.log 'calling watson'
#         self = @
#         doc = Docs.findOne doc_id
#         if doc.incident_details
#             parameters = 
#                 # 'html': doc.content
#                 text: doc.incident_details
#                 features:
#                     entities:
#                         emotion: true
#                         sentiment: true
#                         # limit: 2
#                     keywords:
#                         emotion: true
#                         sentiment: true
#                         # limit: 2
#                     concepts: {}
#                     categories: {}
#                     emotion: {}
#                     # metadata: {}
#                     relations: {}
#                     semantic_roles: {}
#                     sentiment: {}

#             natural_language_understanding.analyze parameters, Meteor.bindEnvironment((err, response) ->
#                 if err
#                     console.log 'error:', err
#                 else
#                     keyword_array = _.pluck(response.keywords, 'text')
#                     lowered_keywords = keyword_array.map (tag)-> tag.toLowerCase()
#                     # console.dir response
#                     Docs.update { _id: doc_id }, 
#                         $set:
#                             watson: response
#                             watson_keywords: lowered_keywords
#                             doc_sentiment_score: response.sentiment.document.score
#                             doc_sentiment_label: response.sentiment.document.label
#                 return
#             )
        
#         return
        
        
