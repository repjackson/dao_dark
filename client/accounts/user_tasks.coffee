Template.user_tasks.onCreated ->
    @autorun => Meteor.subscribe 'assigned_tasks', Router.current().params.username

    
    
Template.user_tasks.helpers
    assigned_tasks: ->
        Docs.find
            type:'task'
            assigned_username:Router.current().params.username


Template.user_tasks.events
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
            
        
