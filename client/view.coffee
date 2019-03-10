

Template.view.onCreated ->
    @autorun -> Meteor.subscribe 'doc', Router.current().params._id
    @autorun -> Meteor.subscribe 'schema', Router.current().params._id




# Template.detect.events
#     'click .detect_fields': ->
#         # console.log @
#         Meteor.call 'detect_fields', @_id

Template.key_view.helpers
    key: -> @valueOf()

    meta: ->
        key_string = @valueOf()
        parent = Template.parentData()
        parent["_#{key_string}"]


    field_view: ->
        key_string = @valueOf()
        meta = Template.parentData()["_#{key_string}"]
        "#{meta.field}_view"
