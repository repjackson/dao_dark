if Meteor.isClient
    Template.view.onCreated ->
        @autorun => Meteor.subscribe 'doc', Session.get('page_data')
        
        
        
    Template.edit.onCreated ->
        @autorun => Meteor.subscribe 'doc', Session.get('page_data')
    
    Template.edit.events
        'click .print': (e,t)->
            console.log Docs.findOne Session.get('page_data')
        
        'keyup .new_tag': (e,t)->
            if e.which is 13
                tag_val = t.$('.new_tag').val().trim()
                parent = Docs.findOne Session.get('page_data')
                Docs.update parent._id, 
                    $addToSet: tags: tag_val
                t.$('.new_tag').val('')
            
        'click .remove_tag': (e,t)->
            tag = @valueOf()
            parent = Docs.findOne Session.get('page_data')
            Docs.update parent._id, 
                $pull:tags:tag
            
        'blur .edit_body': (e,t)->
            body_val = t.$('.edit_body').val()
            parent = Docs.findOne Session.get('page_data')
            Docs.update parent._id, 
                $set: body:body_val
        
            
        'change .points': (e,t)->
            points_val = parseInt t.$('.points').val()
            console.log points_val
            parent = Docs.findOne Session.get('page_data')
            Docs.update parent._id, 
                $set: points:points_val