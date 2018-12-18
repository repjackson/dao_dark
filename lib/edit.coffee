import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

if Meteor.isClient
    Template.edit_doc.onCreated ->
        @autorun => Meteor.subscribe 'edit_doc', FlowRouter.getParam('doc_id')
        
        
    Template.edit_doc.helpers
        editing_doc: -> 
            doc_id = FlowRouter.getParam('doc_id')
            # console.log(doc_id)
            Docs.findOne doc_id 

        
    Template.edit_doc.events
        
        
        
        
if Meteor.isServer
    Meteor.publish 'edit_doc', (doc_id)->
        Docs.find doc_id