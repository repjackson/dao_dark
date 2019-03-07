Meteor.methods
    fum: (delta_id)->
        # console.log 'running fum', delta_id
        delta = Docs.findOne delta_id

        if delta
            match = {}
            match.type = 'schema'
            match.slug = delta.doc_type


            schema = Docs.findOne match
            # console.log 'found schema', schema
            if schema.collection and schema.collection is 'users'
                built_query = { roles:$in:[delta.doc_type] }
            else
                built_query = { type:delta.doc_type }
            # if 'dev' in Meteor.user().roles and tribe is 'dao'
            # else if schema.user_schema
            #     built_query = {type:delta.doc_type}

            # console.log 'schema', schema

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

                agg_res = Meteor.call 'agg', built_query, facet.key, schema.collection
                # agg_res = Meteor.call 'agg', built_query, facet.key

                if agg_res
                    Docs.update { _id:delta._id, 'facets.key':facet.key},
                        { $set: 'facets.$.res': agg_res }

            # if delta.limit then limit=delta.limit else limit=30
            calc_page_size = if delta.page_size then delta.page_size else 42

            page_amount = Math.ceil(total/calc_page_size)

            current_page = if delta.current_page then delta.current_page else 1

            skip_amount = current_page*calc_page_size-calc_page_size

            final_sort_key = if delta.sort_key then delta.sort_key else '_timestamp'
            final_sort_direction = if delta.sort_direction then delta.sort_direction else -1

            modifier =
                {
                    fields:_id:1
                    limit:calc_page_size
                    sort:"#{final_sort_key}":final_sort_direction
                    skip:skip_amount
                }



            results_cursor =
                Docs.find( built_query, modifier )


            if schema.collection
                if schema.collection is 'users'
                    results_cursor = Meteor.users.find built_query, modifier
                else
                    results_cursor = global["#{schema.collection}"].find built_query, modifier
            else
                results_cursor = Docs.find built_query, modifier


            # if total is 1
            #     result_ids = results_cursor.fetch()
            # else
            #     result_ids = []
            result_ids = results_cursor.fetch()

            # console.log 'result ids', result_ids

            # console.log 'delta', delta
            # console.log Meteor.userId()

            Docs.update {_id:delta._id},
                {$set:
                    current_page:current_page
                    page_amount:page_amount
                    skip_amount:skip_amount
                    page_size:calc_page_size
                    total: total
                    result_ids:result_ids
                }, ->
            return true


            # delta = Docs.findOne delta_id
            # console.log 'delta', delta

    agg: (query, key, collection)->
        limit=50
        console.log 'agg query', query
        console.log 'agg key', key
        console.log 'agg collection', collection
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
            if collection is 'users'
                agg = Meteor.users.rawCollection().aggregate(pipe,options)
            else
                agg = global['Docs'].rawCollection().aggregate(pipe,options)
            # else
            res = {}
            console.log 'res', res
            if agg
                agg.toArray()
        else
            return null
