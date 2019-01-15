import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

Template.settings.events
    'click .logout': -> Meteor.logout()

    'click .logout_others': ->
        Meteor.logoutOtherClients (err,res)-> if err then alert err else console.log res

    'click .change_username': (e,t)->
        new_username = t.$('.new_username').val()
        if new_username
            if confirm "change username from #{Meteor.user().username} to #{new_username}?"
                Meteor.call 'change_username', Meteor.userId(), new_username, (err,res)->
                    
    'click .change_password': (e,t)->
        old_password = t.$('.old_password').val()
        new_password = t.$('.new_password').val()
        if new_password and old_password
            if confirm "change password from #{Meteor.user().password} to #{new_password}?"
                Accounts.changePassword old_password, new_password, (err,res)->
                    if err then alert err else console.log res
                    
Template.edit_user_field.helpers
    user_field_val: ->
        user = Meteor.user()
        if user
            user["#{@key}"]
    
Template.edit_user_field.events
    'keyup .user_field_val': (e,t)->
        if e.which is 13
            new_val = t.$('.user_field_val').val()
            if new_val
                Meteor.users.update Meteor.userId(),
                    $set:"#{@key}": new_val