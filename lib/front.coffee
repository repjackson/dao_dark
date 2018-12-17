if Meteor.isClient
    Template.front.helpers
        subtext: ->
            messages = [
                'liberty or death'
                'decentralized autonomous organization'
                'Only time can heal what reason cannot'
                'dont tread on me'
                'its always half'
                'country roads take me home'
                'the way'
                'its not who you are'
                'only the brave are free'
                'No one was ever wise by chance'
                'All cruelty springs from weakness'
                'ignorance is the cause of fear'
                'Difficulties strengthen the mind as labor does the body'
                'We suffer more in imagination than reality'
                'no wind is favorable to an unknown port'
                'what if i need you in my darkest hour'
                'They lose day expecting night and night expecting day'
                ]
            rand = messages[Math.floor(Math.random() * messages.length)]
    
    
    
    Template.front.events
        'click .big':->
            Session.set 'out_page', 'enter'
            
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
