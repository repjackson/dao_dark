if Meteor.isClient
    Template.people.onCreated ->
        # @autorun -> Meteor.subscribe 'people'
        @autorun -> Meteor.subscribe 'user_tags', selected_tags.array(), 'user'
        @autorun -> Meteor.subscribe 'facet_users', selected_tags.array(), 'user'
    
    Template.people.helpers
        people: ->
            # Meteor.users.find { _id:$ne:Meteor.userId() }
            Meteor.users.find { }
   
        selected_tags: -> selected_tags.list()

        global_tags: ->
            doc_count = Docs.find().count()
            if 0 < doc_count < 3 then Tags.find { count: $lt: doc_count } else Tags.find()


    Template.people.events
        'click .select_tag': -> selected_tags.push @name
        'click .unselect_tag': -> selected_tags.remove @valueOf()
        'click #clear_tags': -> selected_tags.clear()
   
            
                    
        


                    
    # Template.toggle_friend.helpers
    #     is_friend: ->
    #         Meteor.user().friend_ids and @_id in Meteor.user().friend_ids
            
    #     toggle_friend_class: ->
    #         if Meteor.user().friend_ids and @_id in Meteor.user().friend_ids then 'blue' else 'basic'
            
            
    # Template.toggle_friend.events
    #     'click .toggle_friend': (e,t)->
    #         e.preventDefault()
    #         if Meteor.user().friend_ids and @_id in Meteor.user().friend_ids
    #             Meteor.users.update Meteor.userId(),
    #                 $pull: friend_ids:@_id
    #         else
    #             Meteor.users.update Meteor.userId(),
    #                 $addToSet: friend_ids:@_id
    #         t.$('.toggle_friend').transition('pulse')
            

        
        
if Meteor.isServer
    Meteor.publish 'users', ->
        Meteor.users.find {}
            # "profile.name": $ne:null    