if Meteor.isClient
    Template.tribe_layout.onCreated ->
        @autorun => Meteor.subscribe 'tribe_from_slug', Router.current().params.slug
        
    
    Template.tribe_topnav.onCreated ->
        @autorun => Meteor.subscribe 'users'
        @autorun => Meteor.subscribe 'type', 'field'
        # @autorun => Meteor.subscribe 'type', 'schema'
    
    Template.tribe_topnav.helpers
        user: -> Meteor.users.findOne username:Router.current().params.username
    
    Template.tribe_topnav.events
        'click .add': ->
            new_id = Docs.insert {}
            Router.go "/edit/#{new_id}"
    
        'click .toggle_dev': ->
            Session.set('dev_mode', !Session.get('dev_mode'))
    
        'click .set_schema': ->
            Session.set 'loading', true
            Meteor.call 'set_delta_facets', @slug, ->
                Session.set 'loading', false
    
    
if Meteor.isServer
    Meteor.publish 'tribe_from_slug', (slug)->
        Docs.find
            type:'tribe'
            slug:slug