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
                    $set: "#{key}": 'test'
                  
    Template.field.events      
        'blur .change_label': ->
            console.log @
            console.log Template.parentData()
                    
        'click .remove_field': ->
            key_name = @valueOf()
            console.log key_name
            parent = Template.parentData()
            console.log parent
            if confirm "remove #{key_name}?"
                Docs.update parent._id,
                    $unset: "#{key_name}": 1
                    $pull: _keys: key_name
        
        
        
    Template.edit.helpers
            
            
        
        
if Meteor.isServer
    Meteor.publish 'edit_doc', (doc_id)->
        Docs.find doc_id
        