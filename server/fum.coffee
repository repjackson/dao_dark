Meteor.methods
    fum: (delta_id, tribe)->
        # console.log 'running fum', delta_id
        delta = Docs.findOne delta_id

        if delta
            schema = Docs.findOne 
                type:'schema'
                slug:delta.doc_type
            if 'dev' in Meteor.user().roles
                built_query = {type:delta.doc_type}
            else
                built_query = {
                    type:delta.doc_type
                    tribe:schema.tribe
                    }
            
            console.log 'schema', schema
            
            # if not delta.facets
            #     delta.facets = []
            
            for facet in delta.facets
                if facet.filters.length > 0
                    built_query["#{facet.key}"] = $all: facet.filters
            
            total = Docs.find(built_query).count()
            console.log 'built query', built_query
            
            # response
            for facet in delta.facets
                values = []
                local_return = []
                
                # agg_res = Meteor.call 'agg', built_query, facet.key, schema.collection
                agg_res = Meteor.call 'agg', built_query, facet.key
    
                if agg_res
                    Docs.update { _id:delta._id, 'facets.key':facet.key},
                        { $set: 'facets.$.res': agg_res }
    
            if delta.limit then limit=delta.limit else limit=30
    
    
            if schema.collection 
                if schema.collection is 'users'
                    results_cursor = Meteor.users.find built_query, { fields:{_id:1}, limit:limit }
                else
                    results_cursor = global["#{schema.collection}"].find built_query, { limit:limit, sort:{_timestamp:-1}}
            else 
                results_cursor = Docs.find built_query, { fields:{_id:1}, limit:limit, sort:{_timestamp:-1}}
    
            
            # if total is 1
            #     result_ids = results_cursor.fetch()
            # else
            #     result_ids = []
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
            # console.log 'delta', delta

    agg: (query, key)->
        limit=100
        # console.log 'agg query', query
        # console.log 'agg key', key
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
            # if collection is 'users'
            #     agg = Meteor.users.rawCollection().aggregate(pipe,options)
            # else
            agg = global['Docs'].rawCollection().aggregate(pipe,options)
            # else
            res = {}
            # console.log 'res', res
            if agg
                agg.toArray()
        else 
            return null            
