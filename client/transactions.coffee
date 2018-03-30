FlowRouter.route '/transactions', 
    action: (params) ->
        BlazeLayout.reset()        
        BlazeLayout.render 'layout',
            main: 'transactions'


FlowRouter.route '/transaction/:hash', 
    action: (params) ->
        BlazeLayout.reset()        
        BlazeLayout.render 'layout',
            main: 'transaction_page'




    
Template.transactions.onRendered ->
    @autorun => Meteor.subscribe 'type', 'transaction'
    

Template.latest_transaction.helpers
    latest_transaction: -> Docs.findOne type:'transaction'
        



Template.transaction_page.onCreated ->
    @autorun => Meteor.subscribe 'transaction', FlowRouter.getParam('hash')
    

Template.transaction_page.helpers
    transaction: -> Docs.findOne type:'transaction'
        
        
        
        
Template.transaction_browser.onCreated ->
    @autorun => Meteor.subscribe 'type', 'transaction'
    

Template.transaction_browser.helpers
    transactions: -> Docs.find type:'transaction'
        
        
        
        
        
        
        
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


Template.latest_transaction.events
    'click #fetch_latest_transaction': ->
        Meteor.call 'fetch_latest_transaction'
        # console.log request


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
# #             doc_id = FlowRouter.getParam('doc_id')
# #             add_your_tag = $('#add_your_tag').val().toLowerCase().trim()
# #             if add_your_tag.length > 0
# #                 Docs.update doc_id,
# #                     $set: add_your_tag: image_id
# #                 $('#add_your_tag').val('')
