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
Router.route '/healthclub', -> @render 'healthclub'


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
Router.route '/u/:username/s/:type', (->
    @layout 'profile_layout'
    @render 'user_section'
    ), name:'user_section'


Router.route '/u/:username/about', (->
    @layout 'profile_layout'
    @render 'user_about'
    ), name:'user_about'

Router.route '/u/:username', (->
    @layout 'profile_layout'
    @render 'user_about'
    ), name:'user_home'

Router.route '/u/:username/stripe', (->
    @layout 'profile_layout'
    @render 'user_stripe'
    ), name:'user_stripe'

Router.route '/u/:username/blog', (->
    @layout 'profile_layout'
    @render 'user_blog'
    ), name:'user_blog'

Router.route '/u/:username/events', (->
    @layout 'profile_layout'
    @render 'user_events'
    ), name:'user_events'

Router.route '/u/:username/tags', (->
    @layout 'profile_layout'
    @render 'user_tags'
    ), name:'user_tags'

Router.route '/u/:username/tasks', (->
    @layout 'profile_layout'
    @render 'user_tasks'
    ), name:'user_tasks'

Router.route '/u/:username/connections', (->
    @layout 'profile_layout'
    @render 'user_connections'
    ), name:'user_connections'


Router.route '/u/:username/messages', (->
    @layout 'profile_layout'
    @render 'user_messages'
    ), name:'user_messages'


Router.route '/u/:username/notifications', (->
    @layout 'profile_layout'
    @render 'user_notifications'
    ), name:'user_notifications'




Router.route '/u/:username/chat', (->
    @layout 'profile_layout'
    @render 'user_chat'
    ), name:'user_chat'

Router.route '/u/:username/gallery', (->
    @layout 'profile_layout'
    @render 'user_gallery'
    ), name:'user_gallery'

Router.route '/u/:username/contact', (->
    @layout 'profile_layout'
    @render 'user_contact'
    ), name:'user_contact'

# Router.route '/u/:username/campaigns', (->
#     @layout 'profile_layout'
#     @render 'user_campaigns'
#     ), name:'user_campaigns'


Router.route '/u/:username/edit', -> @render 'user_edit'


Router.route '/p/:slug', -> @render 'page'

Router.route '/login', -> @render 'login'
Router.route '/register', -> @render 'register'
Router.route '/forgot-password', -> @render 'forgot-password'


Router.route '/add_resident', -> @render 'add_resident'
Router.route '/sign_waiver/:receipt_id', -> @render 'sign_waiver'
Router.route '/settings', -> @render 'settings'

Router.route '/users', -> @render 'people'




Router.route '/', (->
    @layout 'layout'
    @render 'home'
    ), name:'home'

Router.route '/s/:type', (->
    @layout 'layout'
    @render 'delta'
    ), name:'tribe_delta'


# Router.route '/s/:type', -> @render 'delta'
Router.route '/s/:type/:_id/edit', -> @render 'type_edit'
Router.route '/s/:type/:_id/view', -> @render 'type_view'
