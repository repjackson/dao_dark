Template.doc_edit.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'templates'

Template.doc_edit.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            Meteor.setTimeout ->
                $('.ui.accordion').accordion()
            , 1000
        

Template.doc_edit.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
#     edit_type_template: -> 
#         if @template then "#{@template}_edit" else 'post_edit'
#     # templates: -> Docs.find type:'template'

#     field_doc: -> Docs.findOne Template.parentData(1)
    


# Template.doc_edit.events
#     'click #delete': ->
#         if confirm 'delete?'
#             Docs.remove @_id
#         FlowRouter.go '/'
            
#     'blur #youtube': ->
#         youtube = $('#youtube').val()
#         # console.log content
#         Docs.update @_id,
#             $set: youtube: youtube
   
#     'blur #image_url': ->
#         image_url = $('#image_url').val()
#         # console.log content
#         Docs.update @_id,
#             $set: image_url: image_url
   
#     'click #clear_youtube': (e,t)->
#         # $(e.currentTarget).closest('#youtube').val('')
#         # console.log @
#         Docs.update @_id,
#             $unset: youtube: 1
#     'click #clear_image_url': (e,t)->
#         # $(e.currentTarget).closest('#youtube').val('')
#         # console.log @
#         Docs.update @_id,
#             $unset: image_url: 1




#     'click #save_doc': ->
#         # console.log @tags.length
#         Docs.update @_id, 
#             $set: tag_count: @tags.length
#         selected_tags.clear()
#         for tag in @tags
#             selected_tags.push tag
            
