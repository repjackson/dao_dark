Meteor.methods
    crawl_fields: ->
        start = Date.now()

        found_cursor = Docs.find {}, { fields:{_id:1},limit:20000 }
        
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
            value = doc["#{key}"]
            
            meta = {}
            
            js_type = typeof value
            
            # console.log js_type

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
                meta.length = value.length

                html_check = /<[a-z][\s\S]*>/i
                html_result = html_check.test value
                
                url_check = /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/
                url_result = url_check.test value

                if url_result
                    meta.url = true
                    meta.brick = 'url'
                else if value.length is 11
                    meta.youtube = true
                    meta.brick = 'youtube'
                else if html_result
                    meta.html = true
                    meta.brick = 'html'
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
        
        