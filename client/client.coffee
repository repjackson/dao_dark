Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'



Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

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

Template.registerHelper 'field_edit_template', () -> 
    field = Docs.findOne
        schema:'data_type'
        _id: $in: @data_type_ids
    if field.slug
        "#{field.slug}_edit"

Template.registerHelper 'field_view_template', () -> 
    field = Docs.findOne
        schema:'data_type'
        _id: $in: @data_type_ids
    if field.slug
        "#{field.slug}_view"

        
Template.registerHelper 'editing', () ->
    delta = Docs.findOne Meteor.user().current_delta_id
    parent = Template.parentData()
    # console.log parent.schema
    # if parent._id is delta.editing_id then true else false
    if parent and parent._id is delta.editing_id then true else false
        


Template.registerHelper 'tribes', () -> 
    Docs.find 
        schema:'tribe'


Template.registerHelper 'current_delta', () -> 
    if Meteor.user() and Meteor.user().current_delta_id
        delta = Docs.findOne Meteor.user().current_delta_id


Template.registerHelper 'current_module', () -> 
    if Meteor.user() and Meteor.user().current_delta_id
        delta = Docs.findOne Meteor.user().current_delta_id
        if delta.module_id
            Docs.findOne delta.module_id


Template.registerHelper 'current_schema_fields', () -> 
    if Meteor.user() and Meteor.user().current_delta_id
        delta = Docs.findOne Meteor.user().current_delta_id
        if delta.module_id
            current_module = Docs.findOne delta.module_id
            # console.log 'current module', current_module
            module_child_schema = 
                Docs.findOne
                    schema:'schema'
                    slug: current_module?.child_schema
                    
            Docs.find({
                _id: $in: module_child_schema?.field_ids
                schema:'field'
                }).fetch()
                

Template.registerHelper 'field_value', () -> 
    parent =  Template.parentData(5)
    if parent["#{@slug}"]
        parent["#{@slug}"]



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