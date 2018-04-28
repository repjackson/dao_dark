Meteor.methods 
    enroll: (slug)->
        Meteor.users.update Meteor.userId(),
            $addToSet: courses: slug
            
            
    generate_upvoted_cloud: ->
        match = {}
        match.upvoters = $in: [Meteor.userId()]
        match.type = 'facet'

        
        upvoted_cloud = Docs.aggregate [
            { $match: match }
            { $project: tags: 1 }
            { $unwind: '$tags' }
            { $group: _id: '$tags', count: $sum: 1 }
            { $sort: count: -1, _id: 1 }
            { $limit: 100 }
            { $project: _id: 0, name: '$_id', count: 1 }
            ]
        upvoted_list = (tag.name for tag in upvoted_cloud)
        Meteor.users.update Meteor.userId(),
            $set:
                upvoted_cloud: upvoted_cloud
                upvoted_list: upvoted_list


    find_top_doc_matches: (doc_id)->
        doc = Docs.findOne doc_id
        match_doc_array = Docs.find({tags:$in:doc.tags}).fetch()
        
        matching_docs = []
        for match_doc in match_doc_array
            matching_tags = _.intersection match_doc.tags, doc.tags
            matching_doc_object = {
                _id:match_doc._id
                matching_tags:matching_tags
                matching_tag_count:matching_tags.length }
            matching_docs.push matching_doc_object
            
        sorted_matched = _.sortBy matching_docs, 'matching_tag_count'
        sliced_matches = sorted_matched[-10..]
        Docs.update doc_id,
            $set: doc_matches:sliced_matches



            
    # generate_downvoted_cloud: ->
    #     match = {}
    #     match.downvoters = $in: [Meteor.userId()]
    #     match.type = 'facet'
    #     downvoted_cloud = Docs.aggregate [
    #         { $match: match }
    #         { $project: tags: 1 }
    #         { $unwind: '$tags' }
    #         { $group: _id: '$tags', count: $sum: 1 }
    #         { $sort: count: -1, _id: 1 }
    #         { $limit: 100 }
    #         { $project: _id: 0, name: '$_id', count: 1 }
    #         ]
    #     downvoted_list = (tag.name for tag in downvoted_cloud)
    #     Meteor.users.update Meteor.userId(),
    #         $set:
    #             downvoted_cloud: downvoted_cloud
    #             downvoted_list: downvoted_list
            
            
            
    # add_doc: (body, parent_id, tags) ->
    #     result = Docs.insert
    #         body: body
    #         parent_id: parent_id
    #         tags: tags
    #     console.log result
                
                
                
    update_username:  (username) ->
        userId = Meteor.userId()
        if not userId
            throw new Meteor.Error(401, "Unauthorized")
        Accounts.setUsername(userId, username)
        return "Updated Username: #{username}"
        
        
    update_email: (new_email) ->
        userId = Meteor.userId();
        if !userId
            throw new Meteor.Error(401, "Unauthorized");
        Accounts.addEmail(userId, new_email);
        return "Updated Email to #{new_email}"
        
        
        
    # send_new_message_email: (user_id, message_id) ->
    #     user = Meteor.users.findOne user_id
    #     message = Messages.findOne message_id
    #     console.log "Sending new message email #{user.username}"
    #     SSR.compileTemplate 'message_email', Assets.getText('emailTemplates/message_email.html')
    #     email_data = 
    #         registrationFullName: device.adminName
    #         climberName: device.climberName
    #         adminemail_address: device.adminemail_address
    #     Meteor.defer ->
    #         Email.send
    #             to: "<#{email_address}>"
    #             from: 'Versaclimber'
    #             subject: 'Versaclimber Administration Invitation`'
    #             html: SSR.render('message_email', email_data)


    # generate_journal_cloud: (user_id)->
    #     match = {}
    #     match.author_id = user_id
    #     match.type = 'journal'
        
    #     # console.log 'journal match', match
    #     journal_cloud = Docs.aggregate [
    #         { $match: match }
    #         { $project: tags: 1 }
    #         { $unwind: '$tags' }
    #         { $group: _id: '$tags', count: $sum: 1 }
    #         { $sort: count: -1, _id: 1 }
    #         { $limit: 50 }
    #         { $project: _id: 0, name: '$_id', count: 1 }
    #         ]
    #     journal_list = (tag.name for tag in journal_cloud)
    #     Meteor.users.update user_id,
    #         $set:
    #             journal_cloud: journal_cloud
    #             journal_list: journal_list

    # generate_checkin_cloud: (user_id)->
    #     match = {}
    #     match.author_id = user_id
    #     match.type = 'checkin'
        
    #     checkin_cloud = Docs.aggregate [
    #         { $match: match }
    #         { $project: tags: 1 }
    #         { $unwind: '$tags' }
    #         { $group: _id: '$tags', count: $sum: 1 }
    #         { $sort: count: -1, _id: 1 }
    #         { $limit: 50 }
    #         { $project: _id: 0, name: '$_id', count: 1 }
    #         ]
    #     checkin_list = (tag.name for tag in checkin_cloud)
    #     Meteor.users.update user_id,
    #         $set:
    #             checkin_cloud: checkin_cloud
    #             checkin_list: checkin_list



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


    create_message: (recipient_id, text, parent_id)->
        # console.log 'recipient_id', recipient_id
        
        found_conversation = Docs.findOne
            type: 'conversation'
            participant_ids: $all: [Meteor.userId(), recipient_id]
            
        if found_conversation 
            # console.log 'found conversation with id:', found_conversation._id
            convo_id = found_conversation._id
        else
            new_conversation_id = 
                Docs.insert
                    type: 'conversation'
                    participant_ids: [Meteor.userId(), recipient_id]
            # console.log 'convo NOT found, created new one with id:', new_conversation_id
            convo_id = new_conversation_id
        new_message_id = 
            new_message_id = Docs.insert
                type: 'message'
                group_id: convo_id
                parent_id: parent_id
                body: text
        return new_message_id
        
    verify_email: (user_id)->
        Accounts.sendVerificationEmail(user_id)        
        
        
        
    calculate_doc_responses: (doc_id)->
        doc = Docs.findOne doc_id
        doc_response = Docs.findOne parent_id: doc._id
        if doc_response
            Docs.update doc_id,
                $addToSet: responder_ids: Meteor.userId()
                
        # calculate children_count
        children_count = Docs.find(parent_id:doc_id).count()
        console.log 'children_count', children_count
        Docs.update doc_id,
            $set: children_count: children_count
            
        
    make_ancestor_array: (doc_id)->
        ancestor_array = []
        doc = Docs.findOne doc_id
        current_id = 
        while doc.parent_id
            if doc.parent_id
                ancestor_array.push doc.parent_id
                parent = Docs.findOne doc.parent_id
                if parent.parent_id
                    grandparent = Docs.findOne parent.parent_id
                    ancestor_array.push parent.parent_id

    # calculate_child_ancestor_array: (doc_id)->
    #     console.log doc_id
    #     doc = Docs.findOne doc_id
    #     if doc.ancestor_array
    #         child_ancestor_array = doc.ancestor_array
    #     else
    #         child_ancestor_array = []
            
    #     child_ancestor_array.push doc._id
        
    #     result = Docs.update {parent_id:doc_id},
    #         {$set:ancestor_array:child_ancestor_array},
    #         {multi:true}
    #     console.log result
        
    #     # parent_doc = Docs.findOne doc_id
    #     for child_doc in Docs.find(parent_id:doc_id).fetch()
    #         Meteor.call 'calculate_child_ancestor_array', child_doc._id
    #     #     # console.log 'child_doc', child_doc._id
    #     #     child_ancestor_array = parent_doc.ancestor_array
    #     #     child_ancestor_array.push parent_doc._id
    #     #     console.log child_ancestor_array
            
            
    # # calculate_child_ancestor_array: (doc_id)->
            
    submit_contact_submission: (name, email, message)->
        Docs.insert
            type: 'contact_submission'
            name: name
            email: email
            message: message
                    
                    
    notify_user_about_document: (doc_id, recipient_id)->
        doc = Docs.findOne doc_id
        parent = Docs.findOne doc.parent_id
        recipient = Meteor.users.findOne recipient_id
        
        
        doc_link = "/view/#{doc._id}"
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
            