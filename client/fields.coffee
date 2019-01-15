import Quill from 'quill'
import { FlowRouter } from 'meteor/ostrio:flow-router-extra'



Template.url_edit.events
    'blur .edit_url': (e,t)->
        url_val = t.$('.edit_url').val()
        parent = Template.parentData(5)
        Docs.update parent._id, 
            $set:"#{@valueOf()}":url_val
  
  
 
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

    doc = Docs.findOne FlowRouter.getParam('doc_id')

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
            element_val = t.$('.new_element').val().trim()
            parent = Template.parentData(5)
            # console.log element_val
            Docs.update parent._id, 
                $addToSet:"#{@valueOf()}":element_val
            t.$('.new_element').val('')
        
    'click .remove_element': (e,t)->
        element = @valueOf()
        field_key = Template.parentData(4)
        parent = Template.parentData(5)
        Docs.update parent._id, 
            $pull:"#{field_key}":element
        
            
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
        val = t.$('.edit_number').val()
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
    @autorun => Meteor.subscribe 'ref_choices', @data.schema

Template.ref_edit.helpers
    choices: -> Docs.find type:@schema
    choice_class: -> 
        
            
Template.ref_edit.events
    'click .select_choice': ->
        selection = @
        ref_field = Template.currentData()
        target = Template.parentData(1)

        console.log ref_field
        
        if ref_field.ref_type is 'single'
            Docs.update target._id,
                $set: "#{ref_field.key}": @_id
        else if ref_field.ref_type is 'multi'
            Docs.update target._id,
                $addToSet: "#{ref_field.key}": @_id
            
            
            
            

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