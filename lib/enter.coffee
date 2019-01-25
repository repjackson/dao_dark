import { FlowRouter } from 'meteor/ostrio:flow-router-extra';


if Meteor.isClient
    Template.enter.events
        'keyup .username': ->
            username = $('.username').val()
            Session.set 'username', username
            Meteor.call 'find_username', username, (err,res)->
                if res
                    Session.set 'enter_mode', 'login'
                else
                    Session.set 'enter_mode', 'register'
    
    
        'click .enter': (e,t)->
            username = $('.username').val()
            password = $('.password').val()
            if Session.equals 'enter_mode', 'register'
                if confirm "register #{username}?"
                    options = {
                        username:username
                        password:password
                        }
                    Accounts.createUser options, (err,res)->
                        Meteor.loginWithPassword username, password, (err,res)=>
                            if err 
                                if err.error is 403
                                    Session.set 'message', "#{username} not found"
                                    Session.set 'enter_mode', 'register'
                                    Session.set 'username', "#{username}"
                            else
                                Session.set 'page', 'delta'
            else
                Meteor.loginWithPassword username, password, (err,res)=>
                    if err 
                        if err.error is 403
                            Session.set 'message', "#{username} not found"
                            Session.set 'enter_mode', 'register'
                            Session.set 'username', "#{username}"
                    else
                        FlowRouter.go '/'
    
        'click .new_demo': (e,t)->
            Meteor.call 'new_demo_user', (err,res)->
                console.log 'res',res
                
                Meteor.loginWithPassword "#{res.username}", "#{res.username}", (err,res)=>
                    if err 
                        if err.error is 403
                            Session.set 'message', "#{username} not found"
                            Session.set 'enter_mode', 'register'
                            Session.set 'username', "#{username}"
                    else
                        FlowRouter.go '/'
    
            
    
    
    Template.enter.helpers
        username: -> Session.get 'username'
        
        registering: -> Session.equals 'enter_mode', 'register'
        
        enter_class: ->
            if Meteor.loggingIn() then 'loading disabled' else ''
        
        
if Meteor.isServer
    Meteor.methods
        find_username: (username)->
            res = Accounts.findUserByUsername(username)
            return res