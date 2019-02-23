# Template.login.events 
#     'submit #loginForm': (e, t) ->
#         username = e.target.username.value.toLowerCase()
#         password = e.target.password.value
#         Meteor.loginWithPassword username, password, (err) ->
#             if err
#                 #  hideLoadingMask();
#                 e.target.username.value = username
#                 e.target.password.value = password
#                 toastr.error err.reason
#             else
#                 if Meteor.user() and Meteor.user().profile.isActive
#                     if Meteor.user().roles
#                         document.cookie = 'loggedinEmailId=' + username
#                         toastr.success 'You are logged in', ''
#                         Router.go '/dashboard'
#                     else
#                         Router.go '/select-role'
#                 else
#                     document.cookie = 'loggedinEmailId=; expires=' + new Date + ';'
#                     Meteor.logout()
#                     toastr.error 'Your account suspended please contact Joyful giver admin on info@joyful-giver.com'
#             return
#         false



Template.login.events
    'submit #login': (e, t) ->
        username = e.target.username.value.toLowerCase()
        password = e.target.password.value
        Meteor.loginWithPassword username, password, (err) ->
            if err
                #  hideLoadingMask();
                e.target.username.value = username
                e.target.password.value = password
                # toastr.error err.reason
            else
                Router.go "/t/goldrun"
                # if Meteor.user() and Meteor.user().profile.isActive
                #     if Meteor.user().roles
                #         document.cookie = 'loggedinEmailId=' + username
                #         Router.go '/dashboard'
                #     else
                #         Router.go '/select-role'
                # else
                #     document.cookie = 'loggedinEmailId=; expires=' + new Date + ';'
                #     Meteor.logout()
                #     toastr.error 'Your account suspended please contact Joyful giver admin on info@joyful-giver.com'
        false



Template.login.helpers
    enter_class: ->
        if Meteor.loggingIn() then 'loading disabled' else ''

    login_class: ->
        if Meteor.loggingIn() then 'disabled' else ''




# Template.login.onRendered ->
#     $('body').addClass 'landing-page'
#     $('body').scrollspy
#         target: '.navbar-fixed-top'
#         offset: 80
#     Meta.setTitle 'Log In - Joyful giver'
#     Meta.set 'og:title', 'Log In - Joyful giver'
#     return






Template.forgot_password.onRendered ->
    # $('body').addClass 'landing-page'
    # $('body').scrollspy
    #     target: '.navbar-fixed-top'
    #     offset: 80
    # Meta.setTitle 'Forgot Password - Joyful Giver'
    # Meta.set 'og:title', 'Forgot Password - Joyful Giver'
    # return
Template.forgot_password.events 'submit #forgotPasswordForm': (e, t) ->
    e.preventDefault()
    username = e.target.username.value.toLowerCase()
    Meteor.call 'checkChurchUser', username, (err, res) ->
        if res.statusCode
            Accounts.forgotPassword { email: username }, (error) ->
                if error
                    e.target.username.value = username
                    # FlashMessages.sendError(err.reason);
                    toastr.error error.reason
                else
                    # FlashMessages.sendSuccess('Check your email and click the reset password link.');
                    toastr.success 'Check your email and click the reset password link.'
                return
        else
            toastr.error res.msg
        return
    false





Template.reset_password.onRendered ->
	$('body').addClass 'landing-page'
	$('body').scrollspy
		target: '.navbar-fixed-top'
		offset: 80
	return
Template.reset_password.onCreated ->
	if Accounts._resetPasswordToken
		Session.set 'resetPassword', Accounts._resetPasswordToken
	return
Template.reset_password.helpers resetPassword: ->
	Session.get 'resetPassword'
Template.reset_password.events
	'submit #resetPasswordForm': (e, t) ->
		e.preventDefault()
		resetPasswordForm = $(e.currentTarget)
		password = resetPasswordForm.find('#resetPasswordPassword').val()
		passwordConfirm = resetPasswordForm.find('#resetPasswordPasswordConfirm').val()
		if password and password == passwordConfirm
			Accounts.resetPassword Session.get('resetPassword'), password, (err) ->
				if err
					FlashMessages.sendError err.reason
					console.log 'We are sorry but something went wrong.'
				else
					FlashMessages.sendSuccess 'Your password has been changed. Welcome back!'
					console.log 'Your password has been changed. Welcome back!'
					Session.set 'resetPassword', null
					Router.go '/'
				return
		else
			FlashMessages.sendError 'Both Passwords are not match.'
		false
	'click .gotologin': (e, t) ->
		Router.go 'UserLogin'
		return




Template.selectRole.events 'click .roleSelect': (e, t) ->
	role = $(e.currentTarget).attr('data-role')
	bootbox.confirm 'Are you sure! you want select role ' + role, (result) ->
		if result
			Meteor.call 'selectRole', role, (err, data) ->
				toastr.success 'You are logged in', ''
				Router.go '/dashboard'
				return
		return
	return




Template.reset_password.onRendered ->
	$('body').addClass 'landing-page'
	$('body').scrollspy
		target: '.navbar-fixed-top'
		offset: 80
	return
Template.reset_password.onCreated ->
	if Accounts._resetPasswordToken
		Session.set 'resetPassword', Accounts._resetPasswordToken
	return
Template.reset_password.helpers 
    resetPassword: ->
    	Session.get 'resetPassword'
Template.reset_password.events
	'submit #resetPasswordForm': (e, t) ->
		e.preventDefault()
		resetPasswordForm = $(e.currentTarget)
		password = resetPasswordForm.find('#resetPasswordPassword').val()
		passwordConfirm = resetPasswordForm.find('#resetPasswordPasswordConfirm').val()
		if password and password == passwordConfirm
			Accounts.resetPassword Session.get('resetPassword'), password, (err) ->
				if err
					FlashMessages.sendError err.reason
					console.log 'We are sorry but something went wrong.'
				else
					FlashMessages.sendSuccess 'Your password has been changed. Welcome back!'
					console.log 'Your password has been changed. Welcome back!'
					Session.set 'resetPassword', null
					Router.go '/'
				return
		else
			FlashMessages.sendError 'Both Passwords are not match.'
		false
	'click .gotologin': (e, t) ->
		Router.go 'UserLogin'
		return
