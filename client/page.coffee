if Meteor.isClient
    Template.home.helpers
        # tribe_homepage: ->




    Template.page.onCreated ->
        @autorun => Meteor.subscribe 'page', Router.current().params.slug
        @autorun => Meteor.subscribe 'page_blocks', Router.current().params.slug


    Template.page.helpers
        page: ->
            Docs.findOne
                type:'page'
                slug:Router.current().params.slug

        # page_style: ->
        #     console.log @
        #     {
        #         background: url(/image/signup-bg.png) center no-repeat;
        #         /*height: 100%;*/
        #         width: 100%;
        #         height: 100vh;
        #         background-repeat: no-repeat;
        #         background-position: center center;
        #         background-size: cover;
        #         background-attachment: fixed;
        #         position: relative;
        #     }


    Template.add.onCreated ->
        @autorun => Meteor.subscribe 'type', 'schema'

    Template.add.helpers
        add_schemas: ->
            if Meteor.user()
                Docs.find
                    type:'schema'
                    add_roles:$in:Meteor.user().roles


    Template.menu.onCreated ->
        @autorun => Meteor.subscribe 'type', 'schema'

    Template.menu.helpers
        view_schemas: ->
            if Meteor.user()
                if 'dev' in Meteor.user().roles
                    Docs.find
                        type:'schema'
                else
                    Docs.find
                        type:'schema'
                        view_roles:$in:Meteor.user().roles

    Template.menu.events
        'click .set_tribe_schema': ->
            Session.set 'loading', true
            Meteor.call 'set_delta_facets', @slug,->
                Session.set 'loading', false



    Template.add.events
        'click .add_doc': ->
            # console.log @
            new_id =
                Docs.insert
                    type:@slug

            Router.go "/s/#{@slug}/#{new_id}/edit"

        'click .add_schema': ->
            # console.log @
            tribe =
                Docs.findOne
                    type:'tribe'

            new_id =
                Docs.insert
                    type:'schema'
                    tribe:tribe.slug
                    tribe_id:tribe._id

            Router.go "/s/schema/#{new_id}/edit"

        'click .add_page': ->
            # console.log @
            new_id =
                Docs.insert
                    type:'page'

            Router.go "/s/page/#{new_id}/edit"
