@selected_tags = new ReactiveArray []


Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id


Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'

Meteor.startup ->
    Status.setTemplate('semantic_ui')

Template.tags.helpers
    tags: ->
        doc_count = Docs.find({}).count()
        # if selected_tags.array().length
        if 0 < doc_count < 3
            Tags.find { 
                # type:Template.currentData().type
                count: $lt: doc_count
                }, limit: 42
        else
            Tags.find({})
            
            
    
    tag_class: ->
        doc_count = Docs.find({}).count()
        # if selected_tags.array().length
        # if doc_count < 3
        #     if @count is 1 then 'disabled'
        # if doc_count is 1 then 'disabled' else ''
        if doc_count is 1
            'disabled'
        else
            button_class = []
            switch
                when @index <= 10 then button_class.push 'large'
                when @index <= 30 then button_class.push ''
                when @index <= 50 then button_class.push 'small'
                when @index <= 80 then button_class.push 'small '
                when @index <= 100 then button_class.push 'tiny'
            return button_class
        

    selected_tags: -> selected_tags.array()

Template.tags.events
    'click .select_tag': -> selected_tags.push @name
    'click .unselect_tag': -> selected_tags.remove @valueOf()
    'click #clear_tags': -> selected_tags.clear()

    'keyup #search': (e,t)->
        e.preventDefault()
        val = $('#search').val().toLowerCase().trim()
        switch e.which
            when 13 #enter
                switch val
                    when 'clear'
                        selected_tags.clear()
                        $('#search').val ''
                    else
                        unless val.length is 0
                            selected_tags.push val.toString()
                            $('#search').val ''
            when 8
                if val.length is 0
                    selected_tags.pop()
                    
Template.home.onCreated ->
    @autorun => 
        Meteor.subscribe('facet', 
            selected_tags.array()
            )
        Meteor.subscribe 'doc', Session.get('editing_id')

Template.home.helpers
    one_doc: ->
        Docs.find().count() is 1

    docs: -> 
        if Session.get 'editing_id'
            Docs.find Session.get('editing_id')
        else
            Docs.find({},{limit:1,sort:tag_count:1})

    editing_this: -> Session.equals 'editing_id', @_id

    is_editing: -> Session.get 'editing_id'

Template.view_doc.helpers
    tag_class: -> if @valueOf() in selected_tags.array() then 'grey' else ''


Template.view_doc.events
    'click #edit_this': ->
        Session.set 'editing_id', @_id

    'click .doc_tag': ->
        if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()


Template.home.events
    'click #add_doc': ->
        new_id = Docs.insert
            timestamp: Date.now()
            author_id: Meteor.userId()
        Session.set 'editing_id', new_id
        
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
            height: 500
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
    ), 500

        
        
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