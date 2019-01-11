Meteor.methods 
    site_stat: ->
        doc_count = Docs.find({}).count()
        user_count = Meteor.users.find({}).count()
        Docs.insert
            type:'stat'
            doc_count:doc_count
            user_count:user_count
    
    
    count_tags: ->
        cursor = 
            Docs.find({
                tag_count:
                    $exists:false
                tags:
                    $exists:true
            }, {limit:100})
        count = cursor.count()
        console.log 'found',count,'uncounted tags'
        for uncounted in cursor.fetch()
            tag_count = uncounted.tags.length
            console.log 'tag count', tag_count
            Docs.update uncounted._id,
                $set:tag_count:tag_count
            console.log 'counted', uncounted.tags
                    

    
    lowercase_tags: ->
        cur = Docs.find({tags:$exists:true})
        for doc in cur.fetch()
            console.log 'turning', doc.tags
            tags = _.map(doc.tags, (tag)->tag.toLowerCase())
            console.log 'into', tags
            Docs.update doc._id,
                $set:tags:tags
    
    remove_key: (key)->
        console.log 'removing key', key
        filter = {"#{key}":$exists:true}
        console.log Docs.find(filter).count()
        Docs.update filter,
            {$unset:"#{key}"}
    
