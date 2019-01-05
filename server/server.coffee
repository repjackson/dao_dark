Docs.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> true
    update: (userId, doc) -> true
    remove: (userId, doc) -> true



Meteor.publish 'deltas', ->
    Docs.find
        type:'delta'
        
    
Meteor.publish 'doc', (doc_id)->
    Docs.find
        _id:doc_id
        
    
    
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
        
        
        
    count_tags: ->
        cursor = 
            Docs.find({
                tag_count:
                    $exists:false
                tags:
                    $exists:true
            }, {limit:100})
        count = cursor.count()
        console.log 'found',count,'uncounted tags'
        for uncounted in cursor.fetch()
            tag_count = uncounted.tags.length
            console.log 'tag count', tag_count
            Docs.update uncounted._id,
                $set:tag_count:tag_count
            console.log 'counted', uncounted.tags
                    

    rename:(from,to)->
        console.log 'renaming keys from',from,'to',to
        count = Docs.find("#{from}":$exists:true).count()
        console.log 'found', count,'docs with', from
        
        result = Docs.update {"#{from}":$exists:true},
            {$rename: "#{from}": to
            }, {multi:true}
        console.log result
    
    move_key: (from,to)->
        console.log 'moving key',from,'to',to
        count = Docs.find("#{from}":$exists:true).count()
        console.log 'found', count,'docs with', from
        
        result = Docs.update {"#{from}":$exists:true},
            {$rename: "#{from}": to
            }, {multi:true}
        console.log result
        
    
    
    fum: (delta_id)->
        console.log 'running fum', delta_id
        delta = Docs.findOne delta_id

        # console.log 'delta', delta
        if delta
            built_query = {}
            if delta.fi.length > 0
                built_query["tags"] = $all: delta.fi
            
            total = Docs.find(built_query).count()
            console.log 'built query', built_query
            
            # response
            agg_res = Meteor.call 'agg', built_query, delta.fi
    
            results_cursor = Docs.find built_query, { fields:{_id:1}, limit:1 }
    
            result_id = results_cursor.fetch()
    
            Docs.update {_id:delta_id},
                {
                    $set:
                        fo:agg_res
                        result_id:result_id
                }
                
            delta = Docs.findOne delta_id    
            # console.log 'delta', delta

    agg: (query, fi)->
        limit=42
        options = { explain:false }
        pipe =  [
            { $match: query }
            { $project: "tags": 1 }
            { $unwind: "$tags" }
            { $group: _id: "$tags", count: $sum: 1 }
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