Meteor.methods
    fum: (delta_id)->
        console.log 'running fum', delta_id
        delta = Docs.findOne delta_id

        if delta
            built_query = {}
            if delta.facet_in 
                built_query.tags = $all: delta.facet_in
            else
                built_query = {}
            
            total = Docs.find(built_query).count()
            console.log 'built query', built_query
            
            # response
            agg_res = Meteor.call 'agg', built_query
    
            Docs.update delta_id,
                { $set: facet_out: agg_res }
    
            if delta.limit then limit=delta.limit else limit=1
    
    
            results_cursor = Docs.find built_query, { fields:{_id:1}, limit:limit}
    
            result_ids = results_cursor.fetch()
    
            console.log 'result ids', result_ids
    
            # console.log 'delta', delta
            # console.log Meteor.userId()
    
            Docs.update {_id:delta_id},
                {
                    $set:
                        total: total
                        # _facets: filtered_facets
                        result_ids:result_ids
                }
                
            delta = Docs.findOne delta_id    
            console.log 'delta', delta

    agg: (query)->
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