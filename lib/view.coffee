import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

if Meteor.isClient
    Template.view.onCreated ->
        @autorun => Meteor.subscribe 'view_doc', FlowRouter.getParam('doc_id')
        
        
    Template.field_view.helpers
       brick_view: ->
            key_string = @valueOf()
            meta = Template.parentData()["_#{key_string}"]
            "#{meta.brick}_view"
 
        
        
if Meteor.isServer
    Meteor.publish 'view_doc', (doc_id)->
        Docs.find doc_id
        