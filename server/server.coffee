Docs.allow
    insert: (userId, doc) -> doc.author_id is userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> doc.author_id is userId

Meteor.users.allow
    insert: (userId, doc) -> userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId


Meteor.publish 'my_deltas', ->
    Docs.find
        type:'delta'
        # author_id: Meteor.userId()

Meteor.publish 'doc_id', (doc_id)->
    Docs.find doc_id

Meteor.publish 'type', (type)->
    Docs.find {
        type:type
    }, limit: 10
Meteor.publish 'me', ()->
    Meteor.users.find Meteor.userId()


Meteor.publish 'my_tribe', ()->
    Docs.find
        type:'tribe'
        _id: Meteor.user().current_tribe_id


# facet macro to find documents
# facet micro to view into/manipulate docs



Meteor.methods
    crawl_fields: ->
        found_cursor = Docs.find { fields: $exists:false}, limit:100
        for found in found_cursor.fetch()
            Meteor.call 'detect_fields', found._id, (err,res)->
                
    detect_fields: (doc_id)->
        doc = Docs.findOne doc_id
        keys = _.keys doc
        fields = doc.fields
        for key in keys
            key_value = doc["#{key}"]
            initial_field_type = typeof key_value
                    
            if initial_field_type is 'object'        
                if Array.isArray key_value
                    field_type = 'array'
                else
                    field_type = 'object'
                    
            else if initial_field_type is 'number'
                # d = Date.parse(key_value)
                # nan = isNaN d
                # !nan
                field_type = 'number'
                                
            else if initial_field_type is 'string'
                html_check = /<[a-z][\s\S]*>/i
                html_result = html_check.test key_value
                if html_result
                    field_type = 'html'
                else
                    field_type = 'string'
                
            label = key.charAt(0).toUpperCase() + key.slice(1).toLowerCase();

                            
            Docs.update doc_id,
                $addToSet:
                    fields: 
                        key:key
                        label:label
                        type:field_type
        
        console.log 'detected fields', doc_id
        return doc_id

    keys: ->
        start = Date.now()
        cursor = Docs.find({keys:$exists:false}, {limit:1000}).fetch()
        for doc in cursor
            keys = _.keys doc
            # console.log doc
            Docs.update doc._id,
                $set:keys:keys
            
            console.log "updated keys for doc #{doc._id}"
        stop = Date.now()
        
        diff = stop - start
        # console.log diff
        console.log 'duration', moment(diff).format("HH:mm:ss:SS")
        
    fo: ->
        if Meteor.user()
            if Meteor.user().current_delta_id
                delta = Docs.findOne Meteor.user().current_delta_id
                console.log 'found delta', delta._id
                built_query = { }
                
                for facet in delta.facets
                    if facet.filters and facet.filters.length > 0
                        built_query["#{facet.key}"] = $all: facet.filters
                    # else
                    #     Docs.update delta._id,
                    #         $addToSet:
                    #             filters" 
                    #             "filter_#{key}":[]
        
                # console.log 'built query', built_query
        
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
        
        
                results_cursor = Docs.find built_query, limit:10
        
                # result_ids = []
                # for result in results_cursor.fetch()
                #     result_ids.push result._id
        
                results = results_cursor.fetch()
        
                Docs.update {_id:delta._id},
                    {$set:
                        total: total
                        results:results
                    }, ->
                return true
            else
                return
        else
            return

    agg: (query, type, key, filters)->
        # console.log 'query agg', query
        # console.log 'type', type
        # console.log 'key', key
        options = { explain:false }
            
        # intelligence
        if type in ['array','multiref']
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