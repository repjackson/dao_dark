@Docs = new Meteor.Collection 'docs'


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
    doc.timestamp_tags = date_array

    doc.author_id = Meteor.userId()
    return
    
    
    
# Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
#     if doc.tags
#         doc._tag_count = doc.tags.length
#     # console.log doc
#     # doc.child_count = Meteor.call('calculate_child_count', doc._id)
#     # console.log Meteor.call 'calculate_child_count', doc._id, (err, res)-> return res
# ), fetchPrevious: true


Meteor.methods
    add_facet_filter: (delta_id, key, filter)->
        if key is '_keys'
            new_facet_ob = {
                key:filter
                filters:[]
                res:[]
            }
            Docs.update { _id:delta_id },
                $addToSet: facets: new_facet_ob
        Docs.update { _id:delta_id, "facets.key":key},
            $addToSet: "facets.$.filters": filter
        
        Meteor.call 'fum', delta_id, (err,res)->
            
            
    remove_facet_filter: (delta_id, key, filter)->
        if key is '_keys'
            Docs.update { _id:delta_id },
                $pull:facets: {key:filter}
        Docs.update { _id:delta_id, "facets.key":key},
            $pull: "facets.$.filters": filter
        Meteor.call 'fum', delta_id, (err,res)->


Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()

    is_visible: -> @published in [0,1]
    is_published: -> @published is 1
    is_anonymous: -> @published is 0
    is_private: -> @published is -1

    parent: -> Docs.findOne @parent_id

    five_tx: -> if @tx then @tx[0..4]
    five_inputs: -> if @inputs then @inputs[0..4]
    five_out: -> if @out then @out[0..4]

    five_tags: -> if @tags then @tags[0..4]

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
    