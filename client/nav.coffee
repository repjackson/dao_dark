import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.topnav.onCreated ->
    @autorun => Meteor.subscribe 'users'

Template.topnav.helpers
    user: -> Meteor.users.findOne username:FlowRouter.getParam('username')

Template.topnav.events
    'click .logout': -> Meteor.logout()

    'click .toggle_invert': ->
        Session.set('invert', !Session.get('invert'))

    'click .add': ->
        new_id = Docs.insert {}
        FlowRouter.go "/edit/#{new_id}"

    'click .toggle_dev': ->
        Session.set('dev_mode', !Session.get('dev_mode'))

    'click .set_schema': ->
        Meteor.call 'set_delta_facets', 'schema', Meteor.userId()


Template.topbar.onCreated ->
    @autorun => Meteor.subscribe 'type', 'page'

Template.topnav.onCreated ->
    @autorun -> Meteor.subscribe 'type', 'schema'
    

Template.topnav.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.dropdown').dropdown()
            , 2000



Template.topnav.helpers
    topnav_schemas: ->
        if Meteor.user()
            Docs.find
                type:'schema'
                topnav_roles:$in:Meteor.user().roles


Template.topbar.helpers
    nonprofit_pages: ->
        Docs.find
            type:'page'
            nonprofit_footer:true
            



Template.leftbar.onCreated ->
    # @autorun => Meteor.subscribe 'schemas'


Template.leftbar.onRendered ->
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


Template.topbar.onRendered ->
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



Template.rightbar.onRendered ->
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



Template.leftbar.helpers
    schemas: ->
        if Meteor.user() and Meteor.user().roles
            Docs.find {
                # view_roles: $in:Meteor.user().roles
                type:'schema'
            }, sort:title:1

Template.leftbar.events





Template.footer.onCreated ->
    @autorun => Meteor.subscribe 'type', 'page'
    
    
Template.footer.helpers
    resource_pages: ->
        Docs.find
            type:'page'
            resource_footer:true
            
            