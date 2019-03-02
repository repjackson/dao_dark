Template.user_blog.onCreated ->
    @autorun => Meteor.subscribe 'type', 'post'

    
    
Template.user_blog.helpers
    user_posts: ->
        Docs.find
            type:'post'


Template.user_blog.events
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
            
        
