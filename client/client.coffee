import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

Session.setDefault('invert', true)

Template.registerHelper 'dev', () -> Meteor.isDevelopment

Template.registerHelper 'dark_side', () -> Session.equals('invert',true)

Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)



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
    # console.log @
    # console.log Template.currentData()
    # console.log Template.parentData()
    # console.log Template.parentData(1)
    # console.log Template.parentData(2)
    # console.log Template.parentData(3)
    # console.log Template.parentData(4)
    # console.log Template.parentData(5)
    # console.log Template.parentData(6)
    parent = Template.parentData(5)
    if parent["#{@valueOf()}"] then parent["#{@valueOf()}"]
