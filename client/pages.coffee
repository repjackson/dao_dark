Template.leaderboard.helpers
    point_leaders: ->
        Meteor.users.find {},
            sort:points:1
            
    karma_leaders: ->
        Meteor.users.find {},
            sort:karma:1
            
            
            
            