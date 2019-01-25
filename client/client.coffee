import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

Template.registerHelper 'dev', () -> Meteor.isDevelopment

Template.registerHelper 'in_list', (key) ->
    if Meteor.userId()
        if Meteor.userId() in @["#{key}"] then true else false

Template.registerHelper 'doc', () ->
    Docs.findOne FlowRouter.getParam('id')

Template.registerHelper 'schema', () ->
    Docs.findOne
        type:'schema'
        slug:@type


Template.registerHelper 'field_value', () ->
    parent = Template.parentData(5)
    if parent["#{@key}"] then parent["#{@key}"]

