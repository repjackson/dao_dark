Docs.allow
    insert: (userId, doc) -> true
    update: (userId, doc) -> true
    remove: (userId, doc) -> true


Meteor.publish 'type', (type)->
    Docs.find type:type
        
    
Meteor.publish 'doc', (id)->
    Docs.find
        _id:id
        
    
    
Meteor.methods
    fum: (delta_id)->
        # console.log 'running fum', delta_id
        delta = Docs.findOne delta_id

        if delta
            built_query = {}
            
            for facet in delta.facets
                if facet.filters.length > 0
                    built_query["#{facet.key}"] = $all: facet.filters
            
            total = Docs.find(built_query).count()
            
            # response
            for facet in delta.facets
                values = []
                local_return = []
                
                agg_res = Meteor.call 'agg', built_query, facet.key, facet.filters
    
                if agg_res
                    Docs.update { _id:delta._id, "facets.key":facet.key},
                        { $set: "facets.$.res": agg_res }
    
            results_cursor = Docs.find built_query, { fields:{_id:1}, limit:1, sort:timestamp:-1}
    
            if total is 1
                result_ids = results_cursor.fetch()
            else
                result_ids = null
    
            Docs.update {_id:delta_id},
                {
                    $set:
                        total: total
                        # _facets: filtered_facets
                        result_ids:result_ids
                }
                
            delta = Docs.findOne delta_id    
            # console.log 'delta', delta

    agg: (query, key)->
        # console.log 'agg query', query
        options = { explain:false }
        pipe =  [
            { $match: query }
            { $project: "tags": 1 }
            { $unwind: "$tags" }
            { $group: _id: "$tags", count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: 100 }
            { $project: _id: 0, name: '$_id', count: 1 }
        ]
        if pipe
            agg = Docs.rawCollection().aggregate(pipe,options)
            res = {}
            if agg
                agg.toArray()
        else 
            return null            