import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.edit.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('id')
    @autorun -> Meteor.subscribe 'schema', FlowRouter.getParam('id')
    @autorun -> Meteor.subscribe 'type', 'brick'

    
Template.edit.events
    'click .toggle_complete': (e,t)->
        Docs.update FlowRouter.getParam('id'),
            $set:complete:!@complete


    'click .delete': ->
        if confirm 'confirm delete'
            Docs.remove @_id
            FlowRouter.go '/'


Template.brick_menu.helpers
    bricks: ->
        Docs.find
            type:'brick'


Template.brick_menu.events
    'click .add_brick': ->
        console.log @
        Docs.update FlowRouter.getParam('id'),
            $addToSet: 
                bricks: @slug
                _keys: "new_#{@slug}"
            $set:
                "_new_#{@slug}": { brick:@slug }

Template.brick_edit.events
    'blur .change_key': (e,t)->
        old_string = @valueOf()
        # console.log old_string
        new_key = t.$('.change_key').val()    
        parent = Template.parentData()
        current_keys = Template.parentData()._keys
        
        Meteor.call 'rename_key', old_string, new_key, parent 
            
        
    'click .remove_brick': ->
        key_name = @valueOf()
        console.log Template.currentData()
        # parent = Template.parentData()
        # if confirm "remove #{key_name}?"
        #     Docs.update parent._id,
        #         $unset: 
        #             "#{key_name}": 1
        #             "_#{key_name}": 1
        #         $pull: _keys: key_name



Template.brick_edit.helpers
    key: -> @valueOf()
    
    meta: ->
        key_string = @valueOf()
        parent = Template.parentData()
        parent["_#{key_string}"]
    
    
    field_edit: ->
        key_string = @valueOf()
        meta = Template.parentData()["_#{key_string}"]
        "#{meta.brick}_edit"
