@Docs = new Meteor.Collection 'docs'


Meteor.users.helpers
    name: -> 
        if @profile?.display_name
            "#{@profile.display_name}"
        else
            "#{@username}"
    last_login: -> 
        moment(@status?.lastLogin.date).fromNow()

    five_tags: -> if @tags then @tags[0.3]

            
Docs.before.insert (userId, doc)=>
    timestamp = Date.now()
    doc.timestamp = timestamp
    doc.timestamp_long = moment(timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")
    date = moment(timestamp).format('Do')
    weekdaynum = moment(timestamp).isoWeekday()
    weekday = moment().isoWeekday(weekdaynum).format('dddd')


    month = moment(timestamp).format('MMMM')
    year = moment(timestamp).format('YYYY')

    date_array = [weekday, month, date, year]
    if _
        date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
    # date_array = _.each(date_array, (el)-> console.log(typeof el))
    # console.log date_array
        doc.timestamp_tags = date_array

    doc.author_id = Meteor.userId()
    doc.tag_count = doc.tags?.length
    doc.points = 0
    doc.read_by = [Meteor.userId()]
    doc.ownership = [{user_id: Meteor.userId(),percent: 100}]
    doc.upvoters = []
    doc.downvoters = []
    doc.published = 0
    return

Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
    if doc.tags
        doc.tag_count = doc.tags.length
    # console.log doc
    # doc.child_count = Meteor.call('calculate_child_count', doc._id)
    # console.log Meteor.call 'calculate_child_count', doc._id, (err, res)-> return res
), fetchPrevious: true


# Docs.before.update (userId, doc, fieldNames, modifier, options) ->
#   modifier.$set = modifier.$set or {}
#   modifier.$set.tag_count = doc.tags.length
#   return


Docs.after.insert (userId, doc)->
    if doc.parent_id
        Meteor.call 'calculate_child_count', doc.parent_id
        parent = Docs.findOne doc.parent_id
        if parent.ancestor_array
            new_ancestor_array = parent.ancestor_array
            new_ancestor_array.push parent._id
            Docs.update doc._id,
                $set:ancestor_array:new_ancestor_array
    
Docs.after.remove (userId, doc)->
    if doc.parent_id
        Meteor.call 'calculate_child_count', doc.parent_id


