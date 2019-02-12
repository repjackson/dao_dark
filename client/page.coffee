import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


if Meteor.isClient
    Template.page.onCreated ->
        @autorun => Meteor.subscribe 'page', FlowRouter.getParam('slug')
        @autorun => Meteor.subscribe 'page_modules', FlowRouter.getParam('slug')
    
    
    Template.page.helpers
        page: ->
            Docs.findOne
                type:'page'
                slug:FlowRouter.getParam('slug')
    
    
    Template.add.onCreated ->
        @autorun => Meteor.subscribe 'type', 'schema'
    
    Template.add.helpers
        add_schemas: ->
            if Meteor.user()
                Docs.find
                    type:'schema'
                    add_roles:$in:Meteor.user().roles

    Template.add.events
        'click .add_doc': ->
            console.log @
            new_id = Docs.insert
                type:@slug
                
            FlowRouter.go "/s/#{@slug}/#{new_id}/edit"

    