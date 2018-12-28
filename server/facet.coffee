Meteor.methods
    fum: ->
        delta = Docs.findOne 
            _type:'delta'
            # author_id: Meteor.userId()
        unless delta
            new_id = Docs.insert
                _type:'delta'
                facets: [
                    {
                        key:'_keys'
                        filters:[]
                        res:[]
                    }
                ]
            
            delta = Docs.findOne new_id
        
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

        delta = Docs.findOne _type:'delta'

        if delta._limit then limit=delta._limit else limit=1

        results_cursor = Docs.find built_query, { fields:{_id:1},limit:limit }

        result_ids = results_cursor.fetch()

        Docs.update {_id:delta._id},
            {
                $set:
                    total: total
                    # _facets: filtered_facets
                    result_ids:result_ids
            }

    agg: (query, key, filters)->
        
        
        unless key is '_keys'
            test_doc = 
                Docs.findOne 
                    "_#{key}":$exists:true
            meta = test_doc["_#{key}"]
        else
            meta = {array:true}
        if key is '_keys' then limit=42 else limit=42
        
        options = { explain:false }
        if meta.array
            pipe =  [
                { $match: query }
                { $project: "#{key}": 1 }
                { $unwind: "$#{key}" }
                { $group: _id: "$#{key}", count: $sum: 1 }
                { $sort: count: -1, _id: 1 }
                { $limit: limit }
                { $project: _id: 0, name: '$_id', count: 1 }
            ]
        else if meta.string or meta.number
            unless meta.html
                pipe =  [
                    { $match: query }
                    { $project: "#{key}": 1 }
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