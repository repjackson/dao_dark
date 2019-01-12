Docs.allow
    insert: (userId, doc) -> true
    update: (userId, doc) -> true
    remove: (userId, doc) -> true


Meteor.publish 'type', (type)->
    Docs.find type:type
        
    
Meteor.publish 'doc', (id)->
    Docs.find
        _id:id
        
        
Meteor.publish 'docs', (selected_tags)->
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags
    Docs.find match,
        limit: 3
        sort: timestamp: -1
        
        
        
Meteor.publish 'tags', (selected_tags)->
    self = @
    console.log 'publishing tags'
    match = {}
    if selected_tags.length > 0 then match.tags = $all: selected_tags

    cloud = Docs.aggregate [
        { $match: match }
        { $project: tags: 1 }
        { $unwind: '$tags' }
        { $group: _id: '$tags', count: $sum: 1 }
        { $match: _id: $nin: selected_tags }
        { $sort: count: -1, _id: 1 }
        { $limit: 50 }
        { $project: _id: 0, name: '$_id', count: 1 }
        ]

    cloud.forEach (tag) ->
        self.added 'tags', Random.id(),
            name: tag.name
            count: tag.count

    self.ready()
    
    
Meteor.methods
    fum: (delta_id)->
        # console.log 'running fum', delta_id
        delta = Docs.findOne delta_id

        if delta
            built_query = {}
                        
            if delta.fin.length > 0
                built_query.tags = $all: delta.fin
            
            total = Docs.find(built_query).count()
            
            # response
            values = []
            local_return = []
            
            agg_res = Meteor.call 'agg', built_query

            Docs.update delta._id,
                { $set: fout: agg_res }
    
            results_cursor = Docs.find built_query, { fields:{_id:1}, limit:1, sort:timestamp:-1}
    
            if total is 1
                result_id = results_cursor.fetch()
            else
                result_id = null
    
            Docs.update {_id:delta_id},
                {
                    $set:
                        total: total
                        # _facets: filtered_facets
                        result_id:result_id
                }
                
            delta = Docs.findOne delta_id    
            # console.log 'delta', delta

    agg: (query)->
        # console.log 'agg query', query
        options = { explain:false }
        pipe =  [
            { $match: query }
            { $project: "tags": 1 }
            { $unwind: "$tags" }
            { $group: _id: "$tags", count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: 42 }
            { $project: _id: 0, name: '$_id', count: 1 }
        ]
        agg = Docs.rawCollection().aggregate(pipe,options)
        if agg
            agg.toArray()