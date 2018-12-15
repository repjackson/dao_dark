Template.result.onCreated ->
    @autorun => Meteor.subscribe 'doc_id', @data._id
    Meteor.setTimeout ->
        $('.ui.progress').progress();
    , 500

                
Template.result.helpers
    result: ->
        Docs.findOne
            _id: Template.currentData()._id
