Template.title.events
    'blur .edit_title': (e,t)->
        title_val = t.$('.edit_title').val()
        parent_id = Meteor.user().editing_id
        Docs.update parent_id, 
            $set:title:title_val
        
Template.tags.events
    'keyup .new_tag': (e,t)->
        if e.which is 13
            tag_val = t.$('.new_tag').val()
            parent_id = Meteor.user().editing_id
            Docs.update parent_id, 
                $addToSet:tags:tag_val
            t.$('.new_tag').val('')
        
    'click .remove_tag': (e,t)->
        tag_val = t.$('.edit_tag').val()
        parent_id = Meteor.user().editing_id
        Docs.update parent_id, 
            $addToSet:tags:tag_val
        
            
Template.description.events
    'blur .edit_description': (e,t)->
        description_val = t.$('.edit_description').val()
        parent_id = Meteor.user().editing_id
        Docs.update parent_id, 
            $set:description:description_val
        
            
            
Template.text_edit.helpers
    value: ->
        parent = Template.parentData()
        parent["#{@key}"]
        
            
Template.text_edit.events                
    'blur .edit_text': (e,t)->
        val = t.$('.edit_text').val()
        parent_id = Meteor.user().editing_id
        Docs.update parent_id, 
            $set:"#{@key}":val
