if Meteor.isClient
    Template.tickets.onCreated ->
        @autorun -> Meteor.subscribe 'tickets'
    
    Template.ticket_card.onCreated ->
        @editing = new ReactiveVar false
        
    Template.ticket_card.events
        'blur .title': (e,t)->
            val = t.$('.title').val()
            Docs.update @_id,
                $set:title:val
        
        'blur .details': (e,t)->
            val = t.$('.details').val()
            Docs.update @_id,
                $set:details:val
        
        'change .due_date': (e,t)->
            val = t.$('.due_date').val()
            Docs.update @_id,
                $set:due_date:val
        
        
        'keyup .add_tag': (e,t)->
            if e.which is 13
                val = t.$('.add_tag').val()
                console.log val
                Docs.update @_id,
                    $addToSet: tags: val
                t.$('.add_tag').val('')
        
        'click .pull_tag': (e,t)->
            target = Template.parentData()
            Docs.update t.data._id,
                $pull:tags:@valueOf()
            t.$('.add_tag').val(@valueOf())
            
        
        'click .delete': ->
            if confirm 'Delete?'
                Docs.remove @_id
    
    
        'click .edit': (e,t)-> t.editing.set true
        'click .save': (e,t)-> t.editing.set false
    
    Template.ticket_card.helpers
        editing: -> Template.instance().editing.get()
    
    Template.tickets.events
        'click .add_ticket': ->
            Docs.insert
                type:'ticket'
                upvoters: []
                downvoters: []
                points: 0
                author_username: Meteor.user().username
    
    
    Template.tickets.helpers
        tickets: -> Docs.find type:'ticket'
        
        editing: -> Template.instance().editing.get()
        
if Meteor.isServer
    Meteor.publish 'tickets', ->
        Docs.find
            type:'ticket'