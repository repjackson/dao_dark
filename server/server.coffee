Docs.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> true
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId

Meteor.users.allow
    insert: (userId, doc) -> userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId


Meteor.publish 'doc_id', (doc_id)->
    Docs.find doc_id

Meteor.publish 'type', (schema)->
    Docs.find
        type:schema

Meteor.publish 'children', (type, parent)->
    Docs.find
        type:type
        parent_id:parent._id

Meteor.publish 'ref_choices', (schema)->
    Docs.find
        type:schema    
    
    
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
        
        # console.log 'key response', key_response
        
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
        unless key is '_keys'
            test_doc = 
                Docs.findOne 
                    "_#{key}":$exists:true
            console.log key
            meta = test_doc["_#{key}"]
        else
            meta = {array:true}
        if key is '_keys' then limit=20 else limit=20
        
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