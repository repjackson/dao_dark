FlowRouter.route '/reddit', action: (params) ->
    BlazeLayout.render 'layout',
        nav: 'nav'
        main: 'reddit'


Template.view_toggle.events
    'click .toggle_view': ->
        Session.set 'view_mode', @name
        # console.log @name
Template.view_toggle_item.events
    'click .toggle_view': ->
        Session.set 'view_mode', @name
        # console.log @name


Template.reddit.onCreated ->
    # @autorun => 
    #     Meteor.subscribe('facet', 
    #     selected_tags.array()
    #     selected_keywords.array()
    #     selected_author_ids.array()
    #     selected_location_tags.array()
    #     selected_timestamp_tags.array()
    #     type='reddit'
    #     author_id=null
    #     )
    #     # Meteor.subscribe 'doc', Session.get('editing_id')

Template.reddit.events
    'click #add': -> 
        id = Docs.insert {}
        FlowRouter.go "/edit/#{id}"
    # 'click #save': -> Session.set 'editing_id', null
    # 'click .edit': -> Session.set 'editing_id', @_id
Template.reddit.helpers
    one_doc: -> Docs.find().count() is 1
    view_mode: -> Session.get 'view_mode'
    viewing_table: -> Session.equals 'view_mode','table'
    # editing_id: -> Session.get 'editing_id'
    docs: -> Docs.find({},{limit:10,sort:tag_count:1})

Template.reddit_view.onRendered ->
    # Meteor.setTimeout ->
    #     $('.ui.checkbox').checkbox()
    # #     $('.ui.tabular.menu .item').tab()
    # , 400
    Meteor.setTimeout ->
        $('.ui.tabular.menu .item').tab()
    , 500



Template.reddit_view.events
    'click #get_reddit_post': ->
        Meteor.call 'get_reddit_post', FlowRouter.getParam('doc_id'), @reddit_id, ->
    'click #analyze_link': ->
        Meteor.call 'call_watson', FlowRouter.getParam('doc_id'), @url, ->
