Template.tribes.onCreated ->
    @autorun => Meteor.subscribe 'type', 'tribe'
Template.tribes.helpers
    tribes: -> Docs.find type:'tribe'



Template.shop.onCreated ->
    @autorun => Meteor.subscribe 'type', 'product'

Template.shop.helpers
    products: -> Docs.find type:'product'

Template.shop.events

Template.leaderboard.helpers
    point_leaders: ->
        Meteor.users.find {},
            sort:points:1
            
    karma_leaders: ->
        Meteor.users.find {},
            sort:karma:1
            
            
            
            