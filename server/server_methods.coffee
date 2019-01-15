Meteor.methods
    crawl_fields: ->
        start = Date.now()

        found_cursor = Docs.find {detected:$ne:1}, { fields:{_id:1},limit:10000 }
        
        undetected = found_cursor.count()
        current_number = 0
        
        for found in found_cursor.fetch()
            res = Meteor.call 'detect_fields', found._id
            console.log 'detected',res, current_number, 'of', undetected
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
        console.log light_fields
        
        Docs.update doc._id,
            $set:_keys:light_fields
        
        for key in light_fields
            value = doc["#{key}"]
            
            meta = {}
            
            js_type = typeof value
            
            console.log 'key type', key, js_type

            if js_type is 'object'        
                meta.object = true
                if Array.isArray value
                    meta.array = true
                    meta.length = value.length
                    meta.array_element_type = typeof value[0]
                    meta.brick = 'array'
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

                if html_result
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
                else if value.length is 11
                    meta.youtube = true
                    meta.brick = 'youtube'
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
            $set:detected:1
        # console.log 'detected fields', doc_id
        
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
        