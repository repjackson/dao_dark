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
    doc.read_by = [Meteor.userId()]
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




Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()

    is_visible: -> @published in [0,1]
    is_published: -> @published is 1
    is_anonymous: -> @published is 0
    is_private: -> @published is -1

    five_tags: -> if @tags then @tags[0..4]

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


FlowRouter.notFound =
    action: ->
        BlazeLayout.render 'layout', 
            main: 'not_found'


FlowRouter.route '/', 
    # title: Meteor.settings.public.site.short - "Home"
    action: ->
        BlazeLayout.render 'layout', 
            main: 'home'




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
