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
        # fields = doc.fields
        fields = []
        
        for key in keys
            fo = {} #field object    
            value = doc["#{key}"]
            
            fo.key = key
            
            js_type = typeof value
            
            label = key.charAt(0).toUpperCase() + key.slice(1).toLowerCase();
            fo.label = label

            if js_type is 'object'        
                fo.object = true
                if Array.isArray value
                    fo.array = true
                    fo.length = value.length
                    fo.array_element_type = typeof value[0]
                
                    
            else if js_type is 'number'
                fo.number = true
                d = Date.parse(value)
                # nan = isNaN d
                # !nan
                if value < 0
                    fo.negative = true
                else if value > 0
                    fo.positive = false
                    
                integer = Number.isInteger(value)
                if integer
                    fo.integer = true
                
                                
            else if js_type is 'string'
                fo.string = true
                html_check = /<[a-z][\s\S]*>/i
                html_result = html_check.test value
                
                if html_result
                    fo.html = true
                user_check = Meteor.users.findOne value
                if user_check
                    fo.user_id = true
                
                doc_check = Docs.findOne value
                if doc_check
                    fo.doc_id = true
                
            # console.log 'adding field object', fo    
            fields.push fo
                    
        # console.log 'fields length', fields.length
        # unique = _.uniq fields
        # console.log 'unique length', unique.length
                    
        Docs.update doc_id,
            $set: 
                fields: fields
                keys: keys
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
                keys:'_keys'
                timestamp_tags:'_timestamp_tags'
                author_id:'_author_id'
                key_count: '_key_count'
            }, {multi:true})
        console.log result
        console.log 'hi'
        
        