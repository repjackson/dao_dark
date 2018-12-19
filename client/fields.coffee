Template.title.events
    'blur .edit_title': (e,t)->
        title_val = t.$('.edit_title').val()
        parent_id = Template.parentData(6)
        Docs.update parent_id, 
            $set:title:title_val
    
Template.tags.events
    'keyup .new_tag': (e,t)->
        if e.which is 13
            tag_val = t.$('.new_tag').val()
            parent_id = Template.parentData(6)
            Docs.update parent_id, 
                $addToSet:tags:tag_val
            t.$('.new_tag').val('')
        
    'click .remove_tag': (e,t)->
        tag_val = t.$('.edit_tag').val()
        parent_id = Template.parentData(6)
        Docs.update parent_id, 
            $addToSet:tags:tag_val
        
            
Template.textarea.events
    'blur .edit_textarea': (e,t)->
        textarea_val = t.$('.edit_textarea').val()
        parent_id = Template.parentData(6)
        Docs.update parent_id, 
            $set:description:textarea_val
        
            
            
Template.text.helpers
    value: ->
        parent = Template.parentData(5)
        parent["#{@key}"]
        
Template.textarea.helpers
    value: ->
        parent = Template.parentData(5)
        parent["#{@key}"]
        
            
Template.text.events                
    'blur .edit_text': (e,t)->
        parent = Template.parentData(6)
        val = t.$('.edit_text').val()
        # parent_id = Template.parentData(6)
        Docs.update parent._id, 
            $set:"#{@key}":val


Template.children.onCreated ->
    @autorun => Meteor.subscribe 'children', @data.type, Template.parentData()


Template.children.helpers
    children: ->
        field = @
        parent = Template.parentData()
        Docs.find
            type: @type
            parent_id: parent._id
                        

    
Template.children.events
    'click .add_child': ->
        field = @
        parent = Template.parentData()
        Docs.insert
            type: @type
            parent_id: parent._id
            
            
            