Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'



Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')
# Template.registerHelper 'person', () -> Meteor.users.findOne username:@username

    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id
# Template.registerHelper 'is_person_by_username', () ->  Meteor.user().username is @username

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")

Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev_env', () -> Meteor.isDevelopment

Template.registerHelper 'from_now', (input) -> moment(input).fromNow()

Template.registerHelper 'detail_doc', (input) -> 
    delta = Docs.findOne type:'delta'
    if delta
        Docs.findOne delta.doc_id



Template.registerHelper 'my_deltas', () -> 
    Docs.find type:'delta'





Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'my_deltas'
    @autorun -> Meteor.subscribe 'me'

Template.edit.onCreated ->
    delta = Docs.findOne type:'delta'
    @autorun -> Meteor.subscribe 'doc_id', delta.doc_id


Template.nav.events
    'click .delta': ->
        Meteor.users.update Meteor.userId(),
            $set:current_template: 'delta'
        console.log Meteor.user()


Template.home.helpers
    main_template: ->
        if Meteor.user()
            Meteor.user().current_template
        
        

    

Template.facet.helpers
    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne type:'delta'

        if facet.filters and @name in facet.filters
            'grey'
        else
            ''

Template.edit.events
    'click .save': ->
        delta = Docs.findOne type:'delta'
        Docs.update delta._id,
            $set:
                editing:false
                result:@
    
    'click .detect_fields': ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne delta.doc_id
        Meteor.call 'detect_fields', editing_doc._id      
    
    
    'click .set_editing_field': ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne delta.doc_id
        Docs.update delta._id,
            $set: editing_field: @
    
    'click .add_field': ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne delta.doc_id
        
        new_field = {
            label:'New Field'
            key:'new_field'
            type:'string'
            }    
    
        Docs.update delta.doc_id,
            $addToSet:
                fields: new_field
    
        
Template.edit.helpers
    editing_doc: ->
        delta = Docs.findOne type:'delta'
        doc = Docs.findOne delta.doc_id
        doc
        

Template.delta.events
    'click .create_delta': (e,t)->
        Docs.insert
            type:'delta'
            facets: [{key:'keys', res:[]}]
            result_ids:[]
        # Meteor.call 'fo'
    
    'click .add_doc': ->
        delta = Docs.findOne type:'delta'
        new_id = Docs.insert {}
        new_doc = Docs.findOne new_id
        Docs.update delta._id,
            $set:
                editing:true
                doc_id: new_id
    
    
    'click .delete_delta': (e,t)->
        delta = Docs.findOne type:'delta'
        Docs.remove delta._id
    
    'click .print_delta': (e,t)->
        delta = Docs.findOne type:'delta'

    'click .recalc': ->
        Meteor.call 'fo', (err,res)->

    'click .select_delta': ->
        Meteor.users.update Meteor.userId(),
            $set: current_delta_id: @_id


Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne type:'delta'
        facet = Template.currentData()
        
        delta = Docs.findOne type:'delta'
        if facet.filters and @name in facet.filters
            Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
        else 
            Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
                
                
                
Template.field.events
    'blur .label': (e,t)->
        delta = Docs.findOne type:'delta'
        doc = Docs.findOne delta.doc_id
        # val = 
        value = e.currentTarget.value
        Meteor.call 'update_field', delta.doc_id, @, 'label', value 
        
    'blur .value': ->
        console.log @
        
    'blur .key': ->
        console.log @
        
    'blur .type': ->
        console.log @
        
        
    'click .delete_field': ->
        # if confirm "Remove #{@label}?"
        delta = Docs.findOne type:'delta'
        doc = Docs.findOne delta.doc_id
        Docs.update delta.doc_id,
            $pull: fields: @
        
Template.field.onCreated ->
    @autorun => Meteor.subscribe 'type', 'field_type'
        
Template.field.helpers
    field_edit_template: ->
        # console.log "#{@field_type}_edit"
        "edit_#{@field_type}"

    field_object: ->
        delta = Docs.findOne type:'delta'
        @fields
        delta.editing_field
        
    field_value: -> 
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne delta.doc_id
        editing_doc["#{@key}"]
        
        
Template.set_field_key_value.events
    'click .set_field_key_value': ->
        delta = Docs.findOne type:'delta'
        current_field = Template.parentData()
        Meteor.call 'update_field', delta.doc_id, current_field, @key, @value 

Template.set_field_key_value.helpers
    field_key_class: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne delta.doc_id
        # console.log _.find(editing_doc.fields, (field)=> 
        #     if field.key is @key 
        #         console.log 'both', @key
        #     else
        #         console.log 'no', @key, field.key
        #     )
            
        if delta.editing_field["#{@key}"] is @value then 'blue' else ''