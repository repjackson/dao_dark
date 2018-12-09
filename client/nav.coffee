
Template.nav.onCreated ->
    @autorun -> Meteor.subscribe 'me'
    @autorun -> Meteor.subscribe 'my_tribe'
    @autorun -> Meteor.subscribe 'my_deltas'


Template.nav.helpers
    session_item_class: ->
        if Meteor.user().current_delta_id is @_id then 'active' else ''

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
        
    'click .select_delta': ->
        Meteor.users.update Meteor.userId(),
            $set: 
                current_delta_id: @_id
                current_template: 'delta'



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
        

    'click .dash': ->
        existing_dash = Docs.findOne
            type:'delta'
            delta_template: 'dash'
        
        if existing_dash
            Meteor.users.update Meteor.userId(),
                $set: 
                    current_template: 'delta'
                    current_delta_id: existing_dash._id
        else
            new_dash_id = Docs.insert
                type:'delta'
                title:'Dashboard'
                icon:'dashboard'
                delta_template: 'dash'
                facets: [
                    {
                        key:'type'
                        filters: ['schema']
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
                    current_delta_id: new_dash_id
            Meteor.call 'fo'
            
        
        Meteor.users.update Meteor.userId(),
            $set: 
                current_template: 'delta'
                
    'click .modules': ->
        user_module_delta = Docs.findOne
            type:'delta'
            module: 'module'
        
        if user_module_delta
            Meteor.users.update Meteor.userId(),
                $set: 
                    current_template: 'delta'
                    current_delta_id: user_module_delta._id
        else
            new_user_module_delta_id = Docs.insert
                type:'delta'
                module: 'module'
                facets: [
                    {
                        key:'type'
                        filters: ['module']
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
            
    
    'click .inbox': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'inbox'    
    
    'click .crm': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'crm'    
    
    'click .alerts': ->
        Meteor.users.update Meteor.userId(),
            $set: current_template: 'alerts'
            
    'click .profile': ->
        Meteor.users.update Meteor.userId(),
            $set: 
                current_template: 'profile'
            
            
    'click .logout': ->
        Meteor.logout()