Template.reddit.onCreated ->
    @autorun => Meteor.subscribe 'doc_id', @data._id

                
Template.reddit.helpers
    result: ->
        Docs.findOne
            _id: Template.currentData()._id
