
Template.color_edit.events
    'blur .edit_color': (e,t)->
        link_val = t.$('.edit_color').val()
        parent = Template.parentData()
        brick = Template.parentData(4)
        context = Template.parentData(5)
        Docs.update context._id,
            $set:"#{brick.key}":link_val




Template.link_edit.events
    'blur .edit_url': (e,t)->
        link_val = t.$('.edit_url').val()
        parent = Template.parentData()
        brick = Template.parentData(4)
        context = Template.parentData(5)
        Docs.update context._id,
            $set:"#{brick.key}":link_val



Template.html_edit.events
    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        # console.log 'html', html
        # console.log @
        brick = Template.parentData(4)
        context = Template.parentData(5)
        
        Docs.update context._id,
            $set:"#{brick.key}":html
                

Template.html_edit.helpers
    getFEContext: ->
        # console.log @
        # console.log Template.parentData(1)
        brick = Template.parentData(4)
        context = Template.parentData(5)
        # @current_doc = Docs.findOne Router.current().params.doc_id
        # @current_doc = Docs.findOne @_id
        self = @
        {
            _value: context["#{brick.key}"]
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
            # toolbarButtonsMD: ['bold', 'italic', 'underline']
            # toolbarButtonsSM: ['bold', 'italic', 'underline']
            toolbarButtonsXS: ['bold', 'italic', 'underline']
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 200
        }





Template.image_edit.events
    "change input[name='upload_image']": (e) ->
        files = e.currentTarget.files
        console.log files
        parent = Template.parentData()
        brick = Template.parentData(4)
        context = Template.parentData(5)
        Cloudinary.upload files[0],
            # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
            # type:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
            (err,res) => #optional callback, you can catch with the Cloudinary collection as well
                # console.log "Upload Error: #{err}"
                console.dir res
                if err
                    console.error 'Error uploading', err
                else
                    console.log res
        
                    if brick
                        Docs.update context._id,
                            $set:"#{brick.key}":res.public_id
                    else 
                        Docs.update parent._id,
                            $set:"#{@key}":res.public_id
                return

    'click #remove_photo': ->
        parent = Template.parentData()
        brick = Template.parentData(4)
        context = Template.parentData(5)

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
            # Meteor.call "c.delete_by_public_id", @image_id, (err,res) =>
            Docs.update context._id, 
                $unset:"#{brick.key}":1
                # if not err
                #     # Do Stuff with res
                #     # console.log res
                #     # console.log @image_id, FlowRouter.getParam('doc_id')

                # else
                #     throw new Meteor.Error "it failed"





Template.array_edit.events
    'keyup .new_element': (e,t)->
        if e.which is 13
            element_val = t.$('.new_element').val().trim()
            # # console.log element_val
            parent = Template.parentData()
            brick = Template.parentData(4)
            context = Template.parentData(5)

            if brick
                Docs.update context._id,
                    $addToSet:"#{brick.key}":element_val
            else 
                Docs.update parent._id,
                    $addToSet:"#{@key}":element_val
            
            t.$('.new_element').val('')

    'click .remove_element': (e,t)->
        element = @valueOf()
        console.log @
        field = Template.currentData()
        parent = Template.parentData()
        brick = Template.parentData(4)
        context = Template.parentData(5)

        if brick
            Docs.update context._id,
                $pull:"#{field.key}":element
        else 
            Docs.update parent._id,
                $pull:"#{field.key}":element

        t.$('.new_element').focus()
        t.$('.new_element').val(element)


# Template.textarea.onCreated ->
#     @editing = new ReactiveVar false

# Template.textarea.helpers
#     is_editing: -> Template.instance().editing.get()
    
    
Template.textarea_edit.events
    # 'click .toggle_edit': (e,t)->
    #     t.editing.set !t.editing.get()

    'blur .edit_textarea': (e,t)->
        textarea_val = t.$('.edit_textarea').val()
        parent = Template.parentData()
        brick = Template.parentData(4)
        context = Template.parentData(5)
        
        if brick
            Docs.update context._id,
                $set:"#{brick.key}":textarea_val
        else 
            if @collection and @collection is 'users'
                Meteor.users.update parent._id,
                    $set:"#{@key}":textarea_val
            else 
                Docs.update parent._id,
                    $set:"#{@key}":textarea_val



Template.text_edit.events
    'blur .edit_text': (e,t)->
        val = t.$('.edit_text').val()
        parent = Template.parentData()
        brick = Template.parentData(4)
        context = Template.parentData(5)
        
        if brick
            Docs.update context._id,
            $set:"#{brick.key}":val
        else 
            Docs.update parent._id,
                $set:"#{@key}":val


Template.boolean_edit.helpers
    boolean_toggle_class: ->
        parent = Template.parentData()
        brick = Template.parentData(4)
        context = Template.parentData(5)

        if brick
            if context["#{brick.key}"] then 'blue' else ''
        else
            if parent["#{@key}"] then 'blue' else ''


