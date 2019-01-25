Meteor.methods
    crawl_fields: ->
        start = Date.now()

        found_cursor = Docs.find {fields:$exists:false}, { fields:{_id:1},limit:10000 }
        
        for found in found_cursor.fetch()
            Meteor.call 'detect_fields', found._id, (err,res)->
                # console.log Docs.findOne res
        stop = Date.now()
        
        diff = stop - start
        doc_count = found_cursor.count()
        console.log 'duration', moment(diff).format("HH:mm:ss:SS"), 'for ', doc_count, 'docs'

    detect_fields: (doc_id)->
        doc = Docs.findOne doc_id
        keys = _.keys doc
        light_fields = _.reject( keys, (key)-> key.startsWith '_' )
        # console.log light_fields
        
        # Docs.update doc._id,
        #     $set:_keys:light_fields
        
        for key in light_fields
            fo = {} #field object    
            value = doc["#{key}"]
            
            meta = {}
            
            js_type = typeof value
            
            console.log js_type

            if js_type is 'object'        
                meta.object = true
                if Array.isArray value
                    meta.array = true
                    meta.length = value.length
                    meta.array_element_type = typeof value[0]
                
                    
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
                
                                
            else if js_type is 'string'
                meta.string = true
                html_check = /<[a-z][\s\S]*>/i
                html_result = html_check.test value
                
                if html_result
                    meta.html = true
                user_check = Meteor.users.findOne value
                if user_check
                    meta.user_id = true
                
                doc_check = Docs.findOne value
                if doc_check
                    meta.doc_id = true
                
            # console.log 'adding field object', meta    
            console.log 'result meta', meta
            Docs.update doc_id,
                $set: 
                    "_#{key}": meta
                    
        console.log 'detected fields', doc_id
        
        return doc_id

    keys: ->
        start = Date.now()
        cursor = Docs.find({}, {limit:50000}).fetch()
        for doc in cursor
            keys = _.keys doc
            # console.log doc
            
            light_fields = _.reject( keys, (key)-> key.startsWith '_' )
            # console.log light_fields
            
            Docs.update doc._id,
                $set:_keys:light_fields
            
            console.log "updated keys for doc #{doc._id}"
        stop = Date.now()
        
        diff = stop - start
        # console.log diff
        console.log 'duration', moment(diff).format("HH:mm:ss:SS")

    remove: ->
        console.log 'start'
        result = Docs.update({}, {
            $unset: tag_count: 1
            }, {multi:true})
        console.log result
    
    
    clear_crime: ->
        count = Docs.remove({'X':$exists:true})
        console.log count
    
    rename: ->
        console.log 'hi'
        result = Docs.update({}, {
            $rename:
                timestamp_long: '_timestamp_long'
            }, {multi:true})
        console.log result
        console.log 'hi'
        
        
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

    fum: ()->
        delta = Docs.findOne 
            _type:'delta'
            # author_id: Meteor.userId()
        
        unless delta
            new_id = Docs.insert
                _type:'delta'
                _author_id: Meteor.userId()
                _facets: [
                    {
                        key:'_keys'
                        filters:[]
                        res:[]
                    }
                ]
                
            delta = Docs.findOne new_id
            
        built_query = { }
        
        for facet in delta._facets
            if facet.filters.length > 0
                built_query["#{facet.key}"] = $all: facet.filters
        
        # console.log built_query
        
        key_response = Meteor.call 'agg', built_query, '_keys', []
        
        console.log 'key response', key_response
        
        filtered_facets = [
            {
                key:'_keys'
                filters: []
                res:key_response
            }
        ]

        
        for facet in delta._facets
            if facet.filters.length > 0 then filtered_facets.push facet
                # built_query["#{facet.key}"] = $all: facet.filters
        
        # filtered_facets = delta.facets
        
        
        for key_res in key_response
            existing = _.findWhere(filtered_facets, {key:key_res.name})
            unless existing
                facet_ob = {
                    key:key_res.name
                    filters:[]
                    res:[]
                }
            
                filtered_facets.push facet_ob


        # for facet in filtered_facets
        #     if facet.filters and facet.filters.length > 0
        #         built_query["#{facet.key}"] = $all: facet.filters

        total = Docs.find(built_query).count()
        
        Docs.update {_id:delta._id},
            {
                $set:
                    _facets: filtered_facets
            }
            
        # response
        for facet in filtered_facets
            unless facet.key in ['_keys','_id','_timestamp']
                values = []
                local_return = []
                
                agg_res = Meteor.call 'agg', built_query, facet.key, facet.filters
    
                if agg_res
                    Docs.update { _id:delta._id, "_facets.key":facet.key},
                        { $set: "_facets.$.res": agg_res }

        results_cursor = Docs.find built_query, { fields:{_id:1},limit:1 }

        result_ids = results_cursor.fetch()

        Docs.update {_id:delta._id},
            {
                $set:
                    total: total
                    # facets: filtered_facets
                    result_ids:result_ids
            }

    agg: (query, key, filters)->
        test_doc = Docs.findOne "#{key}":$exists:true
        # fo = _.findWhere(test_doc.fields, {key:key})
        console.log key
        if key is '_keys' then limit=20 else limit=20
        
        options = { explain:false }
        # if fo.array
        pipe =  [
            { $match: query }
            { $project: "#{key}": 1 }
            { $unwind: "$#{key}" }
            { $group: _id: "$#{key}", count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: limit }
            { $project: _id: 0, name: '$_id', count: 1 }
        ]
        # else if fo.string or fo.number
        #     unless fo.html
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