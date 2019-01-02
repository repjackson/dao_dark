Meteor.methods
    pull_subreddit: (subreddit)->
        response = HTTP.get("http://reddit.com/r/#{subreddit}.json")
        # return response.content
        
        _.each(response.data.data.children, (item)-> 
            # console.log item
            data = item.data
            len = 200
            # console.log item.data
            reddit_post =
                reddit_id: data.id
                url: data.url
                subreddit: data.domain
                comment_count: data.num_comments
                permalink: data.permalink
                title: data.title
                selftext: true
                # thumbnail: false
                schema:'reddit'
                
            # console.log reddit_post
            existing_doc = Docs.findOne reddit_id:data.id
            if existing_doc
                Meteor.call 'get_reddit_post', existing_doc._id, data.id
            else
                new_reddit_post_id = Docs.insert reddit_post
                console.log 'new id', new_reddit_post_id
                Meteor.call 'get_reddit_post', new_reddit_post_id, data.id
        )
        
    get_reddit_post: (doc_id, reddit_id)->
        HTTP.get "http://reddit.com/by_id/t3_#{reddit_id}.json", (err,res)->
            if err then console.error err
            else
                if res.data.data.children[0].data.selftext
                    # console.log "SELF TEXT",res.data.data.children[0].data.selftext
                    Docs.update doc_id, {
                        $set: html: res.data.data.children[0].data.selftext
                    }, ->
                if res.data.data.children[0].data.url
                    url = res.data.data.children[0].data.url
                    # console.log "SELF URL",res.data.data.children[0].data.url
                    Docs.update doc_id, {
                        $set: 
                            reddit_url: url
                            url: url
                    }, ->
                Docs.update doc_id, 
                    $set: reddit_data: res.data.data.children[0].data
                Meteor.call 'call_watson', doc_id

        
    get_listing_comments: (doc_id, subreddit, reddit_id)->
        console.log doc_id
        console.log subreddit
        console.log reddit_id
        # HTTP.get "https://www.reddit.com/r/t5_#{subreddit}/comments/t3_#{reddit_id}/irrelevant_string.json", (err,res)->
        HTTP.get "https://www.reddit.com/r/0xProject/comments/t3_#{reddit_id}/irrelevant_string.json", (err,res)->
            if err then console.error err
            else
                console.log 'res', res
            
