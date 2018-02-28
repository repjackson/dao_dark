FlowRouter.route '/v/:doc_id', 
    name: 'view'
    action: (params) ->
        if selected_theme_tags
            selected_theme_tags.clear()
        BlazeLayout.render 'layout',
            # nav: 'nav'
            main: 'view_doc'


Template.view_doc.onCreated ->
    @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'delta', FlowRouter.getParam('doc_id')
    
    # @autorun -> Meteor.subscribe 'ancestor_ids', FlowRouter.getParam('doc_id')
    # @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')
    # @autorun => Meteor.subscribe 'facet', 
    #     selected_theme_tags.array()
    #     selected_ancestor_ids.array()
    #     selected_author_ids.array()
    #     selected_location_tags.array()
    #     selected_intention_tags.array()
    #     selected_timestamp_tags.array()
    #     type = null
    #     author_id = null
    #     parent_id = FlowRouter.getParam('doc_id')
    #     tag_limit = null
    #     doc_limit = 10
    #     view_private = Session.get 'view_private'
    
Template.view_doc.onRendered ->
    @autorun =>
        if @subscriptionsReady()
            doc = Docs.findOne FlowRouter.getParam('doc_id')
            Meteor.setTimeout ->
                if doc
                    if doc.title
                        document.title = doc.title
            , 500
    

Template.view_doc.helpers
    doc: -> Docs.findOne FlowRouter.getParam('doc_id')
    view_template: -> "view_#{@template}"
    is_site: ->
        doc = Docs.findOne FlowRouter.getParam('doc_id')
        if doc.type is 'site' then true else false
        
        

        
        
        