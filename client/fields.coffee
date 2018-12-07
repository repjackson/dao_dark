import Quill from 'quill'
# # Template.edit_image.events
# #     "change input[type='file']": (e) ->
# #         doc_id = delta.doc_id
# #         files = e.currentTarget.files


# #         Cloudinary.upload files[0],
# #             # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
# #             # type:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
# #             (err,res) -> #optional callback, you can catch with the Cloudinary collection as well
# #                 # console.log "Upload Error: #{err}"
# #                 # console.dir res
# #                 if err
# #                     console.error 'Error uploading', err
# #                     Bert.alert "Error uploading #{@label}: #{err}", 'danger', 'growl-top-right'
# #                 else
# #                     Docs.update doc_id, 
# #                         { $set: image_id: res.public_id }
# #                         , (err,res)=>
# #                             if err
# #                                 Bert.alert "Error Updating Image: #{error.reason}", 'danger', 'growl-top-right'
# #                             else
# #                                 Bert.alert "Updated Image", 'success', 'growl-top-right'
# #                 return

# #     'keydown #input_image_id': (e,t)->
# #         if e.which is 13
# #             doc_id = delta.doc_id
# #             image_id = $('#input_image_id').val().toLowerCase().trim()
# #             if image_id.length > 0
# #                 Docs.update doc_id,
# #                     $set: image_id: image_id
# #                 $('#input_image_id').val('')



# #     'click #remove_photo': ->
# #         swal {
# #             title: 'Remove Photo?'
# #             type: 'warning'
# #             animation: false
# #             showCancelButton: true
# #             closeOnConfirm: true
# #             cancelButtonText: 'No'
# #             confirmButtonText: 'Remove'
# #             confirmButtonColor: '#da5347'
# #         }, =>
# #             Meteor.call "c.delete_by_public_id", @image_id, (err,res) ->
# #                 if not err
# #                     # Do Stuff with res
# #                     # console.log res
# #                     Docs.update delta.doc_id, 
# #                         $unset: image_id: 1

# #                 else
# #                     throw new Meteor.Error "it failed"

# #     #         console.log Cloudinary
# #     # 		Cloudinary.delete "37hr", (err,res) ->
# #     # 		    if err 
# #     # 		        console.log "Upload Error: #{err}"
# #     # 		    else
# #     #     			console.log "Upload Result: #{res}"
# #     #                 # Docs.update delta.doc_id, 
# #     #                 #     $unset: image_id: 1

# #     # Template.edit_image.helpers
# #     #     log: -> console.log @



# Template.edit_number.events
#     'change #number_field': (e,t)->
#         number_value = parseInt e.currentTarget.value
#         Docs.update delta.doc_id,
#             { $set: "#{@key}": number_value }
#             , (err,res)=>
#                 if err
#                     Bert.alert "Error Updating #{@label}: #{error.reason}", 'danger', 'growl-top-right'
#                 else
#                     Bert.alert "Updated #{@label}", 'success', 'growl-top-right'
            
# Template.edit_textarea.events
#     'blur #textarea': (e,t)->
#         doc_id = delta.doc_id
#         textarea_value = $('#textarea').val()
#         Docs.update doc_id,
#             { $set: "#{@key}": textarea_value }
#             , (err,res)=>
#                 if err
#                     Bert.alert "Error Updating #{@label}: #{error.reason}", 'danger', 'growl-top-right'
#                 else
#                     Bert.alert "Updated #{@label}", 'success', 'growl-top-right'


# Template.edit_date.events
#     'change #date_field': (e,t)->
#         date_value = e.currentTarget.value
#         Docs.update delta.doc_id,
#             { $set: "#{@key}": date_value } 
#             , (err,res)=>
#                 if err
#                     Bert.alert "Error Updating #{@label}: #{error.reason}", 'danger', 'growl-top-right'
#                 else
#                     Bert.alert "Updated #{@label}", 'success', 'growl-top-right'


Template.edit_text.events
    'change #text_field': (e,t)->
        text_value = e.currentTarget.value
        Docs.update delta.doc_id,
            { $set: "#{@key}": text_value }
            , (err,res)=>
                if err
                    Bert.alert "Error Updating #{@label}: #{error.reason}", 'danger', 'growl-top-right'
                else
                    Bert.alert "Updated #{@label}", 'success', 'growl-top-right'




# Template.complete.events
#     'click #mark_complete': (e,t)->
#         Docs.update @_id,
#             $set: complete: true
#     'click #mark_incomplete': (e,t)->
#         Docs.update @_id,
#             $set: complete: false

# Template.complete.helpers
#     complete_class: -> if @complete then 'green' else 'basic'
#     incomplete_class: -> if @complete then 'basic' else 'red'


