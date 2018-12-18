Docs.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> true
    update: (userId, doc) -> userId
    remove: (userId, doc) -> doc.author_id is userId

Meteor.users.allow
    insert: (userId, doc) -> userId
    update: (userId, doc) -> userId
    remove: (userId, doc) -> userId


Meteor.publish 'my_deltas', ->
    if Meteor.user()
        Docs.find {
            schema:'delta'
            author_id: Meteor.userId()
        }, limit:1

Meteor.publish 'doc_id', (doc_id)->
    Docs.find doc_id

Meteor.publish 'public_deltas', ->
    Docs.find
        schema:'delta'
        author_id:null

    
Meteor.publish 'children', (type, parent)->
    Docs.find
        type:type
        parent_id:parent

    
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

    fo: (delta_id)->
        delta = Docs.findOne delta_id
        built_query = { }
        
        for facet in delta.facets
            if facet.filters and facet.filters.length > 0
                built_query["#{facet.key}"] = $all: facet.filters

        total = Docs.find(built_query).count()
        
        # response
        for facet in delta.facets
            values = []
            local_return = []
            
            agg_res = Meteor.call 'agg', built_query, 'array', facet.key, facet.filters

            Docs.update {_id:delta._id, "facets.key":facet.key},
                { $set: "facets.$.res": agg_res }

        results_cursor = Docs.find built_query, { fields:{_id:1},limit:10 }

        result_ids = results_cursor.fetch()

        Docs.update {_id:delta._id},
            {
                $set:
                    total: total
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
            
            
    create_delta: ->
        delta_count = Docs.find(schema:'delta').count()
        new_delta_id = Docs.insert
            schema:'delta'
            number: delta_count+1
            facets: [
                {
                    key:'type'
                    filters: []
                    res:[]
                }
                
                # {
                #     key:'domain'
                #     filters: []
                #     res:[]
                # }
                # {
                #     key:'watson_concepts'
                #     filters: []
                #     res:[]
                # }
                # {
                #     key:'watson_keywords'
                #     filters: []
                #     res:[]
                # }
                # {
                #     key:'doc_sentiment_label'
                #     filters: []
                #     res:[]
                # }
                {
                    key:'timestamp_tags'
                    filters: []
                    res:[]
                }
            ]
    
    select_section: (section)->
        console.log section
        delta_count = Docs.find(schema:'delta').count()
        
        section_schema = 
            Docs.findOne 
                type:'schema'
                section: section.slug
        
        
        
        # new_delta_id = Docs.insert
        #     schema:'delta'
        #     number: delta_count+1
        #     facets: [
        #         {
        #             key:'domain'
        #             filters: []
        #             res:[]
        #         }
        #         {
        #             key:'watson_concepts'
        #             filters: []
        #             res:[]
        #         }
        #         {
        #             key:'watson_keywords'
        #             filters: []
        #             res:[]
        #         }
        #         {
        #             key:'doc_sentiment_label'
        #             filters: []
        #             res:[]
        #         }
        #         {
        #             key:'timestamp_tags'
        #             filters: []
        #             res:[]
        #         }
        #     ]
                