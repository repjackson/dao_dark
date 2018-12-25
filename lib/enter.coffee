import { FlowRouter } from 'meteor/ostrio:flow-router-extra'

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
            Meteor.loginWithPassword username, password, (err,res)=>
                if err 
                    if err.error is 403
                        Session.set 'message', "#{username} not found"
                        Session.set 'enter_mode', 'register'
                        Session.set 'username', "#{username}"
                else
                    FlowRouter.go('/')
    
    
    Template.enter.helpers
        message: ->
            Session.get 'message'
        
        username: -> Session.get 'username'
        
        registering: -> Session.equals 'enter_mode', 'register'
        
        enter_class: ->
            if Meteor.loggingIn() then 'loading disabled' else ''
        
        
if Meteor.isServer
    Meteor.methods
        find_username: (username)->
            res = Accounts.findUserByUsername(username)
            return res
