import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

if Meteor.isClient
    Template.edit.onCreated ->
        @autorun => Meteor.subscribe 'edit_doc', FlowRouter.getParam('doc_id')
    
    Template.edit.events
        'click .print': (e,t)->
            console.log Docs.findOne FlowRouter.getParam('doc_id')
        
        'keyup .new_key': (e,t)->
            if e.which is 13
                key = t.$('.new_key').val()    
                Docs.update @_id,
                    $addToSet: _keys: key
                    $set:
                        "#{key}": 'test'
                        "_#{key}": {}
                  
                  
    Template.change_brick.events      
        'click .set_brick': (e,t)->
            new_type = @valueOf()    
            current_field_key = Template.parentData()
            # meta = Template.parentData()["_#{key_string}"]
            
            parent_doc = Template.parentData(2)
            console.log parent_doc
            
            Docs.update parent_doc._id,
                $set: "_#{current_field_key}.field_type": new_type
                
                
                
    Template.field.helpers
        bricks: ->
            [
                'text'
                'textarea'
                'youtube'
                'link'
            ]    
        
                    
                    
                    
                    
    Template.field.events      
        'keyup .change_label': (e,t)->
            if e.which is 13
                key_string = @valueOf()
                label = t.$('.change_label').val()    
                parent = Template.parentData()
                meta = Template.parentData()["_#{key_string}"]
                
                Docs.update parent._id,
                    $set: "_#{key_string}.label": label
                
                    
        'keyup .change_key': (e,t)->
            if e.which is 13
                old_string = @valueOf()
                console.log old_string
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
        
        
    Template.field.helpers
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
        