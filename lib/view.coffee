import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

if Meteor.isClient
    Template.view.onCreated ->
        @autorun => Meteor.subscribe 'view_doc', FlowRouter.getParam('doc_id')
        @autorun => Meteor.subscribe 'view_doc_schema', FlowRouter.getParam('doc_id')
        @autorun => Meteor.subscribe 'view_doc_schema_fields', FlowRouter.getParam('doc_id')
        
        
    Template.view.helpers
        viewing_doc: -> 
            doc_id = FlowRouter.getParam('doc_id')
            Docs.findOne doc_id 
            
        view_doc_schema: ->
            doc_id = FlowRouter.getParam('doc_id')
            view_doc = Docs.findOne doc_id 
            Docs.findOne
                type:'schema'
                slug: view_doc.type
            
        view_doc_schema_fields: ->
            doc_id = FlowRouter.getParam('doc_id')
            view_doc = Docs.findOne doc_id 
            schema = Docs.findOne
                type:'schema'
                slug: view_doc.type
            
            if schema
                Docs.find
                    type:'field'
                    parent_id:schema._id
            
        
        
if Meteor.isServer
    Meteor.publish 'view_doc', (doc_id)->
        Docs.find doc_id
        
    Meteor.publish 'view_doc_schema', (doc_id)->
        doc = Docs.findOne doc_id
        Docs.find 
            type:'schema'
            slug:doc.type
        
        
    Meteor.publish 'view_doc_schema_fields', (doc_id)->
        doc = Docs.findOne doc_id
        schema = 
            Docs.findOne 
                type:'schema'
                slug:doc.type
        fields = 
            Docs.find
                type:'field'
                parent_id:schema._id
        
        
        