# Template.toggle_follow.helpers
#     is_following: -> if Meteor.user()?.following_ids then @_id in Meteor.user().following_ids
        
# Template.toggle_follow.events
#     'click #follow': (e,t)-> 
#         Meteor.users.update Meteor.userId(), $addToSet: following_ids: @_id

#         # Meteor.call 'add_notification', @_id, 'friended', Meteor.userId()

#     'click #unfollow': (e,t)-> 
#         Meteor.users.update Meteor.userId(), $pull: following_ids: @_id

#         # Meteor.call 'add_notification', @_id, 'unfriended', Meteor.userId()

# Template.vote_button.helpers
#     vote_up_button_class: ->
#         if not Meteor.userId() then 'disabled'
#         else if @upvoters and Meteor.userId() in @upvoters then 'green'
#         else 'outline'

#     vote_down_button_class: ->
#         if not Meteor.userId() then 'disabled'
#         else if @downvoters and Meteor.userId() in @downvoters then 'red'
#         else 'outline'

# Template.vote_button.events
#     'click .vote_up': (e,t)-> 
#         if Meteor.userId()
#             Meteor.call 'vote_up', @_id
#         else FlowRouter.go '/sign-in'

#     'click .vote_down': -> 
#         if Meteor.userId() then Meteor.call 'vote_down', @_id
#         else FlowRouter.go '/sign-in'
            
        
        
# Template.toggle_key.helpers
#     toggle_key_button_class: -> 
#         current_doc = Docs.findOne delta.doc_id
#         # console.log current_doc["#{@key}"]
#         # console.log @key
#         # console.log Template.parentData()
#         # console.log Template.parentData()["#{@key}"]
        
#         if @value
#             if current_doc["#{@key}"] is @value then 'active' else 'basic'
#         else if current_doc["#{@key}"] is true then 'active' else 'basic'


# Template.toggle_key.events
#     'click #toggle_key': ->
#         console.log Template.parentData()
#         # if @value
#         #     Docs.update delta.doc_id, 
#         #         $set: "#{@key}": "#{@value}"
#         # else if Template.parentData()["#{@key}"] is true
#         #     Docs.update delta.doc_id, 
#         #         $set: "#{@key}": false
#         # else
#         #     Docs.update delta.doc_id, 
#         #         $set: "#{@key}": true


Template.edit_html.onRendered ->
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


Template.edit_html.events
    'blur .editor': (e,t)->
        html = t.$('editor').val()
        console.log html
        
        # Docs.update Meteor.user().current_delta_id,
        #     $set: 
        #         html: html


Template.edit_html.helpers
    # getFEContext: ->
    #     @current_doc = Docs.findOne Meteor.user().current_delta_id
    #     self = @
    #     {
    #         _value: self.current_doc.incident_details
    #         _keepMarkers: true
    #         _className: 'froala-reactive-meteorized-override'
    #         toolbarInline: false
    #         initOnClick: false
    #         # imageInsertButtons: ['imageBack', '|', 'imageByURL']
    #         tabSpaces: false
    #         height: 300
    #     }



# Template.toggle_boolean.events
#     'click #make_featured': ->
#         Docs.update delta.doc_id,
#             $set: featured: true

#     'click #make_unfeatured': ->
#         Docs.update delta.doc_id,
#             $set: featured: false

Template.edit_array.events
    # "autocompleteselect input": (event, template, doc) ->
    #     # console.log("selected ", doc)
    #     Docs.update @doc_id,
    #         $addToSet: tags: doc.name
    #     $('.new_entry').val('')
   
    'keyup .new_entry': (e,t)->
        # console.log Template.parentData(0)
        # console.log Template.parentData(1)
        # console.log Template.parentData(2)
        # console.log Template.parentData(3)
        

        e.preventDefault()
        # val = $('.new_entry').val().toLowerCase().trim()                    
        val = $(e.currentTarget).closest('.new_entry').val().toLowerCase().trim()   

        switch e.which
            when 13 #enter
                unless val.length is 0
                    Docs.update delta.doc_id,
                        $addToSet: "#{@key}": val
                    # $('.new_entry').val ''
                    $(e.currentTarget).closest('.new_entry').val('')

            # when 8
            #     if val.length is 0
            #         result = Docs.findOne(@doc_id).tags.slice -1
            #         $('.new_entry').val result[0]
            #         Docs.update @doc_id,
            #             $pop: tags: 1


    'click .doc_tag': (e,t)->
        # console.log @valueOf()
        # console.log Template.parentData(0).key
        # console.log Template.parentData(1)
        # console.log Template.parentData(2)
        # console.log Template.parentData(3)

        tag = @valueOf()
        Docs.update delta.doc_id,
            $pull: "#{Template.parentData(0).key}": tag
        t.$('.new_entry').val(tag)
        
