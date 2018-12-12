import Quill from 'quill'

Template.html_edit.onRendered ->
    toolbarOptions = [
      { size: [ 'small', false, 'large', 'huge' ]}
    ]

    options = 
        debug: 'info'
        modules: 
            toolbar: toolbarOptions
        placeholder: 'Compose an epic...'
        readOnly: false
        theme: 'snow'

    editor = new Quill('.editor', options)




Template.field.onCreated ->
    @autorun => Meteor.subscribe 'schema', 'field_type'
        
Template.field.helpers

    field_object: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        @fields
        delta.editing_field
        

                
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
        
        


Template.string_edit.helpers
    value: ->
        parent = Template.parentData()
        console.log parent
        value = parent["#{@key}"]



Template.string_edit.events
    'blur .string_val': (e,t)->
        parent = Template.parentData(5)
        val = e.currentTarget.value
        
        Docs.update parent._id,
            $set:
                "#{@slug}": val
        Meteor.call 'fo'



Template.number_edit.events
    'blur .number_val': (e,t)->
        # console.log Template.parentData()
        delta = Docs.findOne Meteor.user().current_delta_id
        target_doc = Docs.findOne _id:delta.detail_id

        val = parseInt e.currentTarget.value
        Docs.update target_doc._id,
            $set:
                "#{t.data.key}": val

Template.date_edit.events
    'blur .date_val': (e,t)->
        # console.log Template.parentData()
        delta = Docs.findOne Meteor.user().current_delta_id
        target_doc = Docs.findOne _id:delta.detail_id

        val = e.currentTarget.value
        Docs.update target_doc._id,
            $set:
                "#{t.data.key}": val

Template.textarea_edit.events
    'blur .textarea_val': (e,t)->
        # console.log Template.parentData()
        delta = Docs.findOne Meteor.user().current_delta_id
        target_doc = Docs.findOne _id:delta.detail_id

        val = e.currentTarget.value
        Docs.update target_doc._id,
            $set:
                "#{t.data.key}": val

Template.array_edit.events
    'keyup .add_array_element': (e,t)->
        if e.which is 13
            delta = Docs.findOne Meteor.user().current_delta_id
            target_doc = Docs.findOne _id:delta.detail_id

            val = e.currentTarget.value
            Docs.update target_doc._id,
                $addToSet:
                    "#{t.data.key}": val
            t.$('.add_array_element').val('')

    'click .pull_element': (e,t)->
        delta = Docs.findOne Meteor.user().current_delta_id
        target_doc = Docs.findOne _id:delta.detail_id
        field_doc = Template.currentData()

        Docs.update target_doc._id,
            $pull:
                "#{field_doc.key}": @valueOf()



Template.boolean_edit.helpers
    bool_switch_class: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        target_doc = Docs.findOne _id:delta.detail_id
        bool_value = target_doc?["#{@key}"]
        if bool_value and bool_value is true
            'blue'
        else
            ''


Template.date_edit.helpers
    value: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        editing_doc = Docs.findOne _id:delta.detail_id
        console.log 'target doc', editing_doc
        value = editing_doc["#{@key}"]

Template.field_view.helpers
    value: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        editing_doc = Docs.findOne _id:delta.detail_id
        value = editing_doc["#{@slug}"]

    is_array: -> @field_type is 'array'

Template.number_edit.helpers
    value: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        editing_doc = Docs.findOne _id:delta.detail_id
        console.log 'target doc', editing_doc
        value = editing_doc["#{@key}"]

Template.textarea_edit.helpers
    value: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        editing_doc = Docs.findOne _id:delta.detail_id
        # console.log 'target doc', editing_doc
        value = editing_doc["#{@key}"]


Template.array_edit.helpers
    value: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        target_doc = Docs.findOne _id:delta.detail_id
        target_doc?["#{@key}"]

Template.multiref_edit.onCreated ->
    @autorun => Meteor.subscribe 'schema', @data.schema
Template.ref_edit.onCreated ->
    @autorun => Meteor.subscribe 'schema', @data.schema

Template.multiref_edit.helpers
    choices: ->
        Docs.find
            schema:@schema

    ref_class: ->
        parent = Template.parentData(2)
        # console.log @
        # console.log parent
        
        if parent["#{@schema}_ids"] and @_id in parent["#{@schema}_ids"] then 'grey' else ''


Template.multiref_edit.events
    'click .toggle_ref': (e,t)->
        parent = Template.parentData()
        # console.log @
        # console.log parent

        if parent["#{@schema}_ids"] and @_id in parent["#{@schema}_ids"]
            Docs.update parent._id,
                $pull:"#{@schema}_ids": @_id
                , ->
            Docs.update parent._id,
                $pull:"#{parent.schema}_ids": parent._id
                , ->
        else
            Docs.update parent._id,
                $addToSet:"#{@schema}_ids": @_id
                , ->
            Docs.update @_id,
                $addToSet:"#{parent.schema}_ids": parent._id
                , ->
        Meteor.call 'fo'



Template.ref_edit.events
    'click .choose_element': (e,t)->
        delta = Docs.findOne Meteor.user().current_delta_id
        target_doc = Docs.findOne _id:delta.detail_id
        editing_field = Template.currentData().key
        value =
            if @key then @key
            else if @slug then @slug
            else if @username then @username

        Docs.update target_doc._id,
            $set:"#{editing_field}": value

Template.ref_edit.helpers
    choices: ->
        Docs.find
            schema:@schema
    element_class: ->
        delta = Docs.findOne Meteor.user().current_delta_id
        target_doc = Docs.findOne _id:delta.detail_id
        parent = Template.parentData()

        value =
            if @key then @key
            else if @slug then @slug
            else if @username then @username
        if target_doc?["#{parent.key}"] is value then 'blue' else ''