Template.boolean_edit.events
    'click .toggle_boolean': (e,t)->
        parent = Template.parentData()
        # if parent["#{@key}"] then parent["#{@key}"]
        
        # console.log @
        
        brick = Template.parentData(4)
        context = Template.parentData(5)
        
        # console.log !context["#{brick.key}"]
        # console.log brick
        # console.log context
        
        if brick
            Docs.update context._id,
                $set:"#{brick.key}":!context["#{brick.key}"]
        else 
            Docs.update parent._id,
                $set:"#{@key}":!parent["#{@key}"] 
        
        





Template.number_edit.events
    'blur .edit_number': (e,t)->
        parent = Template.parentData()
        val = t.$('.edit_number').val()
        
        brick = Template.parentData(4)
        context = Template.parentData(5)
        
        if brick
            Docs.update context._id,
                $set:"#{brick.key}":val
        else 
            Docs.update parent._id,
                $set:"#{@key}":val
        
        



Template.date_edit.events
    'blur .edit_date': (e,t)->
        parent = Template.parentData()
        val = t.$('.edit_date').val()
        brick = Template.parentData(4)
        context = Template.parentData(5)
        
        if brick
            Docs.update context._id,
                $set:"#{brick.key}":val
        else 
            Docs.update parent._id,
                $set:"#{@key}":val



        



Template.time_edit.events
    'blur .edit_time': (e,t)->
        parent = Template.parentData()
        val = t.$('.edit_time').val()
        brick = Template.parentData(4)
        context = Template.parentData(5)
        
        if brick
            Docs.update context._id,
                $set:"#{brick.key}":val
        else 
            Docs.update parent._id,
                $set:"#{@key}":val



Template.youtube_edit.events
    'blur .youtube_id': (e,t)->
        parent = Template.parentData()
        val = t.$('.youtube_id').val()
        
        brick = Template.parentData(4)
        context = Template.parentData(5)
        
        if brick
            Docs.update context._id,
                $set:"#{brick.key}":val
        else 
            Docs.update parent._id,
                $set:"#{@key}":val

        
Template.children_edit.onCreated ->
    # @autorun => Meteor.subscribe 'children', @data.ref_schema, Template.parentData(5)._id
    @autorun => Meteor.subscribe 'child_docs', Template.parentData(5)._id
    @autorun => Meteor.subscribe 'schema_from_slug', Router.current().params.tribe_slug, @data.ref_schema
    @autorun => Meteor.subscribe 'schema_bricks_from_slug', Router.current().params.tribe_slug, @data.ref_schema

Template.children_edit.onRendered ->
    Meteor.setTimeout ->
        $('.accordion').accordion()
    , 1000

Template.children_edit.helpers
    children: ->
        field = @
        # if Template.parentData(5)
        parent = Template.parentData(5)
        # else
        #     parent = Template.parentData()
        Docs.find {
            type: @ref_schema
            parent_id: parent._id
        }, sort:rank:1
        
        
Template.children_edit.events
    'click .add_child': ->
        # console.log @
        parent = Template.parentData(5)
        # field = @
        Docs.insert
            type: @ref_schema
            parent_id: parent._id




Template.single_doc_view.onCreated ->
    # @autorun => Meteor.subscribe 'type', @data.ref_schema

Template.single_doc_view.helpers
    choices: -> 
        console.log @ref_schema
        Docs.find 
            type:@ref_schema




Template.single_doc_edit.onCreated ->
    @autorun => Meteor.subscribe 'type', @data.ref_schema

Template.single_doc_edit.helpers
    choices: -> 
        # console.log @ref_schema
        if @ref_schema
            if @ref_schema in ['field','tribe']
                Docs.find 
                    type:@ref_schema
                    # tribe:Router.current().params.tribe_slug
            else
                Docs.find 
                    type:@ref_schema
                    tribe:Router.current().params.tribe_slug
            
    choice_class: ->
        selection = @
        ref_field = Template.parentData()
        target = Template.parentData(2)

        brick = Template.parentData(5)
        context = Template.parentData(6)


        if brick
            if @slug is context["#{brick.key}"] then 'blue' else ''
        else
            if @slug is target["#{ref_field.key}"] then 'blue' else ''


Template.single_doc_edit.events
    'click .select_choice': ->
        selection = @
        ref_field = Template.currentData()
        target = Template.parentData(1)

        brick = Template.parentData(4)
        context = Template.parentData(5)
        # console.log @["#{ref_field.ref_key}"]
        # Docs.update target._id,
        #     $set: "#{ref_field.key}": @slug
       
        # if brick 
        if context["#{brick.key}"] and @slug is context["#{ref_field.key}"]
            Docs.update context._id,
                $unset: "#{brick.key}": 1
        else
            Docs.update context._id,
                $set: "#{brick.key}": @slug
        # else
        #     Docs.update target._id,
        #         $set: "#{ref_field.key}": @slug


Template.multi_doc_view.onCreated ->
    # @autorun => Meteor.subscribe 'type', @data.ref_schema

Template.multi_doc_view.helpers
    choices: -> 
        console.log @ref_schema
        Docs.find 
            type:@ref_schema


Template.multi_doc_edit.onCreated ->
    @autorun => Meteor.subscribe 'type', @data.ref_schema

