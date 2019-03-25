Template.topnav.onCreated ->
    @autorun => Meteor.subscribe 'me'
    @autorun => Meteor.subscribe 'type', 'field'
    @autorun => Meteor.subscribe 'schemas'
    @autorun => Meteor.subscribe 'tribe_from_slug', Router.current().params.tribe_slug
    @autorun => Meteor.subscribe 'tribe_schemas', Router.current().params.tribe_slug
    @autorun => Meteor.subscribe 'tribe_from_slug', Router.current().params.tribe_slug


Template.topnav.onRendered ->
    # @autorun =>
    #     if @subscriptionsReady()
    #         Meteor.setTimeout ->
    #             $('.dropdown').dropdown()
    #         , 3000

    # Meteor.setTimeout ->
    #     $('.item').popup()
    # , 3000


Template.topnav.helpers
    topnav_schemas: ->
        if Meteor.user()
            Docs.find {
                type:'schema'
                topnav_roles:$in:Meteor.user().roles
            }, sort:rank:1

    top_nav_item_class: ->
        if Session.equals('loading',true) then 'disabled' else ''

    topnav_pages: ->
        tribe = Docs.findOne
            type:'tribe'
        if tribe
            Docs.find {
                type:'page'
                topnav_roles:$in:Meteor.user().roles
            }, sort:rank:1

    # user: -> Meteor.users.findOne username:Router.current().params.username

Template.topnav.events
    'click .adddoc': (e,t)->
        e.preventDefault()
        # Router.go '/add'
        new_id = Docs.insert({})
        # console.log 'hi'
        Router.go("/edit/#{new_id}")

    'click .toggle_leftbar': ->
        $('.context .ui.left.sidebar')
            .sidebar({
                context: $('.context .bottom.segment')
                exclusive: true
                delaySetup:true
                dimPage: true
                transition: 'overlay'
            })
            .sidebar('attach events', '.toggle_leftbar')
            .sidebar('toggle')



    'click .toggle_rightbar': ->
        $('.context .ui.right.sidebar')
            .sidebar({
                context: $('.context .bottom.segment')
                exclusive: true
                delaySetup:true
                dimPage: true
                transition: 'overlay'
            })
            .sidebar('attach events', '.toggle_rightbar')
            .sidebar('toggle')


    # 'click .add': ->
    #     new_id = Docs.insert {}
    #     Router.go "/edit/#{new_id}"

    # 'click .toggle_dev': ->
    #     Session.set('dev_mode', !Session.get('dev_mode'))

    'click .people': ->
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', 'person',->
            Session.set 'loading', false

    'click .delta': ->
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', 'schema',->
            Session.set 'loading', false

    'click .records': ->
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', 'record',->
            Session.set 'loading', false

    'click .tribes': ->
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', 'tribe',->
            Session.set 'loading', false

    'click .set_schema': ->
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', @slug,->
            Session.set 'loading', false


Template.topbar.onCreated ->
    @autorun => Meteor.subscribe 'type', 'page'



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
            , 3000
#
Template.leftbar.events
    'click .tribe_pages': ->
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', 'page',->
            Session.set 'loading', false

    'click .tribe_schemas': ->
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', 'schema',->
            Session.set 'loading', false


    'click .logout': ->
        Meteor.logout()
        Router.go '/signin'



Template.topnav.events
    'click .logout': ->
        Meteor.logout()
        Router.go '/signin'


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
    tribe_schemas: ->
        if Meteor.user() and Meteor.user().roles
            Docs.find {
                # view_roles: $in:Meteor.user().roles
                type:'schema'
            }, sort:title:1

Template.leftbar.events
    'click .set_schema': ->
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', @slug,->
            Session.set 'loading', false




Template.footer.onCreated ->
    # @autorun => Meteor.subscribe 'type', 'page'


Template.footer.helpers
    footer_pages: ->
        Docs.find
            type:'page'
            show_in_footer:true
