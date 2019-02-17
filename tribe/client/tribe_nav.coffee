  

Template.tribe_topnav.onCreated ->
    @autorun => Meteor.subscribe 'users'
    @autorun => Meteor.subscribe 'type', 'field'
    @autorun => Meteor.subscribe 'type', 'schema'

Template.tribe_topnav.helpers
    user: -> Meteor.users.findOne username:Router.current().params.username

Template.tribe_topnav.events
    'click .toggle_invert': ->
        Session.set('invert', !Session.get('invert'))

    'click .add': ->
        new_id = Docs.insert {}
        Router.go "/edit/#{new_id}"

    'click .toggle_dev': ->
        Session.set('dev_mode', !Session.get('dev_mode'))

    'click .set_tribe_schema': ->
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', @slug, ->
            Session.set 'loading', false


Template.tribe_topbar.onCreated ->
    @autorun => Meteor.subscribe 'type', 'page'

Template.tribe_topnav.onCreated ->
    @autorun -> Meteor.subscribe 'type', 'schema'
    

Template.tribe_topnav.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.dropdown').dropdown()
            , 2000



Template.tribe_topnav.helpers
    topnav_schemas: ->
        tribe = Docs.findOne 
            type:'tribe'
            slug:Router.current().params.slug
        
        Docs.find {
            type:'schema'
            tribe:tribe.slug
            topnav_roles:$in:Meteor.user().roles
        }, sort:rank:1

Template.tribe_topbar.helpers
    nonprofit_pages: ->
        Docs.find
            type:'page'
            nonprofit_footer:true
            



Template.tribe_leftbar.onCreated ->
    # @autorun => Meteor.subscribe 'schemas'


Template.tribe_leftbar.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context .ui.left.sidebar')
                    .sidebar({
                        context: $('.context .bottom.segment')
                        exclusive: true
                        delaySetup:true
                        dimPage: true
                        transition: 'overlay'
                    })
                    .sidebar('attach events', '.toggle_leftbar')
            , 2000


Template.tribe_topbar.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context .ui.top.sidebar')
                    .sidebar({
                        context: $('.context .bottom.segment')
                        exclusive: true
                        delaySetup:false
                        dimPage: false
                        transition:  'overlay'
                    })
                    .sidebar('attach events', '.toggle_topbar')
            , 2000

Template.tribe_rightbar.events
    'click .logout': -> Meteor.logout()



Template.tribe_rightbar.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.context .ui.right.sidebar')
                    .sidebar({
                        context: $('.context .bottom.segment')
                        exclusive: true
                        delaySetup:false
                        dimPage: false
                        transition:  'push'
                    })
                    .sidebar('attach events', '.toggle_rightbar')
            , 2000



Template.tribe_leftbar.helpers
    schemas: ->
        if Meteor.user() and Meteor.user().roles
            Docs.find {
                # view_roles: $in:Meteor.user().roles
                type:'schema'
            }, sort:title:1

Template.tribe_leftbar.events
    'click .set_schema': ->
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', @slug, ->
            Session.set 'loading', false





Template.tribe_footer.onCreated ->
    @autorun => Meteor.subscribe 'type', 'page'
    
    
Template.tribe_footer.helpers
    resource_pages: ->
        Docs.find
            type:'page'
            resource_footer:true
            
            