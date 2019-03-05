Template.user_tasks.onCreated ->
    @autorun => Meteor.subscribe 'assigned_tasks',
        Router.current().params.username
        Session.get 'view_complete'



Template.user_tasks.helpers
    view_complete_class: ->
        if Session.equals('view_complete',true) then 'blue' else ''

    assigned_tasks: ->
        Docs.find
            type:'task'
            assigned_username:Router.current().params.username

Template.user_tasks.events
    'click .view_complete': ->
        Session.set 'view_complete', !Session.get('view_complete')

    'keyup .assign_task': (e,t)->
        if e.which is 13
            post = t.$('.assign_task').val().trim()
            console.log post
            current_user = Meteor.users.findOne username:Router.current().params.username
            Docs.insert
                body:post
                type:'task'
                assigned_user_id:current_user._id
                assigned_username:current_user.username

            t.$('.assign_task').val('')


Template.user_wall.events
    'click .remove_comment': ->
        if confirm 'Remove Comment?'
            Docs.remove @_id

    'click .vote_up_comment': ->
        if @upvoters and Meteor.userId() in @upvoters
            Docs.update @_id,
                $inc:points:1
                $addToSet:upvoters:Meteor.userId()
            Meteor.users.update @author_id,
                $inc:points:-1
        else
            Meteor.users.update @author_id,
                $pull:upvoters:Meteor.userId()
                $inc:points:1
            Meteor.users.update @author_id,
                $inc:points:1

    'click .mark_comment_read': ->
        Docs.update @_id,
            $addToSet:readers:Meteor.userId()
