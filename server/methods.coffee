Meteor.methods
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
    
    
    clear_crime: ->
        count = Docs.remove({'X':$exists:true})
        console.log count
    
    rename: (old_keyname, new_keyname)->
        console.log 'start renaming', old_keyname, 'to', new_keyname
        
        old_count = Docs.find({"#{old_keyname}":$exists:true}).count()
        console.log 'found',old_count,'of',old_keyname
        
        new_count = Docs.find({"#{new_keyname}":$exists:true}).count()
        console.log 'found',new_count,'of',new_keyname
        
        
        result2 = Docs.update({"#{old_keyname}":$exists:true}, {$rename:"_#{old_keyname}":"_#{new_keyname}"}, {multi:true})
        result = Docs.update({"#{old_keyname}":$exists:true}, {$rename:old_keyname:new_keyname}, {multi:true})
        
        # > Docs.update({doc_sentiment_score:{$exists:true}},{$rename:{doc_sentiment_score:"sentiment_score"}},{multi:true})

        console.log 'mongo update call finished:',result
        
        cursor = Docs.find({new_keyname:$exists:true}, { fields:_id:1 })

        for doc in cursor.fetch()
            Meteor.call 'key', doc._id

        console.log 'done renaming', old_keyname, 'to', new_keyname
            
        console.log 'result1', result
        console.log 'result2', result2
        
        
    move_youtube: ->
        found = Docs.find({"_video.youtube_id":$exists:true}).fetch()
        
        for doc in found
            Docs.update( doc._id, {
                $set: video:doc._video.youtube_id
                }, {multi:true})
            
    timestamp_tag: ->
        timestamp_cursor = 
            Docs.find {
                _timestamp:$exists:true
                timestamp_tags:$exists:false
            }, limit:10000
        count = timestamp_cursor.count()
        console.log 'found',count,'docs with timestamp'
        
        for doc in timestamp_cursor.fetch()
            date = moment(doc._timestamp).format('Do')
            weekdaynum = moment(doc._timestamp).isoWeekday()
            weekday = moment().isoWeekday(weekdaynum).format('dddd')
        
        
            month = moment(doc._timestamp).format('MMMM')
            year = moment(doc._timestamp).format('YYYY')
        
            date_array = [weekday, month, date, year]
            if _
                date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
                # date_array = _.each(date_array, (el)-> console.log(typeof el))
                console.log date_array
                Docs.update doc._id,
                    timestamp_tags: date_array

                