Docs.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> doc.author_id is userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> doc.author_id is userId

Meteor.users.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId



Meteor.publish 'delta', ->
    Docs.find
        type:'delta'
        
    
Meteor.publish 'user', (user_id)->
    Meteor.users.find user_id
        
Meteor.publish 'users', ()->
    Meteor.users.find {}
        
Meteor.publish 'type', (type)->
    Docs.find type:type
        
    
Meteor.publish 'doc', (doc_id)->
    Docs.find
        _id:doc_id
        
    
    
Meteor.methods 
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
    
    fum: ()->
        # console.log 'running fum'
        
        delta = Docs.findOne type:'delta'

        unless delta
            new_id = Docs.insert 
                type:'delta'
                fi:[]
                fo:[]
            delta = Docs.findOne new_id
        # console.log 'delta', delta
        
        built_query = { type:$ne:'delta' }
        if delta.fi.length > 0
            built_query["tags"] = $all: delta.fi
        
        total = Docs.find(built_query).count()
        # console.log 'built query', built_query
        
        # response
        agg_res = Meteor.call 'agg', built_query, delta.fi

        results_cursor = Docs.find built_query, 
            { 
                fields:
                    _id:1
                limit:10
                sort:
                    tag_count:1
            }

        result_ids = results_cursor.fetch()

        Docs.update {_id:delta._id},
            {
                $set:
                    fo:agg_res
                    total:total
                    result_ids:result_ids
            }
            
        delta = Docs.findOne delta._id    
        # console.log 'delta', delta

    agg: (query, fi)->
        limit=42
        options = { explain:false }
        pipe =  [
            { $match: query }
            { $project: "tags": 1 }
            { $unwind: "$tags" }
            { $group: _id: "$tags", count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: limit }
            { $project: _id: 0, name: '$_id', count: 1 }
        ]
        if pipe
            agg = Docs.rawCollection().aggregate(pipe,options)
            res = {}
            if agg
                agg.toArray()
        else 
            return null            