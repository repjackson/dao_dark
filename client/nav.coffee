
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'me'

Template.sessions.onCreated ->
    @autorun -> Meteor.subscribe 'my_deltas'

Template.sessions.helpers
    session_item_class: ->
        if Meteor.user().current_delta_id is @_id then 'active' else ''

Template.sessions.events
    'click .delta': ->
        Meteor.users.update Meteor.userId(),
            $set:current_template: 'delta'
   
    'click .create_delta': (e,t)->
        new_delta_id = Docs.insert
            type:'delta'
            facets: [{key:'keys', res:[]}]
        Meteor.users.update Meteor.userId(),
            $set: current_delta_id: new_delta_id
        Meteor.call 'fo'
    'click .select_delta': ->
        Meteor.users.update Meteor.userId(),
            $set: current_delta_id: @_id

Template.nav.events
    'click .add_doc': ->
        delta = Docs.findOne Meteor.user().current_delta_id
        new_id = Docs.insert {}
        new_delta = 
            Docs.insert 
                type:'delta'
                editing:true
                title: 'Session'
                doc_id: new_id
                facets: [{key:'keys', res:[]}]
        Meteor.users.update Meteor.userId(),
            $set: current_delta_id: new_delta._id
        

    'click .inbox': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'inbox'    
    
    'click .crm': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'crm'    
    
    'click .alerts': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'alerts'
            
            
    'click .logout': ->
        Meteor.logout()