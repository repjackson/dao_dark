Template.threaded_children.onCreated ->
    @autorun -> Meteor.subscribe 'child_docs', FlowRouter.getParam('doc_id')

Template.threaded_children.onRendered ->
    # Meteor.setTimeout ->
    #     $('.progress').progress()
    # , 2000
    Meteor.setTimeout ->
        $('.ui.accordion').accordion()
    , 2000
    

Template.threaded_children.helpers
    child_docs: ->
        doc_id = FlowRouter.getParam('doc_id')
        Docs.find
            parent_id: doc_id

Template.threaded_children.events
    'click #call_watson': ->    