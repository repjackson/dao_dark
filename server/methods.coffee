Meteor.methods
    crawl_fields: (specific_key)->
        start = Date.now()
        
        if specific_key
            filter = { "#{specific_key}":$exists:true }
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

    detect_fields: (doc_id)->
        doc = Docs.findOne doc_id
        keys = _.keys doc
        light_fields = _.reject( keys, (key)-> key.startsWith '_' )
        # console.log light_fields
        
        Docs.update doc._id,
            $set:_keys:light_fields
        
        for key in light_fields
            value = doc["#{key}"]
            
            meta = {}
            
            js_type = typeof value
            
            # console.log 'key type', key, js_type

            if js_type is 'object'        
                meta.object = true
                if Array.isArray value
                    meta.array = true
                    meta.length = value.length
                    meta.array_element_type = typeof value[0]
                    meta.brick = 'array'
                else
                    if key is 'watson'
                        meta.brick = 'watson'
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

                youtube_check = /((\w|-){11})(?:\S+)?$/
                youtube_result = youtube_check.test value

                if key is 'html'
                    meta.html = true
                    meta.brick = 'html'
                else if html_result
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
                # else if youtube_result
                #     meta.youtube = true
                #     meta.brick = 'youtube'
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

    remove_field_globally: (keyname)->
        console.log 'removing', keyname, 'globally' 
        result = Docs.update({"#{keyname}":$exists:true}, {
            $unset: 
                "#{keyname}": 1
                "_#{keyname}": 1
            $pull:_keys:keyname
            }, {multi:true})
        console.log result
        console.log 'removed', keyname, 'globally' 
        
    
    
    clear_crime: ->
        count = Docs.remove({'X':$exists:true})
        console.log count
    
    rename: (old_keyname, new_keyname)->
        console.log 'start renaming', old_keyname, 'to', new_keyname
        
        old_count = Docs.find({"#{old_keyname}":$exists:true}).count()
        console.log 'found',old_count,'of',old_keyname
        
        new_count = Docs.find({"#{new_keyname}":$exists:true}).count()
        console.log 'found',new_count,'of',new_keyname
        
        
        result = Docs.update({"#{old_keyname}":$exists:true}, {
            $rename:
                old_keyname: new_keyname
                # "_#{old_keyname}": "_#{new_keyname}"
            }, {multi:true})
        
        result2 = Docs.update({"#{old_keyname}":$exists:true}, {
            $rename:
                # old_keyname: new_keyname
                "_#{old_keyname}": "_#{new_keyname}"
            }, {multi:true})
        
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
            
        