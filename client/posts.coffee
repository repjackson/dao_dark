
Session.setDefault 'view_mode', 'post_view'

FlowRouter.route '/posts', action: (params) ->
    BlazeLayout.render 'layout',
        nav: 'nav'
        main: 'posts'


Template.view_toggle.events
    'click .toggle_view': ->
        Session.set 'view_mode', @name
        # console.log @name
Template.view_toggle_item.events
    'click .toggle_view': ->
        Session.set 'view_mode', @name
        # console.log @name


Template.layout.onCreated ->
    @autorun => 
        Meteor.subscribe('facet', 
        selected_tags.array()
        selected_keywords.array()
        selected_author_ids.array()
        selected_location_tags.array()
        selected_timestamp_tags.array()
        type='post'
        author_id=null
        )
        # Meteor.subscribe 'doc', Session.get('editing_id')

Template.posts.events
    # 'click #save': -> Session.set 'editing_id', null
    # 'click .edit': -> Session.set 'editing_id', @_id
Template.posts.helpers
    one_doc: -> Docs.find().count() is 1
    view_mode: -> Session.get 'view_mode'
    viewing_table: -> Session.equals 'view_mode','table'
    editing_id: -> Session.get 'editing_id'
    docs: -> Docs.find({},{limit:10,sort:tag_count:1})
Template.table_view.helpers
    table_docs: -> Docs.find({},{limit:10,sort:tag_count:1})

    # editing_this: -> Session.equals 'editing_id', @_id

    # is_editing: -> Session.get 'editing_id'

