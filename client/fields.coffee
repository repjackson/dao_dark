Template.edit_icon_field.events
    'blur #icon_class': (e,t)->
        val = $(e.currentTarget).closest('#icon_class').val()

        Docs.update FlowRouter.getParam('doc_id'),
            $set: icon_class: val
            


            
Template.edit_string_field.events
    'blur #value': (e,t)->
        console.log @key
        value = $(e.currentTarget).closest('#value').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: "#{@key}": value
            
            
            
            
Template.edit_link_field.events
    'blur #link': (e,t)->
        link = $(e.currentTarget).closest('#link').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: link: link
            
            
            
Template.view_uploaded_image_field.helpers
    uploaded_image_field_value: ->
        context_doc = Template.parentData(1)
        context_doc["#{@key}"]


Template.edit_uploaded_image_field.helpers
    context_doc: -> Template.parentData(3)


Template.edit_uploaded_image_field.events
    "change input[type='file']": (e) ->
        doc_id = FlowRouter.getParam('doc_id')
        files = e.currentTarget.files


        Cloudinary.upload files[0],
            # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
            # type:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
            (err,res) -> #optional callback, you can catch with the Cloudinary collection as well
                # console.log "Upload Error: #{err}"
                # console.dir res
                if err
                    console.error 'Error uploading', err
                else
                    Docs.update doc_id, $set: image_id: res.public_id
                return

    'keydown #input_image_id': (e,t)->
        if e.which is 13
            doc_id = FlowRouter.getParam('doc_id')
            image_id = $('#input_image_id').val().toLowerCase().trim()
            if image_id.length > 0
                Docs.update doc_id,
                    $set: image_id: image_id
                $('#input_image_id').val('')



    'click #remove_photo': ->
        swal {
            title: 'Remove Photo?'
            type: 'warning'
            animation: false
            showCancelButton: true
            closeOnConfirm: true
            cancelButtonText: 'No'
            confirmButtonText: 'Remove'
            confirmButtonColor: '#da5347'
        }, =>
            Meteor.call "c.delete_by_public_id", @image_id, (err,res) =>
                if not err
                    # Do Stuff with res
                    # console.log res
                    # console.log @image_id, FlowRouter.getParam('doc_id')
                    Docs.update FlowRouter.getParam('doc_id'), 
                        $unset: 
                            image_id: 1

                else
                    throw new Meteor.Error "it failed miserably"


Template.edit_linked_image_field.events
    # todo fix for dymanic
    'click #remove_image_url': ->
        Docs.update FlowRouter.getParam('doc_id'), 
            $unset: 
                image_url: 1
        
    'blur #image_url': ->
        image_url = $('#image_url').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: image_url: image_url


Template.edit_transcript_field.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        # doc_id = FlowRouter.getParam('doc_id')

        Docs.update @_id,
            $set: transcript: html
                

Template.edit_transcript_field.helpers
    transcript_context: ->
        @current_doc = Docs.findOne FlowRouter.getParam('doc_id')
        self = @
        {
            _value: self.current_doc.transcript
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            toolbarButtons:
                [
                  'fullscreen'
                  'bold'
                  'italic'
                  'underline'
                  'strikeThrough'
                #   'subscript'
                #   'superscript'
                  '|'
                #   'fontFamily'
                  'fontSize'
                  'color'
                #   'inlineStyle'
                #   'paragraphStyle'
                  '|'
                  'paragraphFormat'
                  'align'
                  'formatOL'
                  'formatUL'
                  'outdent'
                  'indent'
                  'quote'
                #   '-'
                  'insertLink'
                #   'insertImage'
                #   'insertVideo'
                #   'embedly'
                #   'insertFile'
                #   'insertTable'
                #   '|'
                  'emoticons'
                #   'specialCharacters'
                #   'insertHR'
                  'selectAll'
                  'clearFormatting'
                  '|'
                #   'print'
                #   'spellChecker'
                #   'help'
                  'html'
                #   '|'
                  'undo'
                  'redo'
                ]
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
        }


Template.edit_youtube_field.events
    'blur #youtube': (e,t)->
        youtube = $(e.currentTarget).closest('#youtube').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: youtube: youtube
            
    'click #clear_youtube': (e,t)->
        $(e.currentTarget).closest('#youtube').val('')
        Docs.update FlowRouter.getParam('doc_id'),
            $unset: youtube: 1
            
Template.edit_youtube_field.onRendered ->
    Meteor.setTimeout (->
        $('.ui.embed').embed()
    ), 2000

Template.view_youtube_field.onRendered ->
    Meteor.setTimeout (->
        $('.ui.embed').embed()
    ), 2000


