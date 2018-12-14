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

    fo: ->
        if Meteor.user()
            delta = Docs.findOne schema:'delta'
            built_query = { schema:'reddit' }
            
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
    
    
            results_cursor = Docs.find built_query, {fields:{_id:1},limit:1}
    
            if total is 1
                result_id = results_cursor.fetch()._id
            else 
                result_id = null
    
    
            Docs.update {_id:delta._id},
                {$set:
                    total: total
                    result_id:result_id
                }, ->

    agg: (query, field_type, key, filters)->
        options = { explain:false }
            
        if field_type in ['array','multiref']
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