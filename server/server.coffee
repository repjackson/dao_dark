Docs.allow
    insert: (userId, doc) -> doc.author_id is userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> doc.author_id is userId

Meteor.users.allow
    insert: (userId, doc) -> userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId


Meteor.publish 'my_delta', ->
    Docs.find {
        schema:'delta'
    }, limit:1
        # author_id: Meteor.userId()

Meteor.publish 'doc_id', (doc_id)->
    Docs.find doc_id

    
Meteor.publish 'me', ()->
    Meteor.users.find Meteor.userId()
        
Meteor.methods 
    tagify_date_time: (val)->
        console.log moment(val).format("dddd, MMMM Do YYYY, h:mm:ss a")
        minute = moment(val).minute()
        hour = moment(val).format('h')
        date = moment(val).format('Do')
        ampm = moment(val).format('a')
        weekdaynum = moment(val).isoWeekday()
        weekday = moment().isoWeekday(weekdaynum).format('dddd')

        month = moment(val).format('MMMM')
        year = moment(val).format('YYYY')

        date_array = [hour, minute, ampm, weekday, month, date, year]
        date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
        # date_array = _.each(date_array, (el)-> console.log(typeof el))
        console.log date_array
        return date_array

    crawl_fields: ->
        start = Date.now()

        # found_cursor = Docs.find {meta:$ne:1}, { fields:{_id:1},limit:10 }
        found_cursor = Docs.find {fields:$exists:false}, { fields:{_id:1},limit:10000 }
        
        for found in found_cursor.fetch()
            Meteor.call 'detect_fields', found._id, (err,res)->
        stop = Date.now()
        
        diff = stop - start
        # console.log diff
        console.log 'duration', moment(diff).format("HH:mm:ss:SS")

    fo: ->
        if Meteor.user()
            if Meteor.user().current_delta_id
                delta = Docs.findOne Meteor.user().current_delta_id
                built_query = { schema:'reddit' }
                
                current_module = Docs.findOne delta.module_id
                # console.log current_module
                    # console.log module_child_schema
                    
                    # facet every field by default, then add faceted boolean again, fields need to be unique to schema at first, maybe future cross ref
                    
                    
                for facet in delta.facets
                    if facet.filters and facet.filters.length > 0
                        built_query["#{facet.key}"] = $all: facet.filters

                total = Docs.find(built_query).count()
                
                # response
                for facet in delta.facets
                    values = []
                    local_return = []
                    
                    # field type detection 
                    example_doc = Docs.findOne({"#{facet.key}":$exists:true})
                    example_value = example_doc?["#{facet.key}"]
        
                    # js arrays typeof is object
                    array_test = Array.isArray example_value
                    if array_test
                        prim = 'array'
                    else
                        prim = typeof example_value
                    
                    agg_res = Meteor.call 'agg', built_query, prim, facet.key, facet.filters
        
                    Docs.update {_id:delta._id, "facets.key":facet.key},
                        { $set: "facets.$.res": agg_res }
        
        
                results_cursor = Docs.find built_query, {fields:{_id:1},limit:1}
        
                # result_ids = []
                # for result in results_cursor.fetch()
                #     result_ids.push result._id
        
                results = results_cursor.fetch()
        
                Docs.update {_id:delta._id},
                    {$set:
                        total: total
                        result:result
                    }, ->

    agg: (query, schema, key, filters)->
        # console.log 'query agg', query
        # console.log 'schema', schema
        # console.log 'key', key
        options = { explain:false }
            
        # intelligence
        if schema in ['array','multiref']
            pipe =  [
                { $match: query }
                { $project: "#{key}": 1 }
                { $unwind: "$#{key}" }
                { $group: _id: "$#{key}", count: $sum: 1 }
                { $sort: count: -1, _id: 1 }
                { $limit: 42 }
                { $project: _id: 0, name: '$_id', count: 1 }
            ]
        else
            pipe =  [
                { $match: query }
                { $project: "#{key}": 1 }
                { $group: _id: "$#{key}", count: $sum: 1 }
                { $sort: count: -1, _id: 1 }
                { $limit: 42 }
                { $project: _id: 0, name: '$_id', count: 1 }
            ]

        agg = Docs.rawCollection().aggregate(pipe,options)

        res = {}
        if agg
            agg.toArray()