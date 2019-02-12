# import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

# Template.view.onCreated ->
#     @autorun -> Meteor.subscribe 'doc', FlowRouter.getParam('id')
#     @autorun -> Meteor.subscribe 'schema', FlowRouter.getParam('id')



            
# Template.detect.events
#     'click .detect_fields': ->
#         # console.log @
#         Meteor.call 'detect_fields', @_id
                    
# Template.key_view.helpers
#     key: -> @valueOf()
    
#     meta: ->
#         key_string = @valueOf()
#         parent = Template.parentData()
#         parent["_#{key_string}"]
    
    
#     field_view: ->
#         key_string = @valueOf()
#         meta = Template.parentData()["_#{key_string}"]
#         "#{meta.brick}_view"
            
                    



