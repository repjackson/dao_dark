import { FlowRouter } from 'meteor/ostrio:flow-router-extra'
import Quill from 'quill'


Template.link_edit.events
    'blur .edit_link': (e,t)->
        link_val = t.$('.edit_link').val()
        parent = Template.parentData(5)
        Docs.update parent._id,
            $set:"#{@valueOf()}":link_val

Template.image_link_edit.events
    'blur .edit_image_link': (e,t)->
        image_link_val = t.$('.edit_image_link').val()
        parent = Template.parentData(5)
        Docs.update parent._id,
            $set:"#{@valueOf()}":image_link_val


Template.html_edit.onRendered ->
    toolbarOptions = [
        ['bold', 'italic', 'underline', 'strike']
        ['blockquote', 'code-block']

        [{ 'header': 1 }, { 'header': 2 }]
        [{ 'list': 'ordered'}, { 'list': 'bullet' }]
        [{ 'script': 'sub'}, { 'script': 'super' }]
        [{ 'indent': '-1'}, { 'indent': '+1' }]
        [{ 'direction': 'rtl' }]

        [{ 'size': ['small', false, 'large', 'huge'] }]
        [{ 'header': [1, 2, 3, 4, 5, 6, false] }]

        [{ 'color': [] }, { 'background': [] }]
        [{ 'font': [] }]
        [{ 'align': [] }]

        ['clean']
    ]

    options =
        # debug: 'info'
        modules:
            toolbar: toolbarOptions
        placeholder: '...'
        readOnly: false
        theme: 'snow'

    @editor = new Quill('.editor', options)

    doc = Docs.findOne FlowRouter.getParam('id')

    @editor.clipboard.dangerouslyPasteHTML(doc.html)

Template.html_edit.events
    'blur .editor': (e,t)->
        # console.log @
        # console.log t.editor
        delta = t.editor.getContents();
        html = t.editor.root.innerHTML
        parent = Template.parentData(5)
        Docs.update parent._id,
            $set:
                "#{@valueOf()}": html
                "_#{@valueOf()}.delta_ob": delta



Template.array_edit.events
    'keyup .new_element': (e,t)->
        if e.which is 13
            # console.log @valueOf()
            element_val = t.$('.new_element').val().trim().toLowerCase()
            parent = Template.parentData(5)
            # # console.log element_val
            Docs.update parent._id,
                $addToSet:"#{@valueOf()}":element_val
            t.$('.new_element').val('')

    'click .remove_element': (e,t)->
        element = @valueOf()
        field = Template.currentData()
        field = Template.currentData()
        parent = Template.parentData(5)

        Docs.update parent._id,
            $pull:"#{field}":element

        t.$('.new_element').focus()
        t.$('.new_element').val(element)


Template.textarea_edit.events
    'blur .edit_textarea': (e,t)->
        textarea_val = t.$('.edit_textarea').val()
        parent = Template.parentData(5)
        Docs.update parent._id,
            $set:"#{@valueOf()}":textarea_val



Template.text_edit.events
    'blur .edit_text': (e,t)->
        parent = Template.parentData(5)
        val = t.$('.edit_text').val()
        Docs.update parent._id,
            $set:"#{@valueOf()}":val



Template.number_edit.events
    'blur .edit_number': (e,t)->
        parent = Template.parentData(5)
        val = parseInt t.$('.edit_number').val()
        Docs.update parent._id,
            $set:"#{@valueOf()}":val



Template.date_edit.events
    'blur .edit_date': (e,t)->
        parent = Template.parentData(5)
        val = t.$('.edit_date').val()
        Docs.update parent._id,
            $set:"#{@valueOf()}":val



Template.youtube_edit.events
    'blur .youtube_id': (e,t)->
        parent = Template.parentData(5)
        val = t.$('.youtube_id').val()
        Docs.update parent._id,
            $set:"_#{@valueOf()}.youtube_id":val


Template.children_edit.onCreated ->
    @autorun => Meteor.subscribe 'children', @data.type, Template.parentData()


Template.children_edit.helpers
    children: ->
        field = @
        parent = Template.parentData(5)
        Docs.find
            type: @type
            parent_id: parent._id

Template.children_edit.events
    'click .add_child': ->
        field = @
        parent = Template.parentData(5)
        Docs.insert
            type: @type
            parent_id: parent._id

Template.ref_edit.onCreated ->
    @autorun => Meteor.subscribe 'ref_choices', @data.type

Template.ref_edit.helpers
    choices: -> Docs.find type:@type
    choice_class: ->


Template.ref_edit.events
    'click .select_choice': ->
        selection = @
        ref_field = Template.currentData()
        target = Template.parentData()

        console.log target

        if ref_field.multi
            Docs.update target._id,
                $addToSet: "#{ref_field.key}": @_id
        else
            Docs.update target._id,
                $set: "#{ref_field.key}": @_id





Template.code_edit.onRendered ->
    ace.require("ace/ext/language_tools");

    editor = ace.edit('ace')
    editor.session.setMode("ace/mode/html");
    editor.setTheme("ace/theme/twilight");
    editor.setOptions({
        enableBasicAutocompletion: true,
        enableSnippets: true,
        enableLiveAutocompletion: false
    });