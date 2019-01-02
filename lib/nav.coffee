import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

if Meteor.isClient
    Template.delta.onCreated ->
        @autorun -> Meteor.subscribe 'delta', Session.get('delta_id')

    
    Template.delta.events
        'click .home': ->
            delta = Docs.findOne type:'delta'
            if delta
                Docs.remove delta._id
            new_delta_id = Docs.insert type:'delta'
            Session.set 'delta_id', new_delta_id
            Meteor.call 'fum', new_delta_id
                
        'click .add': ->
            new_id = Docs.insert {}
            FlowRouter.go "/edit/#{new_id}"
                
        'click .logout': -> 
            Meteor.logout()
            FlowRouter.go "/enter"
                

                
if Meteor.isServer
    Meteor.publish 'delta', (delta_id)->
        Docs.find delta_id