Meteor.methods
    add_facet_filter: (delta_id, key, filter)->
        if key is 'keys'
            Docs.update { _id:delta_id},
                $addToSet: facets: key:filter
        Docs.update { _id:delta_id, "facets.key":key},
            $addToSet: "facets.$.filters": filter
        Meteor.call 'fo', (err,res)->
            
            
    remove_facet_filter: (delta_id, key, filter)->
        if key is 'keys'
            Docs.update { _id:delta_id},
                $pull:facets: key:filter
        Docs.update { _id:delta_id, "facets.key":key},
            $pull: "facets.$.filters": filter
        Meteor.call 'fo', (err,res)->
            
            
    update_field: (doc_id, field_object, key, value)->
        console.log doc_id
        console.log field_object
        console.log key
        console.log value
        console.log doc_id
        Docs.update {_id:doc_id, fields:field_object},
            { $set: "fields.$.#{key}":value }


    detect_fields: (doc_id)->
        doc = Docs.findOne doc_id
        keys = _.keys doc
        console.log keys
        fields = doc.fields
        for key in keys
            Docs.update doc_id,
                $addToSet:
                    fields: 
                        key:key
                        label:key
                        type:'string'
            
            # for field in fields
            #     if field.key and field.key is key
            #         console.log 'found key', key
            #     else
            #         console.log 'didnt find key', key
        # else
        #     Docs.update doc_id,
        #         $set: fields: []
            

Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()

    parent: -> Docs.findOne @parent_id

    five_tx: -> if @tx then @tx[0.4]
    five_inputs: -> if @inputs then @inputs[0.4]
    five_out: -> if @out then @out[0.4]

    five_tags: -> if @tags then @tags[0.4]

    has_ownership: -> 
        # console.log 'checking if has ownership'
        if @ownership 
            if @owner_ids
                if Meteor.userId() in @owner_ids
                    # console.log 'has_ownership'
                    return true
                else
                    false
            else
                Meteor.call 'calculate_owner_ids', @_id
                false
    
    # owner_ids: ->
    #     console.log 'loading owner ids'
    #     if @ownership
    #         _.pluck @ownership, 'user_id'
            
    my_ownership: ->
        if @ownership
            my_ownership_object = (_.findWhere(@ownership, {user_id:Meteor.userId()}))
            my_ownership_object.percent

    up_voted: -> @upvoters and Meteor.userId() in @upvoters
    down_voted: -> @downvoters and Meteor.userId() in @downvoters
    upvoted_users: ->
        if @upvoters
            upvoted_users = []
            for upvoter_id in @upvoters
                upvoted_users.push Meteor.users.findOne upvoter_id
            upvoted_users
        else []
    
    read: -> @read_by and Meteor.userId() in @read_by

    children: -> 
        Docs.find {parent_id: @_id}, 
            sort:
                points:-1
                timestamp:-1

    only_child: -> Docs.findOne parent_id: @_id
    parent: -> Docs.findOne @parent_id
    recipient: -> Meteor.users.findOne @recipient_id
    notified_users: -> 
        if @notified_ids
            Meteor.users.find _id:$in:@notified_ids
    subject: -> Meteor.users.findOne @subject_id
    object: -> Docs.findOne @object_id
    has_children: -> if Docs.findOne(parent_id: @_id) then true else false
    
    has_price: -> @dollar_price or @point_price
    
    children: -> 
        Docs.find {parent_id: @_id}, 
            sort:
                timestamp:-1
    public_children: -> 
        Docs.find {parent_id: @_id, published:$in:[0,1]}, 
            sort:
                number:1
                timestamp:-1
    private_children: -> 
        Docs.find {parent_id: @_id, published:-1}, 
            sort:
                number:1
                timestamp:-1
    responded: -> 
        response = Docs.findOne
            author_id: Meteor.userId()
            parent_id: @_id
            type: 'response'
        if response then true else false

    children_count: -> Docs.find({parent_id: @_id}).count() 

    published_children_count: -> Docs.find({parent_id: @_id, published:$in:[0,1]}).count()

    completed: -> 
        # console.log 'complete'
        if @completed_ids and Meteor.userId() in @completed_ids then true else false

    up_voted: -> @upvoters and Meteor.userId() in @upvoters
    down_voted: -> @downvoters and Meteor.userId() in @downvoters

    upvoted_users: ->
        if @upvoters
            upvoted_users = []
            for upvoter_id in @upvoters
                upvoted_users.push Meteor.users.findOne upvoter_id
            upvoted_users
        else []
    
    read: -> @read_by and Meteor.userId() in @read_by
        
    readers: ->
        if @read_by
            readers = []
            for reader_id in @read_by
                readers.push Meteor.users.findOne reader_id
            readers
        else []
    
    child_field_docs: ->
        if @child_field_ids
            Docs.find _id:$in:@child_field_ids
    
    public_child_authors: ->
        if Docs.findOne({parent_id: @_id})
            child_authors = []
            child_documents = Docs.find(parent_id: @_id, published:1).fetch()
            for child_document in child_documents
                # console.log child_document.author_id
                child_authors.push Meteor.users.findOne child_document.author_id
            child_authors
        else 
            []
            # console.log 'we aint found shit'
    child_authors: ->
        if Docs.findOne({parent_id: @_id})
            child_authors = []
            child_documents = Docs.find(parent_id: @_id).fetch()
            for child_document in child_documents
                # console.log child_document.author_id
                child_authors.push Meteor.users.findOne child_document.author_id
            child_authors
        else 
            []
            # console.log 'we aint found shit'

    younger_sibling: ->
        if @number
            previous_number = @number - 1
            Docs.findOne
                parent_id: @parent_id
                number: previous_number

    older_sibling: ->
        if @number
            next_number = @number + 1
            Docs.findOne
                parent_id: @parent_id
                number: next_number


    has_currentuser_grandchildren: ->
        children = Docs.find({parent_id:@_id}).fetch()
        children_count = children.length
        console.log 'children_count', children_count
        grandchildren_count = 0
        for child in children
            grandchild = 
                Docs.findOne 
                    parent_id: child._id
                    author_id: Meteor.userId()
            if grandchild then grandchildren_count++
        console.log 'grandchildren_count', grandchildren_count
        if grandchildren_count is children_count
            console.log 'has all grandchildren'
            return true
        else
            false