# vimeo
Template.edit_vimeo_field.events
    'blur #vimeo': (e,t)->
        vimeo = $(e.currentTarget).closest('#vimeo').val()
        Docs.update FlowRouter.getParam('doc_id'),
            $set: vimeo: vimeo
            
    'click #clear_vimeo': (e,t)->
        $(e.currentTarget).closest('#vimeo').val('')
        Docs.update FlowRouter.getParam('doc_id'),
            $unset: vimeo: 1
            
Template.edit_vimeo_field.onRendered ->
    Meteor.setTimeout (->
        $('.ui.embed').embed()
    ), 2000

Template.view_vimeo_field.onRendered ->
    Meteor.setTimeout (->
        $('.ui.embed').embed()
    ), 2000




# Template.participants.onCreated ->
#     Meteor.subscribe 'usernames'

# Template.participants.events
#     "autocompleteselect input": (event, template, doc) ->
#         # console.log("selected ", doc)
#         Docs.update FlowRouter.getParam('doc_id'),
#             $addToSet: participant_ids: doc._id
#         $('#participant_select').val("")
   
#     'click #remove_participant': (e,t)->
#         # console.log @
#         Docs.update FlowRouter.getParam('doc_id'),
#             $pull: participant_ids: FlowRouter.getParam('doc_id')



# Template.participants.helpers
#     participants_edit_settings: -> {
#         position: 'bottom'
#         limit: 10
#         rules: [
#             {
#                 collection: Meteor.users
#                 field: 'username'
#                 matchAll: true
#                 template: Template.user_pill
#             }
#             ]
#     }

#     participants: ->
#         participants = []
        
#         for participant_id in @participant_ids
#             participants.push Meteor.users.findOne(participant_id)
#         participants

# Template.datetime.onRendered ->
#     Meteor.setTimeout (->
#         $('#datetimepicker').datetimepicker(
#             onChangeDateTime: (dp,$input)->
#                 val = $input.val()

#                 # console.log moment(val).format("dddd, MMMM Do YYYY, h:mm:ss a")
#                 minute = moment(val).minute()
#                 hour = moment(val).format('h')
#                 date = moment(val).format('Do')
#                 ampm = moment(val).format('a')
#                 weekdaynum = moment(val).isoWeekday()
#                 weekday = moment().isoWeekday(weekdaynum).format('dddd')

#                 month = moment(val).format('MMMM')
#                 year = moment(val).format('YYYY')

#                 datearray = [hour, minute, ampm, weekday, month, date, year]

#                 docid = FlowRouter.getParam 'docId'

#                 doc = Docs.findOne docid
#                 tagsWithoutDate = _.difference(doc.tags, doc.datearray)
#                 tagsWithNew = _.union(tagsWithoutDate, datearray)

#                 Docs.update docid,
#                     $set:
#                         tags: tagsWithNew
#                         datearray: datearray
#                         dateTime: val
#             )), 2000

# Template.location.onRendered ->
#     @autorun ->
#         if GoogleMaps.loaded()
#             $('#place').geocomplete().bind 'geocode:result', (event, result) ->
#                 docid = Session.get 'editing'
#                 Meteor.call 'updatelocation', docid, result, ->

# Template.location.events
#     'click .clearDT': ->
#         tagsWithoutDate = _.difference(@tags, @datearray)
#         Docs.update FlowRouter.getParam('docId'),
#             $set:
#                 tags: tagsWithoutDate
#                 datearray: []
#                 dateTime: null
#         $('#datetimepicker').val('')




#     'click #analyzeBody': ->
#         Docs.update FlowRouter.getParam('docId'),
#             $set: body: $('#body').val()
#         Meteor.call 'analyze', FlowRouter.getParam('docId')

#     'click .docKeyword': ->
#         docId = FlowRouter.getParam('docId')
#         doc = Docs.findOne docId
#         loweredTag = @text.toLowerCase()
#         if @text in doc.tags
#             Docs.update FlowRouter.getParam('docId'), $pull: tags: loweredTag
#         else
#             Docs.update FlowRouter.getParam('docId'), $push: tags: loweredTag

#     docKeywordClass: ->
#         docId = FlowRouter.getParam('docId')
#         doc = Docs.findOne docId
#         if @text.toLowerCase() in doc.tags then 'disabled' else ''


# Template.edit_author.onCreated ->
#     Meteor.subscribe 'usernames'

# Template.edit_author.events
#     "autocompleteselect input": (event, template, doc) ->
#         # console.log("selected ", doc)
#         if confirm 'Change author?'
#             Docs.update FlowRouter.getParam('doc_id'),
#                 $set: author_id: doc._id
#             $('#author_select').val("")



