Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'



Template.registerHelper 'field_value', ->
    # console.log @
    current_doc = Template.parentData(3)
    # current_doc = Docs.findOne Session.get('editing_id')
    if current_doc
        current_doc["#{@key}"]
        
Template.registerHelper 'page_field_value', ->
    # console.log @
    # current_doc = Template.parentData(3)
    current_doc = Docs.findOne Session.get('editing_id')
    current_doc["#{@key}"]
        
Template.registerHelper 'passed_field_doc', ->
    field_doc = Docs.findOne @valueOf()
    # console.log 'passed_field_doc slug',field_doc.slug
    field_doc
    # current_doc = Docs.findOne Session.get('editing_id')
    # current_doc["#{@key}"]


Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')
# Template.registerHelper 'person', () -> Meteor.users.findOne username:@username

    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id
# Template.registerHelper 'is_person_by_username', () ->  Meteor.user().username is @username

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")

Template.registerHelper 'formatted_start_date', () -> moment(@start_datetime).format("dddd, MMMM Do, h:mm a")
Template.registerHelper 'formatted_end_date', () -> moment(@end_datetime).format("dddd, MMMM Do, h:mm a")
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'publish_when', () -> moment(@publish_date).fromNow()
Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev_env', () -> Meteor.isDevelopment
Template.registerHelper 'is_dev', () -> 
    user = Meteor.user()
    if user
        if Meteor.user().roles
            if 'dev' in Meteor.user().roles
                true
            else
                false
        else
            false
    else
        false

Template.registerHelper 'from_now', (input) -> moment(input).fromNow()




Template.home.onCreated ->
    @autorun -> Meteor.subscribe 'delta'

Template.home.helpers
    delta: -> 
        delta = Docs.findOne type:'delta'
        if delta 
            delta
    
    facets: ->
        # at least keys
        facets = []
        delta = Docs.findOne type:'delta'
        if delta 
            console.log delta
            if delta.keys_filter
                for item in delta.keys_filter
                    facets.push item.name
        facets.push 'keys'
        facets
    
    
Template.result.helpers
    value: ->
        filter = Template.parentData()
        filter["#{@valueOf()}"]


Template.facet.helpers
    values: ->
        # console.log @
        delta = Docs.findOne type:'delta'
        filtered_values = []
        if delta
            filters = delta["filter_#{@valueOf()}"]
            unfiltered_return = delta["#{@valueOf()}_return"]
            if unfiltered_return and filters
                console.log filters
                for val in unfiltered_return
                    if val.name in filters
                        continue
                    else if val.count < delta.total
                        filtered_values.push val
                filtered_values
    
    selected_values: ->
        # console.log @
        delta = Docs.findOne type:'delta'
        # delta["#{@valueOf()}_return"]?[..20]
        filtered_values = []
        if delta
            delta["filter_#{@valueOf()}"]

    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne type:'delta'

        if facet.filters and @name in facet.filters
            'topcoat-button--cta'
        else
            'topcoat-button'


Template.home.events
    'click .create_delta': (e,t)->
        Docs.insert
            type:'delta'
            facets: [{key:'keys', res:[]}]
            result_ids:[]
        # Meteor.call 'fo'
    
    'click .delete_delta': (e,t)->
        delta = Docs.findOne type:'delta'
        Docs.remove delta._id
    
    'click .print_delta': (e,t)->
        delta = Docs.findOne type:'delta'
        console.log delta

    'click .recalc': ->
        Meteor.call 'fo', (err,res)->


Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne type:'delta'
        facet = Template.currentData()
        
        delta = Docs.findOne type:'delta'
        if facet.filters and @name in facet.filters
            Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
        else 
            Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->