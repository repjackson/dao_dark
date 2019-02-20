if Meteor.isClient
    Template.page.onCreated ->
        @autorun => Meteor.subscribe 'page', Router.current().params.slug
        @autorun => Meteor.subscribe 'page_blocks', Router.current().params.slug
    
    
    Template.page.helpers
        page: ->
            Docs.findOne
                type:'page'
                slug:Router.current().params.slug
    
    
    Template.add.onCreated ->
        @autorun => Meteor.subscribe 'type', 'schema'
    
    Template.add.helpers
        add_schemas: ->
            if Meteor.user()
                Docs.find
                    type:'schema'
                    add_roles:$in:Meteor.user().roles
                    tribe:Router.current().params.tribe_slug



    Template.add.events
        'click .add_doc': ->
            console.log @
            new_id = 
                Docs.insert
                    type:@slug
                    tribe:Router.current().params.tribe_slug
                
            Router.go "/t/#{Router.current().params.tribe_slug}/s/#{@slug}/#{new_id}/edit"

    