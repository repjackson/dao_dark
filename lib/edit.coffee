import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

if Meteor.isClient
    Template.edit.onCreated ->
        @autorun => Meteor.subscribe 'edit_doc', FlowRouter.getParam('doc_id')
        @autorun => Meteor.subscribe 'edit_doc_schema', FlowRouter.getParam('doc_id')
        @autorun => Meteor.subscribe 'edit_doc_schema_fields', FlowRouter.getParam('doc_id')
        
        
    Template.edit.helpers
        editing_doc: -> 
            doc_id = FlowRouter.getParam('doc_id')
            Docs.findOne doc_id 
            
        edit_doc_schema: ->
            doc_id = FlowRouter.getParam('doc_id')
            edit_doc = Docs.findOne doc_id 
            Docs.findOne
                type:'schema'
                slug: edit_doc.type
            
        edit_doc_schema_fields: ->
            doc_id = FlowRouter.getParam('doc_id')
            edit_doc = Docs.findOne doc_id 
            schema = Docs.findOne
                type:'schema'
                slug: edit_doc.type
            
            if schema
                Docs.find
                    type:'field'
                    _id:schema.field_ids
            
        
        
if Meteor.isServer
    Meteor.publish 'edit_doc', (doc_id)->
        Docs.find doc_id
        
    Meteor.publish 'edit_doc_schema', (doc_id)->
        doc = Docs.findOne doc_id
        Docs.find 
            type:'schema'
            slug:doc.type
        
        
    Meteor.publish 'edit_doc_schema_fields', (doc_id)->
        doc = Docs.findOne doc_id
        schema = 
            Docs.findOne 
                type:'schema'
                slug:doc.type
        fields = 
            Docs.find
                type:'field'
                _id:schema.field_ids
        
        
        