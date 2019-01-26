import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

Session.setDefault('invert', true)

Template.registerHelper 'dev', () -> Meteor.isDevelopment

Template.registerHelper 'dark_side', () -> Session.equals('invert',true)

Template.registerHelper 'invert_class', () -> if Session.equals('invert',true) then 'inverted' else ''

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

