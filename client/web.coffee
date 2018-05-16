FlowRouter.route '/web', action: (params) ->
    BlazeLayout.render 'layout',
        nav: 'nav'
        main: 'web'


Template.view_toggle.events
    'click .toggle_view': ->
        Session.set 'view_mode', @name
        # console.log @name
Template.view_toggle_item.events
    'click .toggle_view': ->
        Session.set 'view_mode', @name
        # console.log @name


Template.web.onCreated ->
    @autorun => 
        Meteor.subscribe('facet', 
        selected_tags.array()
        selected_keywords.array()
        selected_concepts.array()
        selected_author_ids.array()
        selected_location_tags.array()
        selected_timestamp_tags.array()
        type='website'
        author_id=null
        )
        # Meteor.subscribe 'doc', Session.get('editing_id')

Template.web.events
    'click #call_this_watson': ->
        # console.log @
        Meteor.call 'call_watson', @_id, @url, ->


Template.pull_site.events
    'keyup #site_input': (e,t)->
        if e.which is 13
            website = $('#site_input').val().toLowerCase().trim()
            console.log website
            if website.length > 0
                Meteor.call 'pull_site', FlowRouter.getParam('doc_id'),  website, (err, res)->
                $('#site_input').val('')

Template.web.helpers
    one_doc: -> Docs.find().count() is 1
    websites: -> Docs.find({type:'website'},{limit:42,sort:tag_count:1})

Template.website_view.onRendered ->
    # Meteor.setTimeout ->
    #     $('.ui.checkbox').checkbox()
    # #     $('.ui.tabular.menu .item').tab()
    # , 400
    Meteor.setTimeout ->
        $('.ui.tabular.menu .item').tab()
    , 500


