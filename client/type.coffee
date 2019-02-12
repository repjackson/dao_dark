# Template.type.onCreated ->
#     @autorun -> Meteor.subscribe 'schema_from_slug', Router.current().params.type
#     @autorun -> Meteor.subscribe 'schema_bricks_from_slug', Router.current().params.type
#     # @autorun -> Meteor.subscribe 'deltas', Router.current().params.type
#     # @autorun -> Meteor.subscribe 'type', 'delta'
#     @autorun -> Meteor.subscribe 'my_delta'


# Template.type.helpers
#     schema: ->
#         Docs.findOne
#             type:'schema'
#             slug: Router.current().params.type

#     type_docs: ->
#         Docs.find
#             type:Router.current().params.type

#     current_delta: -> 
#         Docs.findOne type:'delta'



# Template.type.events
#     'click .add_type_doc': ->
#         new_doc_id = Docs.insert 
#             type:Router.current().params.type
#             parent_id:Meteor.userId()
#         Router.go "/s/#{Router.current().params.type}/#{new_doc_id}/edit"

#     'click .edit_schema': ->
#         schema = Docs.findOne
#             type:'schema'
#             slug: Router.current().params.type
#         Router.go "/s/#{schema.slug}/#{schema._id}/edit"


#     'click .delete_delta': (e,t)->
#         delta = Docs.findOne type:'delta'
#         if delta
#             if confirm "delete  #{delta._id}?"
#                 Docs.remove delta._id
    
#     'click .create_delta': (e,t)->
#         Docs.insert type:'delta'

#     'click .print_delta': (e,t)->
#         delta = Docs.findOne type:'delta'
#         console.log delta

#     'click .recalc': ->
#         Meteor.call 'fum', (err,res)->
    
#     # 'click .select_session': ->
#     #     # console.log @
#     #     Session.set 'delta_id', @_id



# Template.type_edit.onCreated ->
#     @autorun -> Meteor.subscribe 'doc', Router.current().params._id, Router.current().params.type
#     @autorun -> Meteor.subscribe 'bricks_from_doc_id', Router.current().params._id
#     @autorun -> Meteor.subscribe 'schema_from_doc_id', Router.current().params._id

# Template.type_view.onCreated ->
#     @autorun -> Meteor.subscribe 'schema_from_doc_id', Router.current().params._id
#     @autorun -> Meteor.subscribe 'bricks_from_doc_id', Router.current().params._id
#     @autorun -> Meteor.subscribe 'doc', Router.current().params._id, Router.current().params.type



# Template.type_edit.events
#     'click .delete_doc': ->
#         if confirm 'Confirm delete?'
#             Docs.remove @_id
#             Router.go "/s/#{type}"
    



# Template.facet.onRendered ->
#     Meteor.setTimeout ->
#         $('.accordion').accordion()
#     , 1000



# Template.facet.events
#     'click .toggle_selection': ->
#         delta = Docs.findOne type:'delta'
#         facet = Template.currentData()
#         Session.set 'loading', true
#         if facet.filters and @name in facet.filters
#             Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
#                 Session.set 'loading', false
#         else 
#             Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
#                 Session.set 'loading', false
      
#     'keyup .add_filter': (e,t)->
#         if e.which is 13
#             delta = Docs.findOne type:'delta'
#             facet = Template.currentData()
#             filter = t.$('.add_filter').val()
#             Session.set 'loading', true
#             Meteor.call 'add_facet_filter', delta._id, facet.key, filter, ->
#                 Session.set 'loading', false
#             t.$('.add_filter').val('')
            
        
      
    
Template.facet.helpers
    filtering_res: ->
        delta = Docs.findOne type:'delta'
        filtering_res = []
        # if @key is '_keys'
        #     filtered_list = [
        #         'entities'
        #         'keywords'
        #         'concepts'
        #         'tags'
        #         'youtube'
        #         'type'
        #     ]
        #     filtering_res = @res
        #     # for filter in @res
        #         # if filter.name in filtered_list then filtering_res.push filter
        # else
        # console.log @
        for filter in @res
            if filter.count < delta.total
                filtering_res.push filter
            else if filter.name in @filters
                filtering_res.push filter
        filtering_res

    

#     toggle_value_class: ->
#         facet = Template.parentData()
#         delta = Docs.findOne type:'delta'
#         if Session.equals 'loading', true
#              'disabled '
#         else if facet.filters.length > 0 and @name in facet.filters
#             'black'
#         else ''
        
# Template.result.onCreated ->
#     @autorun => Meteor.subscribe 'doc', @data._id, Router.current().params.type

# Template.result.helpers
#     result: -> 
#         current_type = Router.current().params.type
#         if Meteor.users.findOne @_id
#             Meteor.users.findOne @_id
#         else if current_type
#             schema = Docs.findOne 
#                 type:'schema'
#                 slug:current_type
#             if schema.collection
#                 global["#{schema.collection}"].findOne @_id
#             else if Docs.findOne @_id
#                 Docs.findOne @_id

    
Template.result.events
    'click .set_schema': ->
        Meteor.call 'set_delta_facets', @slug, Meteor.userId()
