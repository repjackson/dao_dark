if Meteor.isClient
    FlowRouter.route '/tickets',
        name:'tickets'
        action: ->
            BlazeLayout.render 'layout',
                main: 'tickets'
    
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
    
        'click .edit': (e,t)-> t.editing.set true
        'click .save': (e,t)-> t.editing.set false
    
    Template.ticket_card.helpers
        editing: -> Template.instance().editing.get()
    
    Template.tickets.events
        'click .add_ticket': ->
            Docs.insert
                type:'ticket'
    
    
    Template.tickets.helpers
        tickets: -> Docs.find type:'ticket'
        
        editing: -> Template.instance().editing.get()
        
if Meteor.isServer
    Meteor.publish 'tickets', ->
        Docs.find
            type:'ticket'