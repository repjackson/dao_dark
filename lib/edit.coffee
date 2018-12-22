import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

if Meteor.isClient
    Template.edit.onCreated ->
        @autorun => Meteor.subscribe 'edit_doc', FlowRouter.getParam('doc_id')
        
    Template.edit.events
        'keyup .new_key': (e,t)->
            if e.which is 13
                key = t.$('.new_key').val()    
                console.log key
                Docs.update @_id,
                    $addToSet: _keys: key
                    $set: "#{key}": 'test'
                  
    Template.field.events      
        'blur .change_label': ->
            console.log @
            console.log Template.parentData()
                    
        'click .remove_field': ->
            key_name = @valueOf()
            parent_field = Template.parentData()["#{key_name}"]
            console.log parent_field
        
        
        
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
        