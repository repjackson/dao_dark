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
            
        
