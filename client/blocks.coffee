FlowRouter.route '/blocks', 
    action: (params) ->
        BlazeLayout.render 'layout',
            main: 'blocks'


FlowRouter.route '/block/:hash', 
    action: (params) ->
        BlazeLayout.render 'layout',
            # nav: 'nav'
            main: 'block_page'




    
Template.blocks.onRendered ->
    @autorun => Meteor.subscribe 'blocks'
    

Template.latest_block.helpers
    latest_block: -> Docs.findOne type:'block'
        



Template.block_page.onCreated ->
    @autorun => Meteor.subscribe 'block', FlowRouter.getParam('hash')
    

Template.block_page.helpers
    block: -> Docs.findOne type:'block'
        
        
        
        
Template.block_browser.onCreated ->
    @autorun => Meteor.subscribe 'blocks'
    

Template.block_browser.helpers
    blocks: -> Docs.find type:'block'
        
        
        
        
        
        
        
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


Template.latest_block.events
    'click #fetch_latest_block': ->
        Meteor.call 'fetch_latest_block'
        # console.log request


Template.block_page.events
    'click #refresh_block': ->
        Meteor.call 'get_block_details', FlowRouter.getParam 'hash'
        # console.log request




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
