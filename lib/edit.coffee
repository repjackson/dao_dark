import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

if Meteor.isClient
    Template.edit.onCreated ->
        @autorun => Meteor.subscribe 'edit_doc', FlowRouter.getParam('doc_id')
    
    Template.edit.events
        'click .print': (e,t)->
            console.log Docs.findOne FlowRouter.getParam('doc_id')
        
        'keyup .new_tag': (e,t)->
            if e.which is 13
                tag_val = t.$('.new_tag').val().trim()
                parent = Docs.findOne FlowRouter.getParam('doc_id')
                Docs.update parent._id, 
                    $addToSet: tags: tag_val
                t.$('.new_tag').val('')
            
        'click .remove_tag': (e,t)->
            tag = @valueOf()
            parent = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.update parent._id, 
                $pull:tags:tag
            
        'blur .edit_body': (e,t)->
            body_val = t.$('.edit_body').val()
            parent = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.update parent._id, 
                $set: body:body_val
        
            
        'change .points': (e,t)->
            points_val = parseInt t.$('.points').val()
            console.log points_val
            parent = Docs.findOne FlowRouter.getParam('doc_id')
            Docs.update parent._id, 
                $set: points:points_val
        
            
  
                
        
    Template.field_edit.helpers
        brick_edit: ->
            key_string = @valueOf()
            meta = Template.parentData()["_#{key_string}"]
            "#{meta.brick}_edit"
            
                    
        field_value: () -> 
            parent = Template.parentData(1)
            # console.log @
            # console.log parent
            if parent["#{@valueOf()}"]
                parent["#{@valueOf()}"]
       
                    
    Template.field_edit.events      
        'keyup .change_key': (e,t)->
            if e.which is 13
                old_string = @valueOf()
                # console.log old_string
                new_key = t.$('.change_key').val()    
                parent = Template.parentData()
                current_keys = Template.parentData()._keys
                
                Meteor.call 'rename_key', old_string, new_key, parent 
                
            
        'click .remove_field': ->
            key_name = @valueOf()
            # console.log key_name
            parent = Template.parentData()
            if confirm "remove #{key_name}?"
                Docs.update parent._id,
                    $unset: "#{key_name}": 1
                    $pull: _keys: key_name
        
        
    Template.field_edit.helpers
        key: -> @valueOf()
        meta: ->
            key_string = @valueOf()
            parent = Template.parentData()
            parent["_#{key_string}"]
        
        
        key_value: ->
            key_string = @valueOf()
            # console.log Template.parentData()
            parent = Template.parentData()
            parent["#{key_string}"]
           
           
        
if Meteor.isServer
    Meteor.publish 'edit_doc', (doc_id)->
        Docs.find doc_id
        