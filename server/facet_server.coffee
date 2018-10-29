Meteor.publish 'session', ->
    Docs.find {
            type:'session'
            author_id: Meteor.userId()
    }, {limit:1}


Meteor.methods
    # fi: (id)->
    #     # console.log id 
    #     doc = Docs.findOne id
    #     keys = _.keys doc
    #     # console.log keys
    #     key_count = keys.length
    #     Docs.update id, 
    #         $set: 
    #             keys:keys
    #             key_count:key_count    
    #     console.log 'keyed', id
    
    
    fi: ->
        session = Docs.findOne
            type:'session'
            author_id: Meteor.userId()

        built_query = {}

        filter_keys = ['tags']

        for facet_field in facet_fields
            filter_list = session["filter_#{facet_field.key}"]
            if filter_list and filter_list.length > 0
                if facet_field.field_type is 'array'
                    built_query["#{facet_field.key}"] = $all: filter_list
                else
                    built_query["#{facet_field.key}"] = $in: filter_list
            else
                Docs.update session._id,
                    $set: "filter_#{facet_field.key}":[]


        total = Docs.find(built_query).count()

        for facet_field in facet_fields
            values = []
            key_return = []

            example_doc = Docs.findOne({"#{facet_field.key}":$exists:true})
            example_value = example_doc?["#{facet_field.key}"]
            field_type = typeof example_value

            test_calc = Meteor.call 'agg', built_query, 'ticket', facet_field.key

            # console.log test_calc

            Docs.update {_id:session._id},
                { $set:"#{facet_field.key}_return":test_calc }
                , ->

        calc_page_size = if session.page_size then session.page_size else 10

        page_amount = Math.ceil(total/calc_page_size)

        current_page = if session.current_page then session.current_page else 1

        skip_amount = current_page*calc_page_size-calc_page_size

        results_cursor =
            Docs.find( built_query,
                {
                    limit:calc_page_size
                    sort:"#{session.sort_key}":session.sort_direction
                    skip:skip_amount
                }
            )

        result_ids = []
        for result in results_cursor.fetch()
            result_ids.push result._id


        Docs.update {_id:session._id},
            {$set:
                current_page:current_page
                page_amount:page_amount
                skip_amount:skip_amount
                page_size:calc_page_size
                total: total
                result_ids:result_ids
            }, ->
        return true


    agg: (query, type, key)->
        options = {
            explain:false
            }
        # console.log key
        if type is 'array'
            pipe =  [
                { $match: query }
                { $project: "#{key}": 1 }
                { $unwind: "$#{key}" }
                { $group: _id: "$#{key}", count: $sum: 1 }
                { $sort: count: -1, _id: 1 }
                { $limit: 20 }
                { $project: _id: 0, name: '$_id', count: 1 }
            ]
        else
            pipe =  [
                { $match: query }
                { $project: "#{key}": 1 }
                { $group: _id: "$#{key}", count: $sum: 1 }
                { $sort: count: -1, _id: 1 }
                { $limit: 20 }
                { $project: _id: 0, name: '$_id', count: 1 }
            ]

        agg = Docs.rawCollection().aggregate(pipe,options)

        res = {}
        if agg
            agg.toArray()