# Template.edit_author.helpers
#     author_edit_settings: -> {
#         position: 'bottom'
#         limit: 10
#         rules: [
#             {
#                 collection: Meteor.users
#                 field: 'username'
#                 matchAll: true
#                 template: Template.user_pill
#             }
#             ]
#     }

    # edit_author: ->
    #     participants = []
        
    #     for participant_id in @participant_ids
    #         participants.push Meteor.users.findOne(participant_id)
    #     participants
# Template.edit_recipient.onCreated ->
#     Meteor.subscribe 'usernames'

# Template.edit_recipient.events
#     "autocompleteselect input": (event, template, doc) ->
#         # console.log("selected ", doc)
#         Docs.update FlowRouter.getParam('doc_id'),
#             $set: recipient_id: doc._id
#         $('#recipient_select').val("")


# Template.edit_recipient.helpers
#     recipient_select_settings: -> {
#         position: 'bottom'
#         limit: 10
#         rules: [
#             {
#                 collection: Meteor.users
#                 field: 'username'
#                 matchAll: true
#                 template: Template.user_pill
#             }
#             ]
#     }

    # edit_participant: ->
    #     participants = []
        
    #     for participant_id in @participant_ids
    #         participants.push Meteor.users.findOne(participant_id)
    #     participants


# Template.start_date.events
#     'blur #start_date': ->
#         start_date = $('#start_date').val()
#         Docs.update FlowRouter.getParam('doc_id'),
#             $set: start_date: start_date
    
# Template.end_date.events
#     'blur #end_date': ->
#         end_date = $('#end_date').val()
#         Docs.update FlowRouter.getParam('doc_id'),
#             $set: end_date: end_date

# Template.time_marker.events
#     'blur #time_marker': ->
#         time_marker = parseFloat $('#time_marker').val()
#         Docs.update FlowRouter.getParam('doc_id'),
#             $set: time_marker: time_marker


# Template.remove_field.events
#     'click .remove_field':  ->
#         # console.log @slug
#         self = @
#         swal {
#             title: "Remove #{@slug} field?"
#             type: 'warning'
#             animation: false
#             showCancelButton: true
#             closeOnConfirm: true
#             cancelButtonText: 'Cancel'
#             confirmButtonText: 'Remove'
#             confirmButtonColor: '#da5347'
#         }, =>
#             parent_doc = Docs.findOne FlowRouter.getParam('doc_id')
#             Docs.update parent_doc._id, 
#                 $unset: 
#                     "#{self.slug}": 1
#             # swal("#{self.field} removed", "", "success")
#             swal {
#                 title: "Removed #{self.slug} field."
#                 type: 'success'
#                 animation: false
#                 showCancelButton: false
#                 closeOnConfirm: true
#                 # cancelButtonText: 'Cancel'
#                 confirmButtonText: 'Ok'
#                 # confirmButtonColor: '#da5347'
#             }
            
            
    
Template.view_transcript_field.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
Template.edit_transcript_field.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
            
# Template.start_datetime.events
#     'blur #start_datetime': ->
#         start_datetime = $('#start_datetime').val()
#         Docs.update FlowRouter.getParam('doc_id'),
#             $set: start_datetime: start_datetime


# Template.end_datetime.events
#     'blur #end_datetime': ->
#         end_datetime = $('#end_datetime').val()
#         Docs.update FlowRouter.getParam('doc_id'),
#             $set: end_datetime: end_datetime


Template.view_text_field.helpers
    field_doc: -> Docs.findOne Template.parentData(2)
        
        
        
        
Template.view_field.helpers
    is_array: -> @template is 'array' 
    is_html: -> @template is 'html' 
    is_text: -> @template is 'text' 
    is_youtube: -> @template is 'youtube' 
    is_vimeo: -> @template is 'vimeo' 
    is_linked_image: -> @template is 'linked_image' 
    is_uploaded_image: -> @template is 'uploaded_image' 
        # console.log @
       
Template.edit_field.helpers
    is_array: -> @template is 'array' 
    is_html: -> @template is 'html' 
    is_text: -> @template is 'text' 
    is_youtube: -> @template is 'youtube' 
    is_vimeo: -> @template is 'vimeo' 
    is_linked_image: -> @template is 'linked_image' 
    is_uploaded_image: -> @template is 'uploaded_image' 
       
# Template.field_edit_template.helpers
#     field_doc: -> 
#         # console.log @
#         Docs.findOne @valueOf()
        
#     edit_field_template: ->
#         field_doc = Docs.findOne @valueOf()
#         if field_doc
#             "edit_#{field_doc.field_template}_field"

            
Template.edit_html_field.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        # console.log 'html', html
        if @type is 'direct'
            context_doc = Template.parentData(1)
        else
            context_doc = Template.parentData(3)

        Docs.update context_doc._id,
            $set: "#{@key}": html
                

