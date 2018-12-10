Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'



Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
    
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
    if Meteor.user() and Meteor.user().current_delta_id
        delta = Docs.findOne Meteor.user().current_delta_id
        if delta.doc_id
            Docs.findOne delta.doc_id

Template.registerHelper 'in_dao', () -> 
    Meteor.user() and Meteor.user().current_tribe_id is 'X2xn6Bo45FnbefJe5'

Template.registerHelper 'my_tribe', () -> 
    if Meteor.user()
        Docs.findOne
            _id: Meteor.user().current_tribe_id


Template.registerHelper 'tribes', () -> 
    Docs.find 
        schema:'tribe'

Template.registerHelper 'my_deltas', () -> 
    Docs.find schema:'delta'


Template.registerHelper 'current_delta', () -> 
    if Meteor.user() and Meteor.user().current_delta_id
        delta = Docs.findOne Meteor.user().current_delta_id


Template.registerHelper 'current_module', () -> 
    if Meteor.user() and Meteor.user().current_delta_id
        delta = Docs.findOne Meteor.user().current_delta_id
        if delta.module_id
            Docs.findOne delta.module_id




Template.edit.onCreated ->
    delta = Docs.findOne Meteor.user().current_delta_id
    @autorun -> Meteor.subscribe 'doc_id', delta.doc_id




Template.home.helpers
    main_template: ->
        if Meteor.user()
            Meteor.user().current_template
        else
            'public'
        

Template.facet.helpers
    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne Meteor.user().current_delta_id

        if facet.filters and @name in facet.filters
            'grey'
        else
            ''

Template.edit.events
    'click .save': ->
        delta = Docs.findOne Meteor.user().current_delta_id
        Docs.update delta._id,
            $set:
                editing:false
                result:@
    
    'click .detect_fields': ->
        delta = Docs.findOne Meteor.user().current_delta_id
        editing_doc = Docs.findOne delta.doc_id
        Meteor.call 'detect_fields', editing_doc._id      
    
    
    'click .set_editing_field': ->
        delta = Docs.findOne Meteor.user().current_delta_id
        editing_doc = Docs.findOne delta.doc_id
        Docs.update delta._id,
            $set: editing_field: @
    
    'click .add_field': ->
        delta = Docs.findOne Meteor.user().current_delta_id
        editing_doc = Docs.findOne delta.doc_id
        
        new_field = {
            label:'New Field'
            key:'new_field'
            schema:'string'
            }    
    
        Docs.update delta.doc_id,
            $addToSet:
                fields: new_field
    
        
Template.edit.helpers
    editing_doc: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        doc = Docs.findOne delta.doc_id
        doc
        



                
Template.field.events
    'blur .label': (e,t)->
        delta = Docs.findOne Meteor.user().current_delta_id
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
        delta = Docs.findOne Meteor.user().current_delta_id
        doc = Docs.findOne delta.doc_id
        Docs.update delta.doc_id,
            $pull: fields: @
        
Template.field.onCreated ->
    @autorun => Meteor.subscribe 'schema', 'field_type'
        
Template.field.helpers
    field_edit_template: ->
        # console.log "#{@field_type}_edit"
        "edit_#{@field_type}"

    field_object: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        @fields
        delta.editing_field
        
    field_value: -> 
        delta = Docs.findOne Meteor.user().current_delta_id
        editing_doc = Docs.findOne delta.doc_id
        editing_doc["#{@key}"]
        
        
Template.set_field_key_value.events
    'click .set_field_key_value': ->
        delta = Docs.findOne Meteor.user().current_delta_id
        current_field = Template.parentData()
        Meteor.call 'update_field', delta.doc_id, current_field, @key, @value 

Template.set_field_key_value.helpers
    field_key_class: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        editing_doc = Docs.findOne delta.doc_id
        # console.log _.find(editing_doc.fields, (field)=> 
        #     if field.key is @key 
        #         console.log 'both', @key
        #     else
        #         console.log 'no', @key, field.key
        #     )
            
        if delta.editing_field["#{@key}"] is @value then 'blue' else ''