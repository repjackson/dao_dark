if Meteor.isClient
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
                    tribe:Router.current().params.tribe_slug


    Template.menu.onCreated ->
        @autorun => Meteor.subscribe 'type', 'schema'
    
    Template.menu.helpers
        view_schemas: ->
            if Meteor.user()
                if 'dev' in Meteor.user().roles
                    Docs.find
                        type:'schema'
                        tribe:Router.current().params.tribe_slug
                else
                    Docs.find
                        type:'schema'
                        view_roles:$in:Meteor.user().roles
                        tribe:Router.current().params.tribe_slug

    Template.menu.events
        'click .set_tribe_schema': ->
            Session.set 'loading', true
            Meteor.call 'set_delta_facets', @slug, Router.current().params.tribe_slug,->
                Session.set 'loading', false
            


    Template.add.events
        'click .add_doc': ->
            # console.log @
            new_id = 
                Docs.insert
                    type:@slug
                    tribe:Router.current().params.tribe_slug
                
            Router.go "/t/#{Router.current().params.tribe_slug}/s/#{@slug}/#{new_id}/edit"

        'click .add_schema': ->
            # console.log @
            tribe = 
                Docs.findOne 
                    type:'tribe'
                    slug:Router.current().params.tribe_slug
                    
            new_id = 
                Docs.insert
                    type:'schema'
                    tribe:tribe.slug
                    tribe_id:tribe._id
                
            Router.go "/t/#{Router.current().params.tribe_slug}/s/schema/#{new_id}/edit"
        
        'click .add_page': ->
            # console.log @
            tribe = 
                Docs.findOne 
                    type:'tribe'
                    slug:Router.current().params.tribe_slug
                    
            new_id = 
                Docs.insert
                    type:'page'
                    tribe:tribe.slug
                    tribe_id:tribe._id
                
            Router.go "/t/#{Router.current().params.tribe_slug}/s/page/#{new_id}/edit"

    