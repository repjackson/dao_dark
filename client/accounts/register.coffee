# Template.register.helpers({
#     'titheData': function(){
#         if(Session.get('signupTithe')){
#             Meteor.subscribe('oneTithe',Session.get('signupTithe'))
#         }
#     }
# })
Template.register.events
    'click #register': (e, t) ->
        # $('#loginForm').data('bootstrapValidator').validate()
        # if $('#loginForm').data('bootstrapValidator').isValid()
        #     showLoadingMask()
        #     profile = 
        #         name: $('#lname').val()
        #         tour: false
        #         isActive: true
            # if $('#phone').val()
            #     profile.phone = Phoneformat.formatE164('US', $('#phone').val())
        options = 
            # email: $('#lemail').val().toLowerCase()
            password: $('#password').val()
            # profile: profile
            username: $('#username').val()
            # name: $('#lname').val()
            #console.log("options = ", options) 
            # if Session.get('signupTithe')
            #     titheData = tithe: Session.get('signupTithe')
            # else
            #     titheData = false
        Meteor.call 'create_account', options, (error) ->
            # hideLoadingMask()
            if error
                # $('#signupError').html('<p>'+error.reason+'</p>').fadeIn();
                alert error.reason
            else
                Meteor.loginWithPassword $('#username').val().toLowerCase(), $('#password').val(), ->
                    # if Meteor.user() and Meteor.user().emails[0]
                        # document.cookie = 'loggedinEmailId=' + Meteor.user().emails[0].address
                    Router.go "/u/#{Meteor.userId()}/about"

    'click #tosModal': (e, t) ->
        e.preventDefault()
        $('#tosModalpopup').modal 'show'

    'click #privacyPolicyModal': (e, t) ->
        e.preventDefault()
        $('#privacyPolicyDisplayModal').modal 'show'


# Template.register.rendered = ->
#     $('#loginForm').bootstrapValidator
#         message: 'This value is not valid'
#         feedbackIcons:
#             valid: 'glyphicon glyphicon-ok'
#             invalid: 'glyphicon glyphicon-remove'
#             validating: 'glyphicon glyphicon-refresh'
#         fields:
#             name:
#                 message: 'You must provide an account holder firstname.'
#                 validators: notEmpty: message: 'First Name is mandatory'
#             email:
#                 message: 'You must provide an email.'
#                 validators:
#                     notEmpty: message: 'Email is mandatory'
#                     emailAddress: message: 'The value is not a valid email address'
#             phone: validators: phone:
#                 country: 'US'
#                 message: 'The value is not valid US phone number'
#             password:
#                 message: 'You must provide a password.'
#                 validators: notEmpty: message: 'Password is mandatory'
#     Meta.setTitle 'Sign Up donor- Joyful giver'
#     Meta.set 'og:title', 'Sign Up donor- Joyful giver'
#     return
