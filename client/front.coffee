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
            'the brave are free'
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
        Session.set 'out_page', 'login'
        
Template.login.events
    'click .login': (e,t)->
        username = $('.username').val()
        password = $('.password').val()
        Meteor.loginWithPassword username, password, (err,res)->
            if err 
                alert err
            else console.log res


Template.login.helpers
    login_class: ->
        if Meteor.loggingIn() then 'loading disabled' else ''