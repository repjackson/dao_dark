
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'my_tribe'
    @autorun -> Meteor.subscribe 'my_deltas'
    @autorun -> Meteor.subscribe 'schema', 'module'
    @autorun -> Meteor.subscribe 'schema', 'tribe'


Template.nav.helpers
    session_item_class: ->
        if Meteor.user().current_delta_id is @_id then 'active' else ''
    tribe_modules: ->
        if Meteor.user() 
            current_tribe = Docs.findOne Meteor.user().current_tribe_id
            Docs.find
                schema:'module'
                tribe_ids: $in: [Meteor.user().current_tribe_id]

Template.nav.events
    'click .delta': ->
        Meteor.users.update Meteor.userId(),
            $set:current_template: 'delta'
   
    'click .create_delta': (e,t)->
        new_delta_id = Docs.insert
            schema:'delta'
            view:'list'
            facets: [{key:'keys', res:[]}]
        Meteor.users.update Meteor.userId(),
            $set: current_delta_id: new_delta_id
        Meteor.call 'fo'
        
    'click .select_delta': ->
        Meteor.users.update Meteor.userId(),
            $set: 
                current_delta_id: @_id
                current_template: 'delta'


Template.nav.events
    'click .select_module': ->
        user_module_delta = Docs.findOne
            schema:'delta'
            module_id: @_id
        
        if user_module_delta
            Meteor.users.update Meteor.userId(),
                $set: 
                    current_template: 'delta'
                    current_delta_id: user_module_delta._id
        else
            new_user_module_delta_id = Docs.insert
                schema:'delta'
                view:'list'
                module_id: @_id
                # need to hook into schema fields
                facets: [
                    {
                        key:'schema'
                        filters: [@child_schema]
                        hidden:true
                    }
                    {
                        key:'tags'
                        res:[]
                    }
                    {
                        key:'title'
                        res:[]
                    }
                ]
                
            Meteor.users.update Meteor.userId(),
                $set: 
                    current_template: 'delta'
                    current_delta_id: new_user_module_delta_id
            Meteor.call 'fo'
            
    
    'click .logout': ->
        Meteor.logout()