Template.edit_array.helpers
    # editing_mode: -> 
    #     console.log Session.get 'editing'
    #     if Session.equals 'editing', true then true else false
    # theme_select_settings: -> {
    #     position: 'top'
    #     limit: 10
    #     rules: [
    #         {
    #             collection: Tags
    #             field: 'name'
    #             matchAll: false
    #             template: Template.tag_result
    #         }
    #         ]
    # }



Template.boolean_edit.events
    'click .toggle_field': (e,t)->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id
        bool_value = target_doc["#{@key}"]
        # console.log t.data
        # console.log @

        if bool_value and bool_value is true
            Docs.update target_doc._id,
                $set: "#{t.data.key}": false
        else
            Docs.update target_doc._id,
                $set: "#{t.data.key}": true

Template.string_edit.events
    'blur .string_val': (e,t)->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id

        val = e.currentTarget.value
        Docs.update target_doc._id,
            $set:
                "#{t.data.key}": val

Template.number_edit.events
    'blur .number_val': (e,t)->
        # console.log Template.parentData()
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id

        val = parseInt e.currentTarget.value
        Docs.update target_doc._id,
            $set:
                "#{t.data.key}": val

Template.date_edit.events
    'blur .date_val': (e,t)->
        # console.log Template.parentData()
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id

        val = e.currentTarget.value
        Docs.update target_doc._id,
            $set:
                "#{t.data.key}": val

Template.textarea_edit.events
    'blur .textarea_val': (e,t)->
        # console.log Template.parentData()
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id

        val = e.currentTarget.value
        Docs.update target_doc._id,
            $set:
                "#{t.data.key}": val

Template.array_edit.events
    'keyup .add_array_element': (e,t)->
        if e.which is 13
            delta = Docs.findOne type:'delta'
            target_doc = Docs.findOne _id:delta.detail_id

            val = e.currentTarget.value
            Docs.update target_doc._id,
                $addToSet:
                    "#{t.data.key}": val
            t.$('.add_array_element').val('')

    'click .pull_element': (e,t)->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id
        field_doc = Template.currentData()

        Docs.update target_doc._id,
            $pull:
                "#{field_doc.key}": @valueOf()



Template.boolean_edit.helpers
    bool_switch_class: ->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id
        bool_value = target_doc?["#{@key}"]
        if bool_value and bool_value is true
            'blue'
        else
            ''

Template.string_edit.helpers
    value: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne _id:delta.detail_id
        console.log 'target doc', editing_doc
        value = editing_doc["#{@key}"]

Template.date_edit.helpers
    value: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne _id:delta.detail_id
        console.log 'target doc', editing_doc
        value = editing_doc["#{@key}"]

Template.field_view.helpers
    value: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne _id:delta.detail_id
        value = editing_doc["#{@slug}"]

    is_array: -> @field_type is 'array'

Template.number_edit.helpers
    value: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne _id:delta.detail_id
        console.log 'target doc', editing_doc
        value = editing_doc["#{@key}"]

Template.textarea_edit.helpers
    value: ->
        delta = Docs.findOne type:'delta'
        editing_doc = Docs.findOne _id:delta.detail_id
        # console.log 'target doc', editing_doc
        value = editing_doc["#{@key}"]


Template.array_edit.helpers
    value: ->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id
        target_doc?["#{@key}"]

Template.multiref_edit.onCreated ->
    @autorun => Meteor.subscribe 'type', @data.ref_schema
Template.ref_edit.onCreated ->
    @autorun => Meteor.subscribe 'type', @data.ref_schema

Template.multiref_edit.helpers
    choices: ->
        Docs.find
            type:@ref_schema

    value: ->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id
        target_doc["#{@key}"]

    element_class: ->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id
        parent = Template.parentData()

        value =
            if @key then @key
            else if @slug then @slug
            else if @username then @username
        if value in target_doc?["#{parent?.key}"] then 'blue' else ''


Template.multiref_edit.events
    'click .toggle_element': (e,t)->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id
        editing_field = Template.currentData().key
        value =
            if @key then @key
            else if @slug then @slug
            else if @username then @username
        if value in target_doc["#{editing_field}"]
            Docs.update target_doc._id,
                $pull:"#{editing_field}": value
        else
            Docs.update target_doc._id,
                $addToSet:"#{editing_field}": value




Template.ref_edit.events
    'click .choose_element': (e,t)->
        delta = Docs.findOne type:'delta'
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
            type:@ref_schema
    element_class: ->
        delta = Docs.findOne type:'delta'
        target_doc = Docs.findOne _id:delta.detail_id
        parent = Template.parentData()

        value =
            if @key then @key
            else if @slug then @slug
            else if @username then @username
        if target_doc?["#{parent.key}"] is value then 'blue' else ''
