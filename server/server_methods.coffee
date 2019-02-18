Meteor.methods
    count_children: (doc_id)->
        count = Docs.find(parent_id: doc_id).count()
        Docs.update doc_id,
            $set: child_count: count


    crawl_fields: (specific_key)->
        start = Date.now()
        
        if specific_key
            filter = 
                "#{specific_key}": $exists:true 
                _keys: $nin: ["#{specific_key}"]
        else
            filter = {}
        
        found_cursor = Docs.find filter, { fields:{_id:1},limit:10000 }
        
        count = found_cursor.count()
        current_number = 0
        
        for found in found_cursor.fetch()
            res = Meteor.call 'detect_fields', found._id
            console.log 'detected',res, current_number, 'of', count
            current_number++
                # console.log Docs.findOne res
        stop = Date.now()
        
        diff = stop - start
        doc_count = found_cursor.count()
        console.log 'duration', moment(diff).format("HH:mm:ss:SS"), 'for', doc_count, 'docs'

    detect_fields: (doc_id)->
        doc = Docs.findOne doc_id
        keys = _.keys doc
        light_fields = _.reject( keys, (key)-> key.startsWith '_' )
        # console.log light_fields

        Docs.update doc._id,
            $set:_keys:light_fields

        for key in light_fields
            value = doc["#{key}"]

            meta = {}

            js_type = typeof value

            # console.log 'key type', key, js_type

            if js_type is 'object'        
                meta.object = true
                if Array.isArray value
                    meta.array = true
                    meta.length = value.length
                    meta.array_element_type = typeof value[0]
                    meta.brick = 'array'
                else
                    if key is 'watson'
                        meta.brick = 'watson'
                    else
                        meta.brick = 'object'

            else if js_type is 'boolean'
                meta.boolean = true
                meta.brick = 'boolean'

            else if js_type is 'number'
                meta.number = true
                d = Date.parse(value)
                # nan = isNaN d
                # !nan
                if value < 0
                    meta.negative = true
                else if value > 0
                    meta.positive = false

                integer = Number.isInteger(value)
                if integer
                    meta.integer = true
                meta.brick = 'number'


            else if js_type is 'string'
                meta.string = true
                meta.length = value.length

                html_check = /<[a-z][\s\S]*>/i
                html_result = html_check.test value

                url_check = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/
                url_result = url_check.test value

                youtube_check = /((\w|-){11})(?:\S+)?$/
                youtube_result = youtube_check.test value

                if key is 'html'
                    meta.html = true
                    meta.brick = 'html'
                if key is 'youtube_id'
                    meta.youtube = true
                    meta.brick = 'youtube'
                else if html_result
                    meta.html = true
                    meta.brick = 'html'
                else if url_result
                    meta.url = true
                    image_check = (/\.(gif|jpg|jpeg|tiff|png)$/i).test value
                    if image_check
                        meta.image = true
                        meta.brick = 'image'
                    else
                        meta.brick = 'url'
                # else if youtube_result
                #     meta.youtube = true
                #     meta.brick = 'youtube'
                else if Meteor.users.findOne value
                    meta.user_id = true
                    meta.brick = 'user_ref'
                else if Docs.findOne value
                    meta.doc_id = true
                    meta.brick = 'doc_ref'
                else if meta.length > 20
                    meta.brick = 'textarea'
                else
                    meta.brick = 'text'

            Docs.update doc_id,
                $set: "_#{key}": meta

        Docs.update doc_id, 
            $set:_detected:1
        # console.log 'detected fields', doc_id

        return doc_id

    keys: (specific_key)->
        start = Date.now()
        
        console.log 're-keying docs with', specific_key
        
        cursor = Docs.find({ "#{specific_key}":$exists:true}, { fields:{_id:1} })

        found = cursor.count()
        console.log 'found', found, 'docs with', specific_key

        for doc in cursor.fetch()
            Meteor.call 'key', doc._id
            
        stop = Date.now()
        
        diff = stop - start
        # console.log diff
        console.log 'duration', moment(diff).format("HH:mm:ss:SS")
            
    key: (doc_id)->
        doc = Docs.findOne doc_id
        
        keys = _.keys doc
        # console.log doc
        
        light_fields = _.reject( keys, (key)-> key.startsWith '_' )
        # console.log light_fields
        
        Docs.update doc._id,
            $set:_keys:light_fields
        
        console.log "keyed #{doc._id}"

    global_remove: (keyname)->
        console.log 'removing', keyname, 'globally' 
        result = Docs.update({"#{keyname}":$exists:true}, {
            $unset: 
                "#{keyname}": 1
                "_#{keyname}": 1
            $pull:_keys:keyname
            }, {multi:true})
        console.log result
        console.log 'removed', keyname, 'globally' 
        
        
    count_key: (key)->
        count = Docs.find({"#{key}":$exists:true}).count()
        console.log 'key count', count
    

    rename: (old, newk)->
        console.log 'start renaming', old, 'to', newk
        
        old_count = Docs.find({"#{old}":$exists:true}).count()
        console.log 'found',old_count,'of',old
        
        new_count = Docs.find({"#{newk}":$exists:true}).count()
        console.log 'found',new_count,'of',newk
        
        
        result = Docs.update({"#{old}":$exists:true}, {$rename:"#{old}":"#{newk}"}, {multi:true})
        result2 = Docs.update({"#{old}":$exists:true}, {$rename:"_#{old}":"_#{newk}"}, {multi:true})
        
        # > Docs.update({doc_sentiment_score:{$exists:true}},{$rename:{doc_sentiment_score:"sentiment_score"}},{multi:true})

        console.log 'mongo update call finished:',result
        
        cursor = Docs.find({newk:$exists:true}, { fields:_id:1 })

        for doc in cursor.fetch()
            Meteor.call 'key', doc._id

        console.log 'done renaming', old, 'to', newk
            
        console.log 'result1', result
        console.log 'result2', result2


    remove: ->
        console.log 'start'
        result = Docs.update({}, {
            $unset: tag_count: 1
            }, {multi:true})
        console.log result
    
    
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
        # console.log date_array
        return date_array
        
        
    # fum: (delta_id)->
    #     console.log 'running fum', delta_id
    #     delta = Docs.findOne delta_id

    #     if delta
    #         built_query = {}
            
    #         for facet in delta.facets
    #             if facet.filters.length > 0
    #                 built_query["#{facet.key}"] = $all: facet.filters
            
    #         total = Docs.find(built_query).count()
    #         console.log 'built query', built_query
            
    #         # response
    #         for facet in delta.facets
    #             values = []
    #             local_return = []
                
    #             agg_res = Meteor.call 'agg', built_query, facet.key, facet.filters
    
    #             if agg_res
    #                 Docs.update { _id:delta._id, 'facets.key':facet.key},
    #                     { $set: 'facets.$.res': agg_res }
    
    #         if delta.limit then limit=delta.limit else limit=10
    
    
    #         results_cursor = Docs.find built_query, { fields:{_id:1}, limit:limit, sort:{_timestamp:-1}}
            
    #         # if total is 1
    #         #     result_ids = results_cursor.fetch()
    #         # else
    #         #     result_ids = []
    #         result_ids = results_cursor.fetch()
    
    #         console.log 'result ids', result_ids
    
    #         console.log 'delta', delta
    #         console.log Meteor.userId()
    
    #         Docs.update {_id:delta_id},
    #             {
    #                 $set:
    #                     total: total
    #                     # _facets: filtered_facets
    #                     result_ids:result_ids
    #             }
                
    #         delta = Docs.findOne delta_id    
    #         # console.log 'delta', delta

    # agg: (query, key)->
    #     limit=100
    #     console.log 'agg query', query
    #     options = { explain:false }
    #     pipe =  [
    #         { $match: query }
    #         { $project: "#{key}": 1 }
    #         { $unwind: "$#{key}" }
    #         { $group: _id: "$#{key}", count: $sum: 1 }
    #         { $sort: count: -1, _id: 1 }
    #         { $limit: limit }
    #         { $project: _id: 0, name: '$_id', count: 1 }
    #     ]
    #     if pipe
    #         agg = Docs.rawCollection().aggregate(pipe,options)
    #         res = {}
    #         if agg
    #             agg.toArray()
    #     else 
    #         return null            
        
    set_delta_facets: (type, user_id)->
        my_delta = Docs.findOne 
            type:'delta'
            _author_id:Meteor.userId()
        
        
        schema = Docs.findOne
            type:'schema'
            slug:type
        
        schema_bricks = Docs.find(
            type:'brick'
            parent_id:schema._id
            ).fetch()
            
        # console.log 'schema bricks', schema_bricks
            
        facets = []
        for brick in schema_bricks
            # console.log brick
            unless brick.field in ['textarea','image','youtube','html']
                facet = {
                    key:brick.key
                    label:brick.label
                    icon:brick.icon
                    filters:[]
                    res:[]
                }
                facets.push facet
            
        # timestamp_tags_facet = {
        #     key:'timestamp_tags'
        #     label:'Created'
        #     icon:'clock'
        #     filters:[]
        #     res:[]
        # }
        # facets.push timestamp_tags_facet
        
        Docs.update my_delta._id,        
            $set:
                doc_type:type
                user_id:user_id
                facets: facets
                
        # console.log 'delta after set facets', Docs.findOne({type:'delta'})        
        Meteor.call 'fum', my_delta._id

        
        
        
    fum: (delta_id)->
        # console.log 'running fum', delta_id
        delta = Docs.findOne delta_id

        if delta
            schema = Docs.findOne 
                type:'schema'
                slug:delta.doc_type
            if 'dev' in Meteor.user().roles
                built_query = {type:delta.doc_type}
            else
                built_query = {parent_id:schema._id}
                
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
                
    slugify: (title)->
        slug = title.toString().toLowerCase().replace(/\s+/g, '_').replace(/[^\w\-]+/g, '').replace(/\-\-+/g, '_').replace(/^-+/, '').replace(/-+$/,'')
        console.log 'title', title
        console.log 'slug', slug
        return slug
        # # Docs.update { _id:doc_id, fields:field_object },
        # Docs.update { _id:doc_id, fields:field_object },
        #     { $set: "fields.$.slug": slug }

                
                
    update_location: (doc_id, result)->
        location_tags = (component.long_name for component in result.address_components)
        parts = result.address_components
        
        geocode = {}
        for part in parts
            geocode["#{part.types[0]}"] = part.short_name 
                # console.log part.types[0]
                # console.log part.short_name
        geocode['formatted_address'] = result.formatted_address
        console.log result.lat
        console.log result.lng
        # console.log parts[0].types
        # # street_address = _.where(parts, {types:[ 'street_number' ]})
        # street_address = parts[0].short_name
        # console.log 'street address', street_address

        lowered_location_tags = _.map(location_tags, (tag)->
            tag.toLowerCase()
            )

        # console.log location_tags

        doc = Docs.findOne doc_id
        tags_without_address = _.difference(doc.tags, doc.location_tags)
        tags_with_new = _.union(tags_without_address, lowered_location_tags)

        Docs.update doc_id,
            $set:
                tags:tags_with_new
                location_ob:result
                location_tags:lowered_location_tags
                geocode:geocode
                location_lat: result.lat
                location_lng: result.lng
                