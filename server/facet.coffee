Meteor.methods
    fum: ->
        console.log 'first userid', Meteor.userId()
        delta = Docs.findOne 
            type:'delta'
            # author_id: Meteor.userId()
        
        # console.log 'first delta', delta
        unless delta
            new_id = Docs.insert
                type:'delta'
                # author_id: Meteor.userId()
                limit: 1
                facets: [
                    {
                        key:'tags'
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

        if delta.limit then limit=delta.limit else limit=1

        # console.log 'built query', built_query

        results_cursor = Docs.find built_query, { fields:{_id:1}, limit:limit}

        result_ids = results_cursor.fetch()

        console.log 'result ids', result_ids

        # console.log 'delta', delta
        # console.log Meteor.userId()

        Docs.update {_id:delta._id},
            {
                $set:
                    total: total
                    # _facets: filtered_facets
                    result_ids:result_ids
            }

    agg: (query, key, filters)->
        limit=42
        
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
        # else if meta.string or meta.number
        #     unless meta.html
        #         pipe =  [
        #             { $match: query }
        #             { $project: "#{key}": 1 }
        #             { $group: _id: "$#{key}", count: $sum: 1 }
        #             { $sort: count: -1, _id: 1 }
        #             { $limit: limit }
        #             { $project: _id: 0, name: '$_id', count: 1 }
        #         ]
        if pipe
            agg = Docs.rawCollection().aggregate(pipe,options)
            res = {}
            if agg
                agg.toArray()
        else 
            return null            