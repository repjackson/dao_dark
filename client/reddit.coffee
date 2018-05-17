FlowRouter.route '/reddit', action: (params) ->
    BlazeLayout.render 'layout',
        nav: 'nav'
        main: 'reddit'


Template.reddit.onCreated ->
    @autorun => 
        Meteor.subscribe('facet', 
            selected_tags.array()
            selected_keywords.array()
            selected_concepts.array()
            selected_entities.array()
            selected_author_ids.array()
            selected_location_tags.array()
            selected_timestamp_tags.array()
            type='reddit'
            author_id=null
        )
        # Meteor.subscribe 'doc', Session.get('editing_id')

Template.reddit.events
    'keyup #check_subreddit': (e,t)->
        if e.which is 13
            sub = $('#check_subreddit').val().toLowerCase().trim()
            if sub.length > 0
                Meteor.call 'pull_subreddit', sub
                # Docs.update doc_id,
                #     $set: check_subreddit: image_id
                $('#check_subreddit').val('')

Template.reddit.helpers
    one_doc: -> Docs.find().count() is 1
    docs: -> Docs.find({},{limit:42,sort:tag_count:1})

Template.reddit_view.onRendered ->
    Meteor.setTimeout ->
        $('.ui.tabular.menu .item').tab()
    , 500



Template.reddit_view.events
    'click #get_reddit_post': ->
        Meteor.call 'get_reddit_post', FlowRouter.getParam('doc_id'), @reddit_id, ->
    'click #pull_site': ->
        # console.log @
        Meteor.call 'pull_site', FlowRouter.getParam('doc_id'), @url, ->
    'click #get_comments': ->
        Meteor.call 'get_listing_comments', @_id, @domain, @reddit_id, ->
