
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'my_deltas'
    @autorun -> Meteor.subscribe 'me'

Template.nav.events
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

    'click .add_doc': ->
        delta = Docs.findOne Meteor.user().current_delta_id
        new_id = Docs.insert {}
        new_delta = 
            Docs.insert 
                type:'delta'
                editing:true
                doc_id: new_id
                facets: [{key:'keys', res:[]}]
        Meteor.users.update Meteor.userId(),
            $set: current_delta_id: new_id
        
    'click .select_delta': ->
        Meteor.users.update Meteor.userId(),
            $set: current_delta_id: @_id


    'click .inbox': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'inbox'    
    
    'click .alerts': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'alerts'
            
            
    'click .logout': ->
        Meteor.logout()