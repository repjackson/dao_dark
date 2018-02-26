Template.karma.events
    'click #add_points': ->
        # console.log 'hi'
        Meteor.users.update Meteor.userId(),
            $inc: points: 1
            
Template.top_posts.onCreated ->
    @autorun -> Meteor.subscribe 'top_posts'
    
Template.top_posts.helpers
    top_posts: ->
        Docs.find {},
            {
                sort: points:-1
                limit: 10
            }



Template.top_people.onCreated ->
    @autorun -> Meteor.subscribe 'all_people'
    
Template.top_people.helpers
    top_users: ->
        Meteor.users.find {},
            {
                sort: points:-1
                limit: 10
            }

    