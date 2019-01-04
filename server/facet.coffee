Meteor.methods
    fum: (delta_id)->
        console.log 'running fum', delta_id
        delta = Docs.findOne delta_id

        if delta
            built_query = {}
            
            for facet in delta.facets
                if facet.filters.length > 0
                    built_query["#{facet.key}"] = $all: facet.filters
            
            total = Docs.find(built_query).count()
            console.log 'built query', built_query
            
            # response
            for facet in delta.facets
                values = []
                local_return = []
                
                agg_res = Meteor.call 'agg', built_query, facet.key, facet.filters
    
                if agg_res
                    Docs.update { _id:delta._id, "facets.key":facet.key},
                        { $set: "facets.$.res": agg_res }
    
            if delta.limit then limit=delta.limit else limit=10
    
    
            results_cursor = Docs.find built_query, { fields:{_id:1}, limit:limit}
    
            result_ids = results_cursor.fetch()
    
            # console.log 'result ids', result_ids
    
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

    agg: (query, key)->
        limit=42
        console.log 'agg query', query
        options = { explain:false }
        pipe =  [
            { $match: query }
            { $project: "#{key}": 1 }
            { $unwind: "$#{key}" }
            { $group: _id: "$#{key}", count: $sum: 1 }
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