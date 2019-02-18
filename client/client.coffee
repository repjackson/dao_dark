@selected_tags = new ReactiveArray []
@selected_usernames = new ReactiveArray []
@selected_status = new ReactiveArray []


$.cloudinary.config
    cloud_name:"facet"



Session.setDefault 'invert', false
Template.registerHelper 'dark_side', () -> Session.equals('invert',true)
Template.registerHelper 'invert_class', () -> if Session.equals('invert',true) then 'invert' else ''
Template.registerHelper 'is_loading', () -> Session.get 'loading'
Template.registerHelper 'dev', () -> Meteor.isDevelopment
Template.registerHelper 'is_author', () -> @_author_id is Meteor.userId()
Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")
Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()
Template.registerHelper 'from_now', (input) -> moment(input).fromNow()


Template.registerHelper 'in_list', (key) ->
    if Meteor.userId()
        if Meteor.userId() in @["#{key}"] then true else false

Template.registerHelper 'doc', () ->
    Docs.findOne Router.current().params._id

Template.registerHelper 'schema', () ->
    Docs.findOne
        type:'schema'
        slug:@type
        
Template.registerHelper 'current_tribe', () ->
    Docs.findOne 
        type:'tribe'
        slug:Router.current().params.tribe_slug

Template.registerHelper 'user_from_id_param', () ->
    Meteor.users.findOne Router.current().params._id

Template.registerHelper 'is_schema_type', () ->
    @type is 'schema'

Template.registerHelper 'calculated_size', (metric) ->
    # console.log metric
    # console.log typeof parseFloat(@relevance)
    # console.log typeof (@relevance*100).toFixed()
    whole = parseInt(@["#{metric}"]*10)
    # console.log whole
    
    if whole is 2 then 'f2'
    else if whole is 3 then 'f3'
    else if whole is 4 then 'f4'
    else if whole is 5 then 'f5'
    else if whole is 6 then 'f6'
    else if whole is 7 then 'f7'
    else if whole is 8 then 'f8'
    else if whole is 9 then 'f9'
    else if whole is 10 then 'f10'




Template.registerHelper 'parent', () ->
    parent = Template.parentData(5)

# Template.registerHelper 'field_value', () ->
#     parent = Template.parentData(5)
#     console.log @
#     if parent["#{@valueOf()}"] then parent["#{@valueOf()}"]


Template.registerHelper 'youtube_value', () ->
    # console.log @
    # console.log Template.currentData()
    # console.log Template.parentData()
    # console.log Template.parentData(1)
    # console.log Template.parentData(2)
    # console.log Template.parentData(3)
    # console.log Template.parentData(4)
    # console.log Template.parentData(5)
    # console.log Template.parentData(6)
    parent = Template.parentData(5)
    # console.log parent["_#{@valueOf()}"].youtube_id
    parent["_#{@valueOf()}"].youtube_id



Template.registerHelper 'edit_template', ->
    # console.log @
    "#{@field}_edit"
    
Template.registerHelper 'current_user', () ->
    Meteor.userId() is Router.current().params._id
    
    
Template.registerHelper 'field_template_doc', () ->
    console.log @
    Docs.findOne
        type:'field_template'
        slug: @valueOf()
        
    
    
Template.registerHelper 'view_template', ->
    # console.log @
    "#{@field}_view"
    
    
Template.registerHelper 'bricks', () ->
    console.log @type
    if @type in ['field', 'brick','schema']
        schema = Docs.findOne
            type:'schema'
            slug:@type
            # tribe:'dao'
    else
        schema = Docs.findOne
            type:'schema'
            slug:@type
            tribe:Router.current().params.tribe_slug
        
    Docs.find {
        type:'brick'
        parent_id:schema._id
    }, sort:rank:1
    
    
    
Template.registerHelper 'field_value', () ->
    parent = Template.parentData()
    # parent2 = Template.parentData(2)
    # parent3 = Template.parentData(3)
    # parent4 = Template.parentData(4)
    # parent5 = Template.parentData(5)
    # parent6 = Template.parentData(6)
    # console.log Template.parentData()
    # console.log Template.parentData(4)
    # console.log Template.parentData(5)
    field_template_context = Template.parentData(6)
    brick = Template.parentData(4)
    context = Template.parentData(5)
    if parent["#{@key}"] then parent["#{@key}"]
    else if context["#{brick.key}"] 
        context["#{brick.key}"]
    # else if field_template_context["#{context}"] 
    #     field_template_context["#{context}"]
    


Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)

    
Template.registerHelper 'user_from_id_param', () ->
    Meteor.users.findOne Router.current().params._id

Template.registerHelper 'is_schema_type', () ->
    @type is 'schema'

Template.registerHelper 'is_eric', () ->
    Meteor.userId() is 'ytjpFxiwnWaJELZEd' and Router.current().params._id is 'ytjpFxiwnWaJELZEd'

Template.registerHelper 'current_user', () ->
    Meteor.userId() is Router.current().params._id

Template.registerHelper 'can_add', () ->
    if Meteor.user()
        if Meteor.user().roles
            if @add_roles
                union = _.intersection Meteor.user().roles,@add_roles
                if union.length > 0 then true else false
            else 
                false
        else 
            false
    else 
        false
    
    
    
Template.registerHelper 'my_sites', () ->
    if Meteor.user().site_ids
        Docs.find
            type:'site'
            site_member_ids: $in: [Meteor.userId()]

Template.registerHelper 'user_from_id', ()->
    Meteor.users.findOne @valueOf()
    
                
Template.registerHelper 'can_edit', () ->
    if Meteor.user()
        if Meteor.userId() is @_author_id 
            true
        if Meteor.user().roles
            if 'dev' in Meteor.user().roles then true
            else if @edit_roles
                union = _.intersection Meteor.user().roles,@edit_roles
                if union.length > 0 then true else false
            else 
                false
        else 
            false
    else 
        false
                
                