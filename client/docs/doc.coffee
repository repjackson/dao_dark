FlowRouter.route '/view/:doc_id', 
    name: 'view'
    action: (params) ->
        # if selected_theme_tags
        #     selected_theme_tags.clear()
        BlazeLayout.render 'layout',
            # nav: 'nav'
            main: 'view_doc'


Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    @autorun -> Meteor.subscribe 'parent_doc', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'delta', FlowRouter.getParam('doc_id')
    
    # @autorun -> Meteor.subscribe 'ancestor_ids', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    # @autorun => Meteor.subscribe 'facet', 


Template.view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')



Template.doc_card.helpers
    tag_class: -> if @valueOf() in selected_tags.array() then 'grey' else ''


Template.doc_card.events
    'click #edit_this': ->
        Session.set 'editing_id', @_id

    'click .doc_tag': ->
        if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()



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

Template.view_youtube.onRendered ->
    Meteor.setTimeout (->
        $('.ui.embed').embed()
    ), 1000

        
        
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
            
            
Template.vote_button.helpers
    vote_up_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @upvoters and Meteor.userId() in @upvoters then 'green'
        else 'outline'

    vote_down_button_class: ->
        if not Meteor.userId() then 'disabled'
        else if @downvoters and Meteor.userId() in @downvoters then 'red'
        else 'outline'

Template.vote_button.events
    'click .vote_up': (e,t)-> 
        if Meteor.userId()
            Meteor.call 'vote_up', @_id
        else FlowRouter.go '/sign-in'

    'click .vote_down': -> 
        if Meteor.userId() then Meteor.call 'vote_down', @_id
        else FlowRouter.go '/sign-in'
            
            
            