Template.multi_doc_edit.helpers
    choices: -> 
        # console.log @ref_schema
        Docs.find type:@ref_schema
    choice_class: ->
        selection = @
        ref_field = Template.parentData()
        target = Template.parentData(2)
        brick = Template.parentData(5)
        context = Template.parentData(6)

        if brick
            if context["#{brick.key}"] and @slug in context["#{brick.key}"] then 'blue' else ''
        else
            if target["#{ref_field.key}"] and @slug in target["#{ref_field.key}"] then 'blue' else ''

Template.multi_doc_edit.events
    'click .select_choice': ->
        selection = @
        ref_field = Template.currentData()
        target = Template.parentData(1)

        brick = Template.parentData(4)
        context = Template.parentData(5)

        # console.log @["#{ref_field.ref_key}"]
        
        if brick 
            if context["#{brick.key}"] and @slug in context["#{ref_field.key}"]
                Docs.update context._id,
                    $pull: "#{brick.key}": @slug
            else
                Docs.update context._id,
                    $addToSet: "#{brick.key}": @slug
    
        else
            if target["#{ref_field.key}"] and @slug in target["#{ref_field.key}"]
                Docs.update target._id,
                    $pull: "#{ref_field.key}": @slug
            else
                Docs.update target._id,
                    $addToSet: "#{ref_field.key}": @slug






Template.code_edit.onRendered ->
    ace.require("ace/ext/language_tools")

    editor = ace.edit('ace')
    editor.session.setMode("ace/mode/html")
    editor.setTheme("ace/theme/twilight")
    editor.setOptions({
        enableBasicAutocompletion: true,
        enableSnippets: true,
        enableLiveAutocompletion: false
    })
    
    
Template.single_user_edit.onCreated ->
    @user_results = new ReactiveVar

Template.single_user_edit.helpers
    user_results: ->
        user_results = Template.instance().user_results.get()
        user_results
    
    
    
Template.single_user_edit.events
    'click .clear_results': (e,t)->
        t.user_results.set null

    'keyup #single_user_select_input': (e,t)->
        search_value = $(e.currentTarget).closest('#single_user_select_input').val().trim()
        Meteor.call 'lookup_user', search_value, (err,res)=>
            if err then console.error err
            else
                t.user_results.set res


    'click .select_user': (e,t) ->
        page_doc = Docs.findOne Router.current().params.id
        
        # console.log @
        
        val = t.$('.edit_text').val()
        parent = Template.parentData()
        brick = Template.parentData(4)
        context = Template.parentData(5)
        
        # console.log Template.parentData()
        # console.log Template.parentData(1)
        # console.log Template.parentData(2)
        # console.log Template.parentData(3)
        console.log Template.parentData(4)
        console.log Template.parentData(5)
        
        if brick
            Docs.update context._id,
                $set:"#{brick.key}":@_id
        # else 
        #     Docs.update parent._id,
        #         $set:"#{@key}":val

        t.user_results.set null
        $('#single_user_select_input').val ''
        # Docs.update page_doc._id,
        #     $set: assignment_timestamp:Date.now()







    'click .pull_user': ->
        context = Template.currentData(0)
        if confirm "Remove #{@username}?"
            page_doc = Docs.findOne Router.current().params.id
            Meteor.call 'unassign_user', page_doc._id, @







Template.multi_user_edit.onCreated ->
    @user_results = new ReactiveVar

Template.multi_user_edit.helpers
    user_results: ->
        user_results = Template.instance().user_results.get()
        user_results
    
    
    
Template.multi_user_edit.events
    'click .clear_results': (e,t)->
        t.user_results.set null

    'keyup #multi_user_select_input': (e,t)->
        search_value = $(e.currentTarget).closest('#multi_user_select_input').val().trim()
        Meteor.call 'lookup_user', search_value, (err,res)=>
            if err then console.error err
            else
                t.user_results.set res


    'click .select_user': (e,t) ->
        page_doc = Docs.findOne Router.current().params.id
        
        # console.log @
        
        val = t.$('.edit_text').val()
        parent = Template.parentData()
        brick = Template.parentData(4)
        context = Template.parentData(5)
        
        # console.log Template.parentData()
        # console.log Template.parentData(1)
        # console.log Template.parentData(2)
        # console.log Template.parentData(3)
        console.log Template.parentData(4)
        console.log Template.parentData(5)
        
        if brick
            Docs.update context._id,
                $addToSet:"#{brick.key}":@_id
        # else 
        #     Docs.update parent._id,
        #         $set:"#{@key}":val

        t.user_results.set null
        $('#multi_user_select_input').val ''
        # Docs.update page_doc._id,
        #     $set: assignment_timestamp:Date.now()



    'click .pull_user': ->
        context = Template.currentData(0)
        if confirm "Remove #{@username}?"
            page_doc = Docs.findOne Router.current().params.id
            parent = Template.parentData()
            brick = Template.parentData(4)
            context = Template.parentData(5)

            
            if brick
                Docs.update context._id,
                    $pull:"#{brick.key}":@_id

            
            
            # Meteor.call 'unassign_user', page_doc._id, @

