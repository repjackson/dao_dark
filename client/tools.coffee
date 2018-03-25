FlowRouter.route '/tools', 
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'tools'

FlowRouter.route '/miner_calc', 
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'miner_calc'

FlowRouter.route '/miners', 
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'miners'


    

    
Template.miners.onRendered ->
    @autorun => Meteor.subscribe 'miners'
    

# Template.view_doc.helpers
#     doc: -> Docs.findOne FlowRouter.getParam('doc_id')
#     view_template: -> "view_#{@template}"
#     # is_site: ->
#     #     doc = Docs.findOne FlowRouter.getParam('doc_id')
#     #     if doc.type is 'site' then true else false
        
        
# Template.view_doc.onCreated ->
#     @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
#     @autorun -> Meteor.subscribe 'parent_doc', FlowRouter.getParam('doc_id')
#     # @autorun -> Meteor.subscribe 'delta', FlowRouter.getParam('doc_id')
    
#     # @autorun -> Meteor.subscribe 'ancestor_ids', FlowRouter.getParam('doc_id')
#     # @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
#     # @autorun => Meteor.subscribe 'facet', 


# # Template.view_doc.helpers
# #     doc: -> Docs.findOne FlowRouter.getParam('doc_id')


# Template.doc_card.onCreated ->
#     @autorun => Meteor.subscribe 'parent_doc', @data._id

# Template.doc_card.helpers
#     tag_class: -> if @valueOf() in selected_tags.array() then 'grey' else ''


# Template.doc_card.events
#     'click #edit_this': ->
#         Session.set 'editing_id', @_id

#     'click .doc_tag': ->
#         if @valueOf() in selected_tags.array() then selected_tags.remove @valueOf() else selected_tags.push @valueOf()




# Template.view_youtube.onRendered ->
#     Meteor.setTimeout (->
#         $('.ui.embed').embed()
#     ), 1000

        
        
            
            
# # Template.your_tags.helpers
# #     'keyup #add_your_tag': (e,t)->
# #         if e.which is 13
# #             doc_id = FlowRouter.getParam('doc_id')
# #             add_your_tag = $('#add_your_tag').val().toLowerCase().trim()
# #             if add_your_tag.length > 0
# #                 Docs.update doc_id,
# #                     $set: add_your_tag: image_id
# #                 $('#add_your_tag').val('')
