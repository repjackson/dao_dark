Meteor.methods 
    site_stat: ->
        doc_count = Docs.find({}).count()
        user_count = Meteor.users.find({}).count()
        Docs.insert
            type:'stat'
            doc_count:doc_count
            user_count:user_count
    
    
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
    
    calculate_user_match: (username)->
        my_cloud = Meteor.user().cloud
        other_user = Meteor.users.findOne "profile.name": username
        console.log username
        console.log other_user
        Meteor.call 'generate_personal_cloud', other_user._id
        other_cloud = other_user.cloud

        my_linear_cloud = _.pluck(my_cloud, 'name')
        other_linear_cloud = _.pluck(other_cloud, 'name')
        intersection = _.intersection(my_linear_cloud, other_linear_cloud)
        console.log intersection

    notify_user_about_document: (doc_id, recipient_id)->
        doc = Docs.findOne doc_id
        parent = Docs.findOne doc.parent_id
        recipient = Meteor.users.findOne recipient_id
        
        
        doc_link = "/v/#{doc._id}"
        notification = 
            Docs.findOne
                type:'notification'
                object_id:doc_id
                recipient_id:recipient_id
        if notification
            throw new Meteor.Error 500, 'User already notified.'
            return
        else
            Docs.insert
                type:'notification'
                object_id:doc_id
                recipient_id:recipient_id
                content: 
                    "<p>#{Meteor.user().name()} has notified you about <a href=#{doc_link}>#{parent.title} entry</a>.</p>"
                
                
    remove_notification: (doc_id, recipient_id)->
        doc = Docs.findOne doc_id
        recipient = Meteor.users.findOne recipient_id
        
        notification = 
            Docs.findOne
                type:'notification'
                object_id:doc_id
                recipient_id:recipient_id
        
        if notification 
            Docs.remove notification._id
        else
            console.log 'trying to remove unknown notification'
                
        return
                
                
    send_message: (username, message)->
        recipient = Meteor.users.findOne username:username
        console.log message
        Docs.insert
            recipient_id: recipient._id
            text: message
            type:'message'
            
            
    calculate_child_count: (doc_id)->
        child_count = Docs.find(parent_id: doc_id).count()
        Docs.update doc_id, 
            $set: child_count: child_count
        
    fetch_latest_block: ->        
        request = HTTP.get 'https://blockchain.info/latestblock', (err,res)->
            if err then console.error err
            else
                
                console.log res.data
                existing_block = 
                    Docs.findOne 
                        type:'block'
                        hash: res.data.hash
                if existing_block
                    return existing_block._id
                else
                    Docs.insert
                        type: 'block'
                        hash: res.data.hash
                        time: res.data.time
                        block_index: res.data.block_index
                        height: res.data.height
            
    get_block_details: (hash)->        
        request = HTTP.get "https://blockchain.info/rawblock/#{hash}", (err,res)->
            if err then console.error err
            else
                
                console.log res.data.tx
                block = res.data
                existing_block = 
                    Docs.findOne 
                        type:'block'
                        hash: res.data.hash
                if existing_block
                    # return existing_block._id
                    Docs.update existing_block._id,
                        $set:
                            hash: block.hash
                            time: block.time
                            block_index: block.block_index
                            height: block.height
                            ver: block.ver
                            prev_block: block.prev_block
                            mrkl_root: block.mrkl_root
                            bits: block.bits
                            fee: block.fee
                            nonce: block.nonce
                            main_chain: block.main_chain
                            relayed_by: block.relayed_by
                            tx: block.tx
                else
                    Docs.insert
                        type: 'block'
                        hash: block.hash
                        time: block.time
                        block_index: block.block_index
                        height: block.height
            
    get_transaction_details: (hash)->        
        request = HTTP.get "https://blockchain.info/rawtx/#{hash}", (err,res)->
            if err then console.error err
            else
                
                # console.log res.data
                transaction = res.data
                existing_transaction = 
                    Docs.findOne 
                        type:'transaction'
                        hash: res.data.hash
                if existing_transaction
                    # return existing_transaction._id
                    Docs.update existing_transaction._id,
                        $set:
                            hash: transaction.hash
                            ver: transaction.ver
                            block_height: transaction.block_height
                            relayed_by: transaction.relayed_by
                            tx_index: transaction.tx_index
                            lock_time: transaction.lock_time
                            size: transaction.size
                            double_spend: transaction.double_spend
                            time: transaction.time
                            vin_sz: transaction.vin_sz
                            vout_sz: transaction.vout_sz
                            inputs: transaction.inputs
                            out: transaction.out
                else
                    Docs.insert
                        type: 'transaction'
                        hash: transaction.hash
            
        
    change_ownership: (doc_id, user_id, percent)->
        doc = Docs.findOne doc_id
        if not doc.ownership?
            Docs.update doc_id,
                $set:
                    ownership:
                        [{user_id:doc.author_id,percent: 100}]
        else if doc.ownership.user_id
            Docs.update {_id:doc_id, "ownership.user_id":user_id}, 
                $set:
                    "ownership.$": percent 
        
    calculate_owner_ids: (doc_id)->
        doc = Docs.findOne doc_id
        if doc.ownership
            owner_ids = _.pluck doc.ownership, 'user_id'
            console.log owner_ids
            Docs.update doc_id,
                $set: owner_ids: owner_ids
        else
            Docs.update doc_id,
                $set:
                    ownership:
                        [{user_id: doc.author_id, percent:100}]
            