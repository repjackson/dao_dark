@Docs = new Meteor.Collection 'docs'
@Tags = new Meteor.Collection 'tags'

Router.configure
	layoutTemplate: 'layout'
	notFoundTemplate: 'not_found'
	trackPageView: true


Router.route '/', -> @render 'delta'
Router.route '/login', -> @render 'login'
Router.route '/register', -> @render 'register'
