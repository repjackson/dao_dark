if Meteor.isClient
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

if Meteor.isServer
    Meteor.methods
        change_username: (user_id, new_username)->
            Accounts.setUsername(user_id, new_username)
        