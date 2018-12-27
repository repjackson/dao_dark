import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

if Meteor.isClient
    Template.nav.events
        'click .home': ->
            Meteor.call 'fum'
                
        'click .add': ->
            new_id = Docs.insert {}
            FlowRouter.go "/edit/#{new_id}"
                
        'click .logout': -> Meteor.logout()
                

                
if Meteor.isServer
    Meteor.publish 'delta', ->
        Docs.find 
            _type:'delta'
            # author_id:  Meteor.userId()