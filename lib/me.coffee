if Meteor.isClient
    Template.me.events
        'click .logout': -> Meteor.logout()
    
        'click .logout_others': ->
            Meteor.logoutOtherClients (err,res)->
                if err 
                    alert err
                else
                    console.log res
    
        'click .change_username': (e,t)->
            new_username = t.$('.new_username').val()
            if new_username
                if confirm "change username from #{Meteor.user().username} to #{new_username}?"
                    Meteor.call 'change_username', Meteor.userId(), new_username, (err,res)->
                        


if Meteor.isServer
    Meteor.methods
        change_username: (user_id, new_username)->
            Accounts.setUsername(user_id, new_username)
            