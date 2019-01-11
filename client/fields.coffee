Template.url_edit.events
    'blur .edit_url': (e,t)->
        url_val = t.$('.edit_url').val()
        # parent = Template.parentData(5)
        parent = @
        Docs.update parent._id, 
            $set:"#{@valueOf()}":url_val
  
  
 
  
Template.array_edit.events
    'keyup .new_element': (e,t)->
        if e.which is 13
            element_val = t.$('.new_element').val().trim()
            # parent = Template.parentData(5)
            parent = @
            # console.log element_val
            Docs.update parent._id, 
                $addToSet:"#{@valueOf()}":element_val
            t.$('.new_element').val('')
        
    'click .remove_element': (e,t)->
        element = @valueOf()
        field_key = Template.parentData(4)
        # parent = Template.parentData(5)
        parent = @
        Docs.update parent._id, 
            $pull:"#{field_key}":element
        
            
            
Template.text_edit.events                
    'blur .edit_text': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.edit_text').val()
        Docs.update parent._id, 
            $set:"#{@valueOf()}":val



Template.number_edit.events                
    'blur .edit_number': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.edit_number').val()
        Docs.update parent._id, 
            $set:"#{@valueOf()}":val



Template.date_edit.events                
    'blur .edit_date': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.edit_date').val()
        Docs.update parent._id, 
            $set:"#{@valueOf()}":val



Template.youtube_edit.events                
    'blur .youtube_id': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.youtube_id').val()
        Docs.update parent._id, 
            $set:"_#{@valueOf()}.youtube_id":val


Template.children_edit.onCreated ->
    @autorun => Meteor.subscribe 'children', @data.type, Template.parentData()


Template.children_edit.helpers
    children: ->
        field = @
        # parent = Template.parentData(5)
        parent = @
        Docs.find
            type: @type
            parent_id: parent._id
    
Template.children_edit.events
    'click .add_child': ->
        field = @
        # parent = Template.parentData(5)
        parent = @
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
            

Template.url_edit.events
    'blur .edit_url': (e,t)->
        url_val = t.$('.edit_url').val()
        # parent = Template.parentData(5)
        parent = @
        Docs.update parent._id, 
            $set:"#{@valueOf()}":url_val
  
  
 
  
Template.array_edit.events
    'keyup .new_element': (e,t)->
        if e.which is 13
            element_val = t.$('.new_element').val().trim()
            # parent = Template.parentData(5)
            parent = @
            # console.log element_val
            Docs.update parent._id, 
                $addToSet:"#{@valueOf()}":element_val
            t.$('.new_element').val('')
        
    'click .remove_element': (e,t)->
        element = @valueOf()
        field_key = Template.parentData(4)
        # parent = Template.parentData(5)
        parent = @
        Docs.update parent._id, 
            $pull:"#{field_key}":element
        
            
            
Template.text_edit.events                
    'blur .edit_text': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.edit_text').val()
        Docs.update parent._id, 
            $set:"#{@valueOf()}":val



Template.number_edit.events                
    'blur .edit_number': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.edit_number').val()
        Docs.update parent._id, 
            $set:"#{@valueOf()}":val



Template.date_edit.events                
    'blur .edit_date': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.edit_date').val()
        Docs.update parent._id, 
            $set:"#{@valueOf()}":val



Template.youtube_edit.events                
    'blur .youtube_id': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.youtube_id').val()
        Docs.update parent._id, 
            $set:youtube_id:val

Template.youtube_edit.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.embed').embed()
            , 500
Template.youtube_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.embed').embed()
            , 500

Template.children_edit.onCreated ->
    @autorun => Meteor.subscribe 'children', @data.type, Template.parentData()


Template.children_edit.helpers
    children: ->
        field = @
        # parent = Template.parentData(5)
        parent = @
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
            

Template.url_edit.events
    'blur .edit_url': (e,t)->
        url_val = t.$('.edit_url').val()
        parent = Template.parentData(5)
        Docs.update parent._id, 
            $set:"#{@valueOf()}":url_val
  
  
 
  
Template.array_edit.events
    'keyup .new_element': (e,t)->
        if e.which is 13
            element_val = t.$('.new_element').val().trim()
            parent = Template.parentData(5)
            # console.log element_val
            Docs.update parent._id, 
                $addToSet:"#{@valueOf()}":element_val
            t.$('.new_element').val('')
        
    'click .remove_element': (e,t)->
        element = @valueOf()
        field_key = Template.parentData(4)
        # parent = Template.parentData(5)
        parent = @
        Docs.update parent._id, 
            $pull:"#{field_key}":element
        
            
            
Template.text_edit.events                
    'blur .edit_text': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.edit_text').val()
        Docs.update parent._id, 
            $set:"#{@valueOf()}":val



Template.number_edit.events                
    'blur .edit_number': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.edit_number').val()
        Docs.update parent._id, 
            $set:"#{@valueOf()}":val



Template.date_edit.events                
    'blur .edit_date': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.edit_date').val()
        Docs.update parent._id, 
            $set:"#{@valueOf()}":val



Template.youtube_edit.events                
    'blur .youtube_id': (e,t)->
        # parent = Template.parentData(5)
        parent = @
        val = t.$('.youtube_id').val()
        Docs.update parent._id, 
            $set:"_#{@valueOf()}.youtube_id":val


Template.children_edit.onCreated ->
    @autorun => Meteor.subscribe 'children', @data.type, Template.parentData()


Template.children_edit.helpers
    children: ->
        field = @
        # parent = Template.parentData(5)
        parent = @
        Docs.find
            type: @type
            parent_id: parent._id
    
Template.children_edit.events
    'click .add_child': ->
        field = @
        # parent = Template.parentData(5)
        parent = @
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
            
            