import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

if Meteor.isClient
    Template.delta.onCreated ->
        @autorun -> Meteor.subscribe 'delta'

    
    Template.nav.events
        'click .home': ->
            delta = Docs.findOne type:'delta'
            if delta
                Docs.remove delta._id
            Meteor.call 'fum'
                
        'click .add': ->
            new_id = Docs.insert {}
            FlowRouter.go "/edit/#{new_id}"
                
        'click .logout': -> 
            Meteor.logout()
            FlowRouter.go "/enter"
                

                
if Meteor.isServer
    Meteor.publish 'delta', ->
        Docs.find 
            type:'delta'
            author_id:  Meteor.userId()