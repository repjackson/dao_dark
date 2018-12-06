Accounts.ui.config
    passwordSignupFields: 'USERNAME_ONLY'



Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()         

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')
# Template.registerHelper 'person', () -> Meteor.users.findOne username:@username

    
Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'is_user', () ->  Meteor.userId() is @_id
# Template.registerHelper 'is_person_by_username', () ->  Meteor.user().username is @username

# Template.registerHelper 'can_edit', () ->  Meteor.userId() is @author_id or Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'long_date', () -> moment(@timestamp).format("dddd, MMMM Do, h:mm a")

Template.registerHelper 'formatted_end_date', () -> moment(@end_datetime).format("dddd, MMMM Do, h:mm a")
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")

Template.registerHelper 'is_author', () ->  Meteor.userId() is @author_id
Template.registerHelper 'when', () -> moment(@timestamp).fromNow()
Template.registerHelper 'is_dev_env', () -> Meteor.isDevelopment

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

    is_html: ->
        local_doc = Template.parentData()
        if local_doc
            value = local_doc["#{@valueOf()}"]
            type = typeof value
            if type is 'string'
                html_check = /<[a-z][\s\S]*>/i
                html_result = html_check.test value
                html_result
            
    is_timestamp: ->
        local_doc = Template.parentData()
        if local_doc
            value = local_doc["#{@valueOf()}"]
            d = Date.parse(value);
            nan = isNaN d
            !nan
        
        
    is_array: ->
        local_doc = Template.parentData()
        if local_doc
            value = local_doc["#{@valueOf()}"]
            $.isArray value

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
            'tc-button--cta'
        else
            'tc-button'

Template.edit.events
    'click .save': ->
        delta = Docs.findOne type:'delta'
        Docs.update delta._id,
            $set:
                editing:false
    
        
    

Template.home.events
    'click .create_delta': (e,t)->
        Docs.insert
            type:'delta'
            facets: [{key:'keys', res:[]}]
            result_ids:[]
        # Meteor.call 'fo'
    
    'click .add_doc': ->
        delta = Docs.findOne type:'delta'
        new_id = Docs.insert {}
        new_doc = Docs.findOne new_id
        console.log new_doc
        Docs.update delta._id,
            $set:
                editing:true
                doc_id: new_id
    
    
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