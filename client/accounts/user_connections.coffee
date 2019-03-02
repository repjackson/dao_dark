Template.user_connections.onCreated ->
    @autorun => Meteor.subscribe 'all_users', Router.current().params.username

    
    
Template.user_connections.helpers
    connections: ->
        Meteor.users.find {}

Template.user_connections.events
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
            
        
