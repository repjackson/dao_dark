import { FlowRouter } from 'meteor/ostrio:flow-router-extra';

Template.layout.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'my_deltas'
    @autorun -> Meteor.subscribe 'public_deltas'
    Session.setDefault 'out_page', 'front'

FlowRouter.route '/',
    name: 'home'
    action: -> @render 'layout','delta'

FlowRouter.route '/enter',
    name: 'enter'
    action: -> @render 'layout','enter'

FlowRouter.route '/me',
    name: 'me'
    action: -> @render 'layout','me'

FlowRouter.route '/d/:type',
    name: 'delta'
    action: -> @render 'layout','delta'

 
FlowRouter.route '/edit/:doc_id',
    name: 'edit_doc'
    action: -> @render 'layout','edit_doc'

 
Template.layout.events
    'click .create_delta': (e,t)->
        Meteor.call 'create_delta', (err,res)->
            Session.set 'current_delta_id', res
        Meteor.call 'fo', Session.get('current_delta_id')
        
    'click .select_delta': ->
        Session.set 'current_delta_id', @_id
        if Meteor.user()
            Meteor.users.update Meteor.userId(),
                $set: 
                    current_delta_id: @_id
                    current_template: 'delta'
        Meteor.call 'fo', Session.get('current_delta_id')
        
    'click .logout': ->
        Meteor.logout()
        
    'click .delete_delta': (e,t)->
        # delta = Docs.findOne Session.get('current_delta_id')
        delta = Docs.findOne Session.get('current_delta_id')
        
        Docs.remove delta._id
    
    'click .print_delta': (e,t)->
        delta = Docs.findOne Session.get('current_delta_id')
        console.log delta

    'click .recalc': ->
        Meteor.call 'fo', (err,res)->

    'blur .delta_title': (e,t)->
        title_val = t.$('.delta_title').val()
        Docs.update Meteor.user().current_delta_id,
            $set: title: title_val
        

Template.facet.helpers
    filtering_res: ->
        delta = Docs.findOne Session.get('current_delta_id')
        filtering_res = []
        for filter in @res
            if filter.count < delta.total
                filtering_res.push filter
            else if filter.name in @filters
                filtering_res.push filter
        filtering_res

    toggle_value_class: ->
        facet = Template.parentData()
        delta = Docs.findOne Session.get('current_delta_id')

        if facet.filters and @name in facet.filters
            'grey'
        else
            ''

Template.facet.events
    'click .toggle_selection': ->
        delta = Docs.findOne Session.get('current_delta_id')
        facet = Template.currentData()
        
        if facet.filters and @name in facet.filters
            Meteor.call 'remove_facet_filter', delta._id, facet.key, @name, ->
        else 
            Meteor.call 'add_facet_filter', delta._id, facet.key, @name, ->
      

