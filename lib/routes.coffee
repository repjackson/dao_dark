Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'
    loadingTemplate: 'splash'
    trackPageView: true



# Router.route '/', -> @redirect '/t/goldrun/menu'

Router.route '/chat', -> @render 'view_chats'
Router.route '/add', -> @render 'add'
Router.route '/pages', -> @render 'pages'
Router.route '/menu', -> @render 'menu'
Router.route '/me', -> @render 'me'
# Router.route '/users', -> @render 'users'
Router.route '/inbox', -> @render 'inbox'
Router.route '/bank', -> @render 'bank'
Router.route '/checkin', -> @render 'checkin'


Router.route('enroll', {
    path: '/enroll-account/:token'
    template: 'reset_password'
    onBeforeAction: ()=>
        Meteor.logout()
        Session.set('_resetPasswordToken', this.params.token)
        @subscribe('enrolledUser', this.params.token).wait()
})



# Router.route '/u/:username', -> @render 'user'
Router.route '/edit/:_id', -> @render 'edit'
Router.route '/view/:_id', -> @render 'view'
Router.route '*', -> @render 'not_found'

# Router.route '/u/:username/s/:type', -> @render 'profile_layout', 'user_section'


Router.route '/add_resident', (->
    @layout 'nonav'
    @render 'add_resident'
    ), name:'add_resident'


# Router.route '/u/:username/campaigns', (->
#     @layout 'profile_layout'
#     @render 'user_campaigns'
#     ), name:'user_campaigns'


Router.route '/u/:username/edit', -> @render 'user_edit'


Router.route '/p/:slug', -> @render 'page'

Router.route '/login', -> @render 'login'
Router.route '/register', -> @render 'register'
Router.route '/forgot-password', -> @render 'forgot-password'


Router.route '/sign_waiver/:receipt_id', -> @render 'sign_waiver'
Router.route '/settings', -> @render 'settings'

Router.route '/users', -> @render 'people'


Router.route '/', (->
    @layout 'layout'
    @render 'alpha'
    ), name:'alpha'



Router.route '/s/:type', (->
    @layout 'layout'
    @render 'delta'
    ), name:'delta'

Router.route '/s/:type/:_id/edit', -> @render 'type_edit'
Router.route '/s/:type/:_id/view', -> @render 'type_view'
