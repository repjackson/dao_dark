Meteor.methods
    crawl_fields: ->
        start = Date.now()

        # found_cursor = Docs.find {meta:$ne:1}, { fields:{_id:1},limit:10 }
        found_cursor = Docs.find {fields:$exists:false}, { fields:{_id:1},limit:10000 }
        
        for found in found_cursor.fetch()
            Meteor.call 'detect_fields', found._id, (err,res)->
        stop = Date.now()
        
        diff = stop - start
        # console.log diff
        console.log 'duration', moment(diff).format("HH:mm:ss:SS")

    detect_fields: (doc_id)->
        doc = Docs.findOne doc_id
        keys = _.keys doc
        # fields = doc.fields
        console.log 
        
        fields = []
        
        for key in keys
            key_value = doc["#{key}"]
            initial_field_type = typeof key_value
                    
            if initial_field_type is 'object'        
                if Array.isArray key_value
                    field_type = 'array'
                else
                    field_type = 'object'
                    
            else if initial_field_type is 'number'
                # d = Date.parse(key_value)
                # nan = isNaN d
                # !nan
                field_type = 'number'
                                
            else if initial_field_type is 'string'
                html_check = /<[a-z][\s\S]*>/i
                html_result = html_check.test key_value
                if html_result
                    field_type = 'html'
                else
                    field_type = 'string'
                
            label = key.charAt(0).toUpperCase() + key.slice(1).toLowerCase();
            field_object = 
                {
                    key:key
                    label:label
                    field_type:field_type
                }
                
            # console.log 'adding field object', field_object    
            fields.push field_object
                    
        # console.log 'fields length', fields.length
        # unique = _.uniq fields
        # console.log 'unique length', unique.length
                    
        Docs.update doc_id,
            $set: 
                fields: fields
                keys: keys
                meta:1
        console.log 'detected fields', doc_id
        
        return doc_id

    keys: ->
        start = Date.now()
        cursor = Docs.find({keys:$exists:false}, {limit:1000}).fetch()
        for doc in cursor
            keys = _.keys doc
            # console.log doc
            Docs.update doc._id,
                $set:keys:keys
            
            console.log "updated keys for doc #{doc._id}"
        stop = Date.now()
        
        diff = stop - start
        # console.log diff
        console.log 'duration', moment(diff).format("HH:mm:ss:SS")
