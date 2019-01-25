import { FlowRouter } from 'meteor/ostrio:flow-router-extra';
@selected_type = new ReactiveArray []

Template.dash.onCreated ->
    @autorun -> Meteor.subscribe('types', selected_type.array())
    @autorun -> Meteor.subscribe('docs_type', selected_type.array())


Template.dash.helpers
    selected_type: -> selected_type.list()
    types: -> Types.find({})
    docs: -> Docs.find {}, limit:20


Template.dash.events
    'click .select_type': -> selected_type.push @title
    'click .unselect_type': -> selected_type.remove @valueOf()
    'click #clear_types': -> selected_type.clear()


Template.dash.events
    'click .add_schema': ->
        new_id = Docs.insert type:'schema'
        FlowRouter.go "/edit/#{new_id}"
