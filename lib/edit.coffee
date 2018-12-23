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
                console.log key
                Docs.update @_id,
                    $addToSet: _keys: key
                    $set:
                        "#{key}": 'test'
                        "_#{key}": {}
                  
    Template.field.events      
        'keyup .change_label': (e,t)->
            if e.which is 13
                key_string = @valueOf()
                label = t.$('.change_label').val()    
                parent = Template.parentData()
                meta = Template.parentData()["_#{key_string}"]
                
                Docs.update parent._id,
                    $set: "_#{key_string}.label": label
                
                    
        'click .remove_field': ->
            key_name = @valueOf()
            # console.log key_name
            parent = Template.parentData()
            console.log parent
            if confirm "remove #{key_name}?"
                Docs.update parent._id,
                    $unset: "#{key_name}": 1
                    $pull: _keys: key_name
        
        
    Template.field.helpers
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
        