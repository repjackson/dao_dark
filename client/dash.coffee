import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

Template.dash.onCreated ->
    @autorun -> Meteor.subscribe 'type', 'schema'


Template.dash.helpers
    items: ->
        Docs.find
            type:'schema'




Template.dash.events
    'click .add_schema': ->
        new_id = Docs.insert type:'schema'
        FlowRouter.go "/edit/#{new_id}"
