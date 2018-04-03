@Tags = new Meteor.Collection 'tags'
@Docs = new Meteor.Collection 'docs'
@People_tags = new Meteor.Collection 'people_tags'

Meteor.users.helpers
    name: -> 
        if @profile?.first_name and @profile?.last_name
            "#{@profile.first_name}  #{@profile.last_name}"
        else
            "#{@username}"
    last_login: -> 
        moment(@status?.lastLogin.date).fromNow()

    five_tags: -> if @tags then @tags[0..3]
    
            
Docs.before.insert (userId, doc)=>
    timestamp = Date.now()
    doc.timestamp = timestamp
    # console.log moment(timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")
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
    # doc.read_by = [Meteor.userId()]
    doc.ownership = [{user_id: Meteor.userId(),percent: 100}]
    doc.upvoters = []
    doc.downvoters = []
    # doc.published = 0
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



FlowRouter.notFound =
    action: ->
        BlazeLayout.render 'layout', 
            main: 'not_found'


FlowRouter.route '/', 
    name:'home'
    action: ->
        BlazeLayout.render 'layout', 
            main: 'library'



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
        # Meteor.call 'generate_upvoted_cloud', Meteor.userId()

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
        # Meteor.call 'generate_downvoted_cloud', Meteor.userId()
