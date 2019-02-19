if Meteor.isClient
    Template.layout.onCreated ->
        @autorun => Meteor.subscribe 'tribe_from_slug', Router.current().params.tribe_slug
        
    
    
    
if Meteor.isServer
    Meteor.publish 'tribe_from_slug', (slug)->
        Docs.find
            type:'tribe'
            slug:slug