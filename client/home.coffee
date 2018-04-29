
Session.setDefault 'view_mode', 'post_view'



Template.view_toggle.events
    'click .toggle_view': ->
        Session.set 'view_mode', @name
        # console.log @name
Template.view_toggle_item.events
    'click .toggle_view': ->
        Session.set 'view_mode', @name
        # console.log @name


Template.home.onCreated ->
    @autorun => 
        Meteor.subscribe('facet', 
            selected_tags.array()
            )
        Meteor.subscribe 'doc', Session.get('editing_id')

Template.home.helpers
    one_doc: -> Docs.find().count() is 1
    view_mode: -> Session.get 'view_mode'
    viewing_table: -> Session.equals 'view_mode','table'

    docs: -> Docs.find({},{limit:1,sort:tag_count:1})
Template.table_view.helpers
    table_docs: -> Docs.find({},{limit:10,sort:tag_count:1})

    # editing_this: -> Session.equals 'editing_id', @_id

    # is_editing: -> Session.get 'editing_id'

