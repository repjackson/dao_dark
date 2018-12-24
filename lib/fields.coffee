if Meteor.isClient
    Template.title_edit.events
        'blur .edit_title': (e,t)->
            title_val = t.$('.edit_title').val()
            parent = Template.parentData(5)
            Docs.update parent._id, 
                $set:title:title_val
        
        
    Template.tags_edit.events
        'keyup .new_tag': (e,t)->
            if e.which is 13
                tag_val = t.$('.new_tag').val()
                parent = Template.parentData(5)
                Docs.update parent._id, 
                    $addToSet:"#{@valueOf()}":tag_val
                t.$('.new_tag').val('')
            
        'click .remove_tag': (e,t)->
            tag_val = t.$('.edit_tag').val()
            parent = Template.parentData(5)
            Docs.update parent._id, 
                $addToSet:"#{@valueOf()}":tag_val
            
                
    Template.textarea_edit.events
        'blur .edit_textarea': (e,t)->
            textarea_val = t.$('.edit_textarea').val()
            parent = Template.parentData(5)
            Docs.update parent._id, 
                $set:"#{@valueOf()}":textarea_val
            
                
                
    Template.text_edit.events                
        'blur .edit_text': (e,t)->
            parent = Template.parentData(5)
            val = t.$('.edit_text').val()
            console.log parent
            Docs.update parent._id, 
                $set:"#{@valueOf()}":val
    
    
    Template.children_edit.onCreated ->
        @autorun => Meteor.subscribe 'children', @data.type, Template.parentData()
    
    
    Template.children_edit.helpers
        children: ->
            field = @
            parent = Template.parentData(5)
            Docs.find
                type: @type
                parent_id: parent._id
                            
    
        
    Template.children_edit.events
        'click .add_child': ->
            field = @
            parent = Template.parentData(5)
            Docs.insert
                type: @type
                parent_id: parent._id
                
                
                
    Template.ref_edit.onCreated ->
        @autorun => Meteor.subscribe 'ref_choices', @data.schema
    
    Template.ref_edit.helpers
        choices: -> Docs.find type:@schema
        choice_class: -> 
            
                
    Template.ref_edit.events
        'click .select_choice': ->
            selection = @
            ref_field = Template.currentData()
            target = Template.parentData(1)

            console.log ref_field
            
            if ref_field.ref_type is 'single'
                Docs.update target._id,
                    $set: "#{ref_field.key}": @_id
            else if ref_field.ref_type is 'multi'
                Docs.update target._id,
                    $addToSet: "#{ref_field.key}": @_id
                
            
            
    
    
if Meteor.isServer
    Meteor.publish 'ref_choices', (schema)->
        Docs.find
            type:schema