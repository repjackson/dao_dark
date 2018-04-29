
Template.doc_view.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            doc = Docs.findOne @doc_id
            Meteor.setTimeout ->
                if doc
                    if doc.title
                        document.title = doc.title
            , 500
    
    Meteor.setTimeout ->
        $('.ui.accordion').accordion()
    , 1000



Template.doc_view.helpers
    doc: -> Docs.findOne {}
    view_template: -> 
        if @template then "#{@template}_view" else 'post_view'
    # is_site: ->
    #     doc = Docs.findOne @doc_id
    #     if doc.type is 'site' then true else false
        
        
Template.doc_view.onCreated ->
    @autorun -> Meteor.subscribe 'doc', @doc_id
    @autorun -> Meteor.subscribe 'parent_doc', @doc_id
    # @autorun -> Meteor.subscribe 'delta', @doc_id
    
    # @autorun -> Meteor.subscribe 'ancestor_ids', @doc_id
    # @autorun -> Meteor.subscribe 'child_docs', @doc_id
    # @autorun => Meteor.subscribe 'facet', 


# Template.doc_view.helpers
#     doc: -> Docs.findOne @doc_id


Template.doc_card.onCreated ->
    @autorun => Meteor.subscribe 'parent_doc', @data._id

Template.doc_card.helpers
    tag_class: -> if @valueOf() in selected_tags.array() then 'grey' else ''


Template.doc_card.events
    'click #edit_this': ->
        Session.set 'editing_id', @_id

    'click .doc_tag': ->
        if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()




Template.view_youtube.onRendered ->
    Meteor.setTimeout (->
        $('.ui.embed').embed()
    ), 1000

        
        
            
            
# Template.your_tags.helpers
#     'keyup #add_your_tag': (e,t)->
#         if e.which is 13
#             doc_id = @doc_id
#             add_your_tag = $('#add_your_tag').val().toLowerCase().trim()
#             if add_your_tag.length > 0
#                 Docs.update doc_id,
#                     $set: add_your_tag: image_id
#                 $('#add_your_tag').val('')
