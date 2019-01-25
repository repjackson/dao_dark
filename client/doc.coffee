import { FlowRouter } from 'meteor/ostrio:flow-router-extra'


Template.edit.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('id')
    @autorun -> Meteor.subscribe 'schema', FlowRouter.getParam('id')
    @autorun -> Meteor.subscribe 'type', 'brick'

    
Template.edit.events
    'blur .body': (e,t)->
        body = t.$('.body').val()
        Docs.update FlowRouter.getParam('id'),
            $set:body:body


    'click .toggle_complete': (e,t)->
        Docs.update FlowRouter.getParam('id'),
            $set:complete:!@complete


    'click .delete': ->
        if confirm 'confirm delete'
            Docs.remove @_id
            FlowRouter.go '/'



Template.view.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('id')
    @autorun -> Meteor.subscribe 'schema', FlowRouter.getParam('id')


Template.brick_menu.helpers
    bricks: ->
        Docs.find
            type:'brick'


Template.brick_menu.events
    'click .add_brick': ->
        console.log @
        Docs.update FlowRouter.getParam('id'),
            $addToSet: _keys: 'new_field'
            $set:
                "_new_field": { brick:@slug }



Template.key_edit.helpers
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

    
    field_edit: ->
        key_string = @valueOf()
        meta = Template.parentData()["_#{key_string}"]
        "#{meta.brick}_edit"
            
                    
    field_value: () -> 
        parent = Template.parentData(1)
        # console.log @
        # console.log parent
        if parent["#{@valueOf()}"]
            parent["#{@valueOf()}"]
            
            

    
    

Template.key_edit.events
    'keyup .change_key': (e,t)->
        if e.which is 13
            old_string = @valueOf()
            # console.log old_string
            new_key = t.$('.change_key').val()    
            parent = Template.parentData()
            current_keys = Template.parentData()._keys
            
            Meteor.call 'rename_key', old_string, new_key, parent 
            
        
    'click .remove_key': ->
        key_name = @valueOf()
        # console.log key_name
        parent = Template.parentData()
        if confirm "remove #{key_name}?"
            Docs.update parent._id,
                $unset: "#{key_name}": 1
                $pull: _keys: key_name



