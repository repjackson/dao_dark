if Meteor.isClient
    Template.topnav.onCreated ->
        @autorun => Meteor.subscribe 'me'
        @autorun => Meteor.subscribe 'type', 'field'
        # @autorun => Meteor.subscribe 'schemas'

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

        'click .set_schema': ->
            Session.set 'loading', true
            Meteor.call 'set_delta_facets', @slug,->
                Session.set 'loading', false


    # Template.topbar.onCreated ->
    #     @autorun => Meteor.subscribe 'type', 'page'



    # Template.topbar.helpers
    #     nonprofit_pages: ->
    #         Docs.find
    #             type:'page'
    #             nonprofit_footer:true
    #


    Template.topnav.events
        'click .logout': ->
            Meteor.logout()
            Router.go '/signin'
