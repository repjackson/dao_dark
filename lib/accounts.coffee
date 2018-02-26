FlowRouter.route '/privacy', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'privacy'

FlowRouter.route '/terms-of-use', action: (params) ->
    BlazeLayout.render 'layout',
        main: 'terms-of-use'

# Accounts.onLogin ->
#     redirect = Session.get ‘redirectAfterLogin’
#     if redirect?
#         unless redirect is '/login'
#     FlowRouter.go redirect



if Meteor.isDevelopment
    AccountsTemplates.configure
        sendVerificationEmail: false
        enforceEmailVerification: false

if Meteor.isProduction
    AccountsTemplates.configure
        sendVerificationEmail: true
        enforceEmailVerification: false

AccountsTemplates.configure
    defaultLayout: 'layout'
    # defaultLayoutRegions:
        # nav: ''
    defaultContentRegion: 'main'
    showForgotPasswordLink: true
    overrideLoginErrors: true
    enablePasswordChange: true

    # Appearance
    showAddRemoveServices: true
    showForgotPasswordLink: true
    showLabels: true
    showPlaceholders: false
    showResendVerificationEmailLink: true


    confirmPassword: true
    continuousValidation: true
    #displayFormLabels: true
    #forbidClientAccountCreation: true
    # formValidationFeedback: true

    negativeValidation: true
    positiveValidation: true
    negativeFeedback: true
    positiveFeedback: true

    # Privacy Policy and Terms of Use
    # privacyUrl: 'privacy'
    termsUrl: 'terms-of-use'

pwd = AccountsTemplates.removeField('password')
AccountsTemplates.removeField 'email'
AccountsTemplates.addFields [
    # {
    #     _id: 'first_name'
    #     type: 'text'
    #     displayName: 'First Name'
    #     required: true
    #     minLength: 3
    # }
    # {
    #     _id: 'last_name'
    #     type: 'text'
    #     displayName: 'Last Name'
    #     required: true
    #     minLength: 3
    # }
    # {
    #     _id: 'location'
    #     type: 'text'
    #     displayName: 'Location'
    #     required: false
    #     minLength: 3
    # }
    {
        _id: 'username'
        type: 'text'
        displayName: 'username'
        required: true
        minLength: 3
    }
    {
        _id: 'email'
        type: 'email'
        required: false
        displayName: 'email'
        re: /.+@(.+){2,}\.(.+){2,}/
        errStr: 'Invalid email'
    }
    {
        _id: 'username_and_email'
        type: 'text'
        required: false
        displayName: 'Login (username or email)'
    }
    pwd
]


AccountsTemplates.configureRoute 'changePwd'
AccountsTemplates.configureRoute 'forgotPwd'

AccountsTemplates.configureRoute 'resetPwd'


AccountsTemplates.configureRoute('signIn', {
  redirect: '/',
});

AccountsTemplates.configureRoute('signUp', {
  redirect: '/profile/edit',
});


AccountsTemplates.configureRoute 'verifyEmail'



# orig_updateOrCreateUserFromExternalService = Accounts.updateOrCreateUserFromExternalService

# Accounts.updateOrCreateUserFromExternalService = (serviceName, serviceData, options) ->
#     loggedInUser = Meteor.user()
#     if loggedInUser and typeof loggedInUser.services[serviceName] == 'undefined'
#         setAttr = {}
#         setAttr['services.' + serviceName] = serviceData
#         Meteor.users.update loggedInUser._id, $set: setAttr
#     orig_updateOrCreateUserFromExternalService.apply this, arguments
