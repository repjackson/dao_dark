import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

if Meteor.isClient
    Template.nav.onCreated ->
        @autorun -> Meteor.subscribe 'sections'
        
        
    Template.nav.events
        'click .me': ->
            Meteor.users.update Meteor.userId(),
                $set:current_page:'me'
                
        'click .select_section': ->
            console.log @
            Meteor.call 'select_section', @
                
        'click .add': ->
            new_id = Docs.insert {}
            FlowRouter.go "/edit/#{new_id}"
                
                
        'click .logout': -> Meteor.logout()
                
    Template.nav.helpers
        sections: ->
            Docs.find 
                type:'section'
                
                
if Meteor.isSever
    Meteor.publish 'sections', ->
        Docs.find 
            type:'section'