import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

if Meteor.isClient
    Template.nav.onCreated ->
        @autorun -> Meteor.subscribe 'delta'
        
        
    Template.nav.events
        'click .me': ->
            Meteor.users.update Meteor.userId(),
                $set:current_page:'me'
                
        'click .home': ->
            Meteor.call 'fo'
                
        'click .add': ->
            new_id = Docs.insert {}
            FlowRouter.go "/edit/#{new_id}"
                
                
        'click .logout': -> Meteor.logout()
                

                
if Meteor.isServer
    Meteor.publish 'delta', ->
        Docs.find 
            type:'delta'
            # author_id:  Meteor.userId()