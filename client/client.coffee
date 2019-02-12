import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


FlowRouter.route '/', action: -> @render 'layout','delta'

FlowRouter.route '/enter', action: -> @render 'layout','enter'
FlowRouter.route '/me', action: -> @render 'layout','me'
FlowRouter.route '/users', action: -> @render 'layout','users'
FlowRouter.route '/inbox', action: -> @render 'layout','inbox'
FlowRouter.route '/bank', action: -> @render 'layout','bank'
FlowRouter.route '/settings', action: -> @render 'layout','settings'

FlowRouter.route '/u/:username', action: -> @render 'layout','user'
FlowRouter.route '/edit/:id', action: -> @render 'layout','edit'
FlowRouter.route '/view/:id', action: -> @render 'layout','view'
FlowRouter.route '*', action: -> @render 'not_found'






FlowRouter.route '/user/:_id/edit', action: -> @render 'layout','user_edit'

FlowRouter.route '/s/:type', action: -> @render 'layout', 'type'
FlowRouter.route '/s/:type/:_id/edit', action: -> @render 'layout', 'type_edit'
FlowRouter.route '/s/:type/:_id/view', action: -> @render 'layout', 'type_view'

FlowRouter.route '/p/:slug', action: -> @render 'layout', 'page'

Session.setDefault 'invert', true
Template.registerHelper 'dark_side', () -> Session.equals('invert',true)
Template.registerHelper 'invert_class', () -> if Session.equals('invert',true) then 'inverted' else ''
Template.registerHelper 'dev', () -> Meteor.isDevelopment
Template.registerHelper 'is_author', () -> @_author_id is Meteor.userId()
Template.registerHelper 'to_percent', (number) -> (number*100).toFixed()
Template.registerHelper 'formatted_date', () -> moment(@date).format("dddd, MMMM Do")
Template.registerHelper 'when', () -> moment(@_timestamp).fromNow()
Template.registerHelper 'from_now', (input) -> moment(input).fromNow()
Template.registerHelper 'nl2br', (text)->
    nl2br = (text + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + '<br>' + '$2')
    new Spacebars.SafeString(nl2br)


Template.registerHelper 'in_list', (key) ->
    if Meteor.userId()
        if Meteor.userId() in @["#{key}"] then true else false

Template.registerHelper 'doc', () ->
    Docs.findOne FlowRouter.getParam('id')

Template.registerHelper 'schema', () ->
    Docs.findOne
        type:'schema'
        slug:@type

Template.registerHelper 'user_from_id_param', () ->
    Meteor.users.findOne FlowRouter.getParam('_id')

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

Template.registerHelper 'field_value', () ->
    parent = Template.parentData(5)
    if parent["#{@valueOf()}"] then parent["#{@valueOf()}"]


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
