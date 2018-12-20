Docs.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> true
    update: (userId, doc) -> userId
    remove: (userId, doc) -> doc.author_id is userId

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

    fo: ()->
        delta = Docs.findOne 
            type:'delta'
            author_id: Meteor.userId()
        
        unless delta
            new_id = Docs.insert
                type:'delta'
                author_id: Meteor.userId()
                facets: [
                    {
                        key:'keys'
                        filters: []
                        res:[]
                    }
                    # {
                    #     key:'type'
                    #     filters: []
                    #     res:[]
                    # }
                ]
                
            delta = Docs.findOne new_id
            
        built_query = { }
        
        key_response = Meteor.call 'agg', built_query, 'array', 'keys', []
        
        console.log key_response
        
        new_facets = delta.facets
        for key_res in key_response
                # existing = _.find(delta.facets, (facet)-> 
                #     console.log '
                #     facet.key is key_res.name )
                # if existing
                #     console.log 'existing', key.name
                # else
            facet_ob = {
                key:key_res.name
                filters:[]
                res:[]
            }
            
            new_facets.push facet_ob

        console.log 'new_facets', new_facets


        for facet in new_facets
            if facet.filters and facet.filters.length > 0
                built_query["#{facet.key}"] = $all: facet.filters

        total = Docs.find(built_query).count()
        
        
        # response
        for facet in new_facets
            values = []
            local_return = []
            
            agg_res = Meteor.call 'agg', built_query, 'array', facet.key, facet.filters

            Docs.update {_id:delta._id, "facets.key":facet.key},
                { $set: "facets.$.res": agg_res }

        results_cursor = Docs.find built_query, { fields:{_id:1},limit:1 }

        result_ids = results_cursor.fetch()

        Docs.update {_id:delta._id},
            {
                $set:
                    total: total
                    facets: new_facets
                    result_ids:result_ids
            }

    agg: (query, field_type, key, filters)->
        options = { explain:false }
            
        if field_type in ['array','multiref']
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