    
Template.transactions.onRendered ->
    @autorun => Meteor.subscribe 'type', 'transaction'
    




Template.transaction_page.onCreated ->
    @autorun => Meteor.subscribe 'transaction', @hash
    

Template.transaction_page.helpers
    transaction: -> Docs.findOne type:'transaction'
        
        
        
        
Template.transaction_browser.onCreated ->
    @autorun => Meteor.subscribe 'type', 'transaction'
    

Template.transaction_browser.helpers
    transactions: -> Docs.find type:'transaction'
        
        
        
        
        
        
        
# Template.view_doc.onCreated ->
#     @autorun -> Meteor.subscribe 'doc', @doc_id
#     @autorun -> Meteor.subscribe 'parent_doc', @doc_id
#     # @autorun -> Meteor.subscribe 'delta', @doc_id
    
#     # @autorun -> Meteor.subscribe 'ancestor_ids', @doc_id
#     # @autorun -> Meteor.subscribe 'child_docs', @doc_id
#     # @autorun => Meteor.subscribe 'facet', 


# # Template.view_doc.helpers
# #     doc: -> Docs.findOne @doc_id


# Template.doc_card.onCreated ->
#     @autorun => Meteor.subscribe 'parent_doc', @data._id

# Template.doc_card.helpers
#     tag_class: -> if @valueOf() in selected_tags.array() then 'grey' else ''



Template.transaction_page.events
    'click #refresh_transaction': ->
        Meteor.call 'get_transaction_details', FlowRouter.getParam 'hash'
        # console.log request




# Template.view_youtube.onRendered ->
#     Meteor.setTimeout (->
#         $('.ui.embed').embed()
#     ), 1000

        
        
            
            
# # Template.your_tags.helpers
# #     'keyup #add_your_tag': (e,t)->
# #         if e.which is 13
# #             doc_id = @doc_id
# #             add_your_tag = $('#add_your_tag').val().toLowerCase().trim()
# #             if add_your_tag.length > 0
# #                 Docs.update doc_id,
# #                     $set: add_your_tag: image_id
# #                 $('#add_your_tag').val('')
