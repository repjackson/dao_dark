import { FlowRouter } from 'meteor/ostrio:flow-router-extra';



Template.add_button.events
    'click .add': ->
        Docs.insert
            type: @type

            
Template.remove_button.events
    'click .remove': ->
        if confirm "remove #{@type}?"
            Docs.remove @_id
            
            
            
    
Template.detect_fields_button.events
    'click .detect_fields': ->
        console.log @
        Meteor.call 'detect_fields', @_id
            
            
Template.voting.events
    'click .upvote': ->
        Docs.update @_id,
            $addToSet: upvoter_ids:Meteor.userId()
            $pull: downvoter_ids:Meteor.userId()
            $inc:points:1
        Meteor.users.update @author_id,
            $inc:karma:1
    'click .downvote': ->
        Docs.update @_id,
            $addToSet: downvoter_ids:Meteor.userId()
            $pull: upvoter_ids:Meteor.userId()
            $inc:points:-1
        Meteor.users.update @author_id,
            $inc:karma:-1
            
            
            
            
Template.bookmark_button.helpers
    bookmarkers: ->
        Meteor.users.find _id:$in:@bookmarker_ids
        
        
Template.bookmark_button.events
    'click .bookmark': ->
        Docs.update @_id,
            $addToSet: bookmarker_ids:Meteor.userId()
    
    
    