import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

if Meteor.isClient
    Template.edit.onCreated ->
        @autorun => Meteor.subscribe 'edit_doc', FlowRouter.getParam('doc_id')
    
    Template.edit.events
        'click .print': (e,t)->
            console.log Docs.findOne FlowRouter.getParam('doc_id')
        
        'click .add_brick': (e,t)->
            doc = Docs.findOne FlowRouter.getParam('doc_id')
            
            Docs.update doc._id,
                $addToSet: _keys: 'new_brick'
                $set:
                    "_new_brick": { brick:@valueOf() }
                
                
    Template.edit.helpers
        # bricks: ->
        #     [
        #         'text'
        #         'code'
        #         'number'
        #         'date'
        #         'textarea'
        #         'html'
        #         'youtube'
        #         'link'
        #         'boolean'
        #         'array'
        #     ]    
        
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
        