FlowRouter.route '/dashboard', action: ->
    BlazeLayout.render 'layout', 
        main: 'dashboard'

Template.view_features.onCreated ->
    @autorun => Meteor.subscribe 'facet', 
        selected_tags.array()
        selected_keywords.array()
        selected_author_ids.array()
        selected_location_tags.array()
        selected_timestamp_tags.array()
        type='feature'
        author_id=null

Template.dashboard.onRendered ->
    Meteor.setTimeout ->
        $('.ui.accordion').accordion()
    , 400

    Meteor.setTimeout ->
    #     $('.masthead').visibility
    #         once: false
    #         # onBottomPassed: ->
    #         #     $('.fixed.menu').transition 'fade in'
    #         #     console.log 'bottom passed'
    #         # onBottomPassedReverse: ->
    #         #     $('.fixed.menu').transition 'fade out'
    #         #     console.log 'bottom passed'
    # , 400


Template.view_features.helpers
    features: -> Docs.find {type:'feature'}
    