Template.edit_html_field.helpers
    getFEContext: ->
        console.log @
        console.log Template.parentData(1)
        if @type is 'direct'
            context_doc = Template.parentData(1)
        else
            context_doc = Template.parentData(3)
        # @current_doc = Docs.findOne FlowRouter.getParam 'doc_id'
        # @current_doc = Docs.findOne @_id
        self = @
        {
            _value: context_doc["#{@key}"]
            _keepMarkers: true
            _className: 'froala-reactive-meteorized-override'
            toolbarInline: false
            initOnClick: false
            toolbarButtons:
                [
                  'fullscreen'
                  'bold'
                  'italic'
                  'underline'
                  'strikeThrough'
                #   'subscript'
                #   'superscript'
                  '|'
                #   'fontFamily'
                  'fontSize'
                  'color'
                #   'inlineStyle'
                #   'paragraphStyle'
                  '|'
                  'paragraphFormat'
                  'align'
                  'formatOL'
                  'formatUL'
                  'outdent'
                  'indent'
                  'quote'
                #   '-'
                  'insertLink'
                #   'insertImage'
                #   'insertVideo'
                #   'embedly'
                #   'insertFile'
                  'insertTable'
                #   '|'
                  'emoticons'
                #   'specialCharacters'
                #   'insertHR'
                  'selectAll'
                  'clearFormatting'
                  '|'
                #   'print'
                #   'spellChecker'
                #   'help'
                  'html'
                #   '|'
                  'undo'
                  'redo'
                ]
            toolbarButtonsMD: ['bold', 'italic', 'underline']
            toolbarButtonsSM: ['bold', 'italic', 'underline']
            toolbarButtonsXS: ['bold', 'italic', 'underline']
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 200
        }
            
            
            
Template.edit_array_field.events
    # "autocompleteselect input": (event, template, doc) ->
    #     # console.log("selected ", doc)
    #     Docs.update FlowRouter.getParam('doc_id'),
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
                    Docs.update FlowRouter.getParam('doc_id'),
                        $addToSet: "#{@key}": val
                    # $('.new_entry').val ''
                    $(e.currentTarget).closest('.new_entry').val('')

            # when 8
            #     if val.length is 0
            #         result = Docs.findOne(FlowRouter.getParam('doc_id')).tags.slice -1
            #         $('.new_entry').val result[0]
            #         Docs.update FlowRouter.getParam('doc_id'),
            #             $pop: tags: 1


    'click .doc_tag': (e,t)->
        # console.log @valueOf()
        # console.log Template.parentData(0).key
        # console.log Template.parentData(1)
        # console.log Template.parentData(2)
        # console.log Template.parentData(3)

        tag = @valueOf()
        Docs.update FlowRouter.getParam('doc_id'),
            $pull: "#{Template.parentData(0).key}": tag
        t.$('.new_entry').val(tag)
        
Template.edit_array_field.helpers
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
            
            
            
# Template.databank_edit_text_field.events
#     'blur #text_field_input': (e,t)->
#         # puling key from parent databank 
#         field_key = Docs.findOne(Template.parentData(3)).slug
#         value = $(e.currentTarget).closest('#text_field_input').val()
#         # console.log value
#         Docs.update FlowRouter.getParam('doc_id'),
#             $set: "#{field_key}": value
            
Template.edit_text_field.events
    'blur #value': (e,t)->
        # console.log @
        value = $(e.currentTarget).closest('#value').val()
        # console.log value
        Docs.update FlowRouter.getParam('doc_id'),
            $set: "#{@key}": value
            
# Template.edit_text_field.helpers
#     field_value: ->
#         # console.log @
#         current_doc = Docs.findOne FlowRouter.getParam('doc_id')
#         current_doc["#{@key}"]
            
            
Template.view_html_field.helpers
    html_field_value: ->
        context_doc = Template.parentData(3)
        context_doc["#{@key}"]
            
            
Template.view_array_field.helpers
    field_doc: -> Docs.findOne Template.parentData(2)

Template.edit_array_field.helpers
    field_doc: -> Docs.findOne Template.parentData(2)


Template.view_youtube_field.helpers
    youtube_field_value: ->
        context_doc = Template.parentData(3)
        # console.log context_doc["#{@key}"]
        context_doc["#{@key}"]

Template.view_linked_image_field.helpers
    linked_image_value: ->
        # console.log @
        context_doc = Template.parentData(3)
        # console.log Template.parentData(3)

        # console.log context_doc["#{@key}"]
        context_doc["#{@key}"]


Template.edit_youtube_field.helpers
    context_doc: -> Template.parentData(3)

Template.edit_linked_image_field.helpers
    context_doc: -> Template.parentData(3)


