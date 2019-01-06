Docs.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> true
    update: (userId, doc) -> true
    remove: (userId, doc) -> true



Meteor.publish 'delta', ->
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
    
    import_array: (from)->
        console.log 'moving array',from
        cursor = Docs.find({"#{from}":$exists:true}, {limit:3})
        console.log 'found', cursor.count(),'docs with', from
        for doc in cursor.fetch()
            console.log 'moving keys', doc.keywords, 
            result = Docs.update {},
                {$addToSet: tags: $each: doc.keywords}
                
            new_doc = Docs.findOne doc._id
            console.log 'new version', new_doc.tags
        
    keys: ->
        cur = Docs.find({keys:$exists:false})
        for doc in cur.fetch()
            keys = _.keys doc
            console.log keys
            Docs.update doc._id,
                $set:keys:keys
    
    clean: ->
        found = 
            Docs.find
                tags:$exists:false
        console.log found.count()
    
    
    lowercase_tags: ->
        cur = Docs.find({tags:$exists:true})
        for doc in cur.fetch()
            console.log 'turning', doc.tags
            tags = _.map(doc.tags, (tag)->tag.toLowerCase())
            console.log 'into', tags
            Docs.update doc._id,
                $set:tags:tags
    
    remove_key: (key)->
        console.log 'removing key', key
        filter = {"#{key}":$exists:true}
        console.log Docs.find(filter).count()
        Docs.update filter,
            {$unset:"#{key}"}
    
    fum: ()->
        # console.log 'running fum'
        
        delta = Docs.findOne type:'delta'

        unless delta
            new_id = Docs.insert 
                type:'delta'
                fi:[]
                fo:[]
            delta = Docs.findOne new_id
        # console.log 'delta', delta
        
        built_query = { type:$ne:'delta' }
        if delta.fi.length > 0
            built_query["tags"] = $all: delta.fi
        
        total = Docs.find(built_query).count()
        # console.log 'built query', built_query
        
        # response
        agg_res = Meteor.call 'agg', built_query, delta.fi

        results_cursor = Docs.find built_query, 
            { 
                fields:
                    _id:1
                limit:1
                sort:
                    tag_count:1
            }

        result_id = results_cursor.fetch()

        Docs.update {_id:delta._id},
            {
                $set:
                    fo:agg_res
                    total:total
                    result_id:result_id
            }
            
        delta = Docs.findOne delta._id    
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