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

    detect_fields: (doc_id)->
        doc = Docs.findOne doc_id
        keys = _.keys doc
        # fields = doc.fields
        console.log 
        
        fields = []
        
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
            field_object = 
                {
                    key:key
                    label:label
                    field_type:field_type
                }
                
            # console.log 'adding field object', field_object    
            fields.push field_object
                    
        # console.log 'fields length', fields.length
        # unique = _.uniq fields
        # console.log 'unique length', unique.length
                    
        Docs.update doc_id,
            $set: 
                fields: fields
                keys: keys
                meta:1
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
                # built_query = { tribe:'dao' }
                built_query = {  }
                
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
        
        
                results_cursor = Docs.find built_query, limit:1
        
                # result_ids = []
                # for result in results_cursor.fetch()
                #     result_ids.push result._id
        
                results = results_cursor.fetch()
        
                Docs.update {_id:delta._id},
                    {$set:
                        total: total
                        results:results
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