Meteor.methods
    vote_up: (id)->
        doc = Docs.findOne id
        if not doc.upvoters
            Docs.update id,
                $set: 
                    upvoters: []
                    downvoters: []
        else if Meteor.userId() in doc.upvoters #undo upvote
            Docs.update id,
                $pull: upvoters: Meteor.userId()
                $inc: points: -1
            Meteor.users.update doc.author_id, $inc: points: -1
            # Meteor.users.update Meteor.userId(), $inc: points: 1

        else if Meteor.userId() in doc.downvoters #switch downvote to upvote
            Docs.update id,
                $pull: downvoters: Meteor.userId()
                $addToSet: upvoters: Meteor.userId()
                $inc: points: 2
            # Meteor.users.update doc.author_id, $inc: points: 2

        else #clean upvote
            Docs.update id,
                $addToSet: upvoters: Meteor.userId()
                $inc: points: 1
            Meteor.users.update doc.author_id, $inc: points: 1
            # Meteor.users.update Meteor.userId(), $inc: points: -1
        Meteor.call 'generate_upvoted_cloud', Meteor.userId()

    vote_down: (id)->
        doc = Docs.findOne id
        if not doc.downvoters
            Docs.update id,
                $set: 
                    upvoters: []
                    downvoters: []
        else if Meteor.userId() in doc.downvoters #undo downvote
            Docs.update id,
                $pull: downvoters: Meteor.userId()
                $inc: points: 1
            # Meteor.users.update doc.author_id, $inc: points: 1
            # Meteor.users.update Meteor.userId(), $inc: points: 1

        else if Meteor.userId() in doc.upvoters #switch upvote to downvote
            Docs.update id,
                $pull: upvoters: Meteor.userId()
                $addToSet: downvoters: Meteor.userId()
                $inc: points: -2
            # Meteor.users.update doc.author_id, $inc: points: -2

        else #clean downvote
            Docs.update id,
                $addToSet: downvoters: Meteor.userId()
                $inc: points: -1
            # Meteor.users.update doc.author_id, $inc: points: -1
            # Meteor.users.update Meteor.userId(), $inc: points: -1
        Meteor.call 'generate_downvoted_cloud', Meteor.userId()


    # favorite: (doc)->
    #     if doc.favoriters and Meteor.userId() in doc.favoriters
    #         Docs.update doc._id,
    #             $pull: favoriters: Meteor.userId()
    #             $inc: favorite_count: -1
    #     else
    #         Docs.update doc._id,
    #             $addToSet: favoriters: Meteor.userId()
    #             $inc: favorite_count: 1
    
    
    # mark_complete: (doc)->
    #     if doc.completed_ids and Meteor.userId() in doc.completed_ids
    #         Docs.update doc._id,
    #             $pull: completed_ids: Meteor.userId()
    #             $inc: completed_count: -1
    #     else
    #         Docs.update doc._id,
    #             $addToSet: completed_ids: Meteor.userId()
    #             $inc: completed_count: 1
    
    
    # bookmark: (doc)->
    #     if doc.bookmarked_ids and Meteor.userId() in doc.bookmarked_ids
    #         Docs.update doc._id,
    #             $pull: bookmarked_ids: Meteor.userId()
    #             $inc: bookmarked_count: -1
    #     else
    #         Docs.update doc._id,
    #             $addToSet: bookmarked_ids: Meteor.userId()
    #             $inc: bookmarked_count: 1
    
    # pin: (doc)->
    #     if doc.pinned_ids and Meteor.userId() in doc.pinned_ids
    #         Docs.update doc._id,
    #             $pull: pinned_ids: Meteor.userId()
    #             $inc: pinned_count: -1
    #     else
    #         Docs.update doc._id,
    #             $addToSet: pinned_ids: Meteor.userId()
    #             $inc: pinned_count: 1
    
    # subscribe: (doc)->
    #     if doc.subscribed_ids and Meteor.userId() in doc.subscribed_ids
    #         Docs.update doc._id,
    #             $pull: subscribed_ids: Meteor.userId()
    #             $inc: subscribed_count: -1
    #     else
    #         Docs.update doc._id,
    #             $addToSet: subscribed_ids: Meteor.userId()
    #             $inc: subscribed_count: 1
    
    
    