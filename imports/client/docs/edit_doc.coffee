FlowRouter.route '/edit/:doc_id', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'edit_doc'

Template.edit_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'templates'

Template.edit_doc.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
        

Template.edit_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    edit_type_template: -> "edit_#{@template}"
    templates: -> Docs.find type:'template'

    field_doc: -> Docs.findOne Template.parentData(1)
    
    
    field_doc: -> 
        Docs.findOne Template.parentData(0)


Template.edit_doc.events
    # 'change #toggle_title': (e,t)->
    #     # console.log e.currentTarget.value
    #     value = $('#toggle_title').is(":checked")
    #     Docs.update FlowRouter.getParam('doc_id'), 
    #         $set:
    #             has_title: value
                
    # 'change #toggle_subtitle': (e,t)->
    #     # console.log e.currentTarget.value
    #     value = $('#toggle_subtitle').is(":checked")
    #     Docs.update FlowRouter.getParam('doc_id'), 
    #         $set:
    #             has_subtitle: value
                
    # 'change #toggle_image': (e,t)->
    #     # console.log e.currentTarget.value
    #     value = $('#toggle_image').is(":checked")
    #     Docs.update FlowRouter.getParam('doc_id'), 
    #         $set:
    #             has_image: value
    
    # 'change #toggle_youtube': (e,t)->
    #     # console.log e.currentTarget.value
    #     value = $('#toggle_youtube').is(":checked")
    #     Docs.update FlowRouter.getParam('doc_id'), 
    #         $set:
    #             has_youtube: value
    
    # 'change #toggle_content': (e,t)->
    #     # console.log e.currentTarget.value
    #     value = $('#toggle_content').is(":checked")
    #     Docs.update FlowRouter.getParam('doc_id'), 
    #         $set:
    #             has_content: value
                
    # 'change #toggle_slug': (e,t)->
    #     # console.log e.currentTarget.value
    #     value = $('#toggle_slug').is(":checked")
    #     Docs.update FlowRouter.getParam('doc_id'), 
    #         $set:
    #             has_slug: value
                
    # 'change #toggle_number': (e,t)->
    #     # console.log e.currentTarget.value
    #     value = $('#toggle_number').is(":checked")
    #     Docs.update FlowRouter.getParam('doc_id'), 
    #         $set:
    #             has_number: value
                
    # 'change #toggle_price': (e,t)->
    #     # console.log e.currentTarget.value
    #     value = $('#toggle_price').is(":checked")
    #     Docs.update FlowRouter.getParam('doc_id'), 
    #         $set:
    #             has_price: value


Template.edit_doc.events
    'click #delete': ->
        if confirm 'delete?'
            Docs.remove @_id
        Session.set 'editing_id', null
            
    'blur #youtube': ->
        youtube = $('#youtube').val()
        # console.log content
        Docs.update @_id,
            $set: youtube: youtube
   
    'blur #image_url': ->
        image_url = $('#image_url').val()
        # console.log content
        Docs.update @_id,
            $set: image_url: image_url
   
    'click #clear_youtube': (e,t)->
        # $(e.currentTarget).closest('#youtube').val('')
        # console.log @
        Docs.update @_id,
            $unset: youtube: 1
    'click #clear_image_url': (e,t)->
        # $(e.currentTarget).closest('#youtube').val('')
        # console.log @
        Docs.update @_id,
            $unset: image_url: 1

    'keyup #add_tag': (e,t)->
        e.preventDefault()
        val = $('#add_tag').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                unless val.length is 0
                    Docs.update @_id,
                        $addToSet: tags: val
                    $('#add_tag').val ''


    'click .doc_tag': (e,t)->
        tag = @valueOf()
        Docs.update Template.currentData()._id,
            $pull: tags: tag
        $('#add_tag').val(tag)

    'blur .froala-container': (e,t)->
        html = t.$('div.froala-reactive-meteorized-override').froalaEditor('html.get', true)
        
        # doc_id = FlowRouter.getParam('doc_id')

        Docs.update @_id,
            $set: content: html




    'click #save_doc': ->
        # console.log @tags.length
        Docs.update @_id, 
            $set: tag_count: @tags.length
            
        Session.set 'editing_id', null      
        selected_tags.clear()
        for tag in @tags
            selected_tags.push tag
            


Template.edit_doc.helpers
    getFEContext: ->
        @current_doc = Docs.findOne @_id
        self = @
        {
            _value: self.current_doc.content
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
                  'insertImage'
                  'insertVideo'
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
            toolbarButtonsMD: ['bold', 'italic', 'underline','insertVideo','html']
            toolbarButtonsSM: ['bold', 'italic', 'underline','insertVideo','html']
            toolbarButtonsXS: ['bold', 'italic', 'underline','insertVideo','html']
            imageInsertButtons: ['imageBack', '|', 'imageByURL']
            tabSpaces: false
            height: 300
            codeMirrorOptions:
                indentWithTabs: false,
                lineNumbers: true,
                lineWrapping: true,
                mode: 'text/html',
                tabMode: 'indent',
                tabSize: 4

            
        }
