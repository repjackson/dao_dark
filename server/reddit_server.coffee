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
    pull_subreddit: (subreddit)->
        response = HTTP.get("http://reddit.com/r/#{subreddit}.json")
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
                schema: 'reddit'
                
            # console.log reddit_post
            existing_doc = Docs.findOne reddit_id:data.id
            unless existing_doc
                new_reddit_post_id = Docs.insert reddit_post
                Meteor.call 'get_reddit_post', new_reddit_post_id, data.id, (err,res)->
                    # console.log 'get post res', res
        )
        
    get_reddit_post: (doc_id, reddit_id)->
        HTTP.get "http://reddit.com/by_id/t3_#{reddit_id}.json", (err,res)->
            if err then console.error err
            else
                if res.data.data.children[0].data.selftext
                    Docs.update doc_id, {
                        $set: html: res.data.data.children[0].data.selftext
                    }, ->
                        Meteor.call 'pull_site', doc_id, url
                        # console.log 'hi'
                if res.data.data.children[0].data.url
                    url = res.data.data.children[0].data.url
                    Docs.update doc_id, {
                        $set: 
                            reddit_url: url
                            url: url
                    }, ->
                        Meteor.call 'pull_site', doc_id, url
                # Docs.update doc_id, 
                #     $set: reddit_data: res.data.data.children[0].data
                # console.log res.data.children[0].data.selftext
        
        
    get_listing_comments: (doc_id, subreddit, reddit_id)->
        console.log doc_id
        console.log subreddit
        console.log reddit_id
        # HTTP.get "https://www.reddit.com/r/t5_#{subreddit}/comments/t3_#{reddit_id}/irrelevant_string.json", (err,res)->
        HTTP.get "https://www.reddit.com/r/0xProject/comments/t3_#{reddit_id}/irrelevant_string.json", (err,res)->
            if err then console.error err
            else
                console.log 'res', res
            
