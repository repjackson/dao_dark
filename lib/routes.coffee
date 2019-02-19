Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'
    loadingTemplate: 'splash'
    trackPageView: true



Router.route '/', -> @redirect '/t/dao'

Router.route '/t/:tribe_slug/chat', -> @render 'view_chats'
Router.route '/t/:tribe_slug/add', -> @render 'add'
Router.route '/t/:tribe_slug/pages', -> @render 'pages'
Router.route '/t/:tribe_slug/schemas', -> @render 'schemas'
Router.route '/me', -> @render 'me'
Router.route '/users', -> @render 'users'
Router.route '/inbox', -> @render 'inbox'
Router.route '/bank', -> @render 'bank'
Router.route '/settings', -> @render 'settings'

Router.route '/t/:tribe_slug/users', -> @render 'people'



# Router.route '/u/:username', -> @render 'user'
Router.route '/edit/:id', -> @render 'edit'
Router.route '/view/:id', -> @render 'view'
Router.route '*', -> @render 'not_found'

# Router.route '/u/:_id/s/:type', -> @render 'profile_layout', 'user_section'
Router.route '/t/:tribe_slug/u/:_id/s/:type', (->
    @layout 'profile_layout'
    @render 'user_section'
    ), name:'user_section'


Router.route '/t/:tribe_slug/u/:_id/about', (->
    @layout 'profile_layout'
    @render 'user_about'
    ), name:'user_about'
    
Router.route '/t/:tribe_slug/u/:_id/stripe', (->
    @layout 'profile_layout'
    @render 'user_stripe'
    ), name:'user_stripe'

# Router.route '/t/:tribe_slug/u/:_id/blog', (->
#     @layout 'profile_layout'
#     @render 'user_blog'
#     ), name:'user_blog'

# Router.route '/t/:tribe_slug/u/:_id/events', (->
#     @layout 'profile_layout'
#     @render 'user_events'
#     ), name:'user_events'

Router.route '/t/:tribe_slug/u/:_id/chat', (->
    @layout 'profile_layout'
    @render 'user_chat'
    ), name:'user_user_chat'

# Router.route '/u/:_id/gallery', (->
#     @layout 'profile_layout'
#     @render 'user_Gallery'
#     ), name:'user_Gallery'

# Router.route '/u/:_id/staff', (->
#     @layout 'profile_layout'
#     @render 'user_staff'
#     ), name:'user_staff'

Router.route '/u/:_id/contact', (->
    @layout 'profile_layout'
    @render 'user_contact'
    ), name:'user_contact'

# Router.route '/u/:_id/campaigns', (->
#     @layout 'profile_layout'
#     @render 'user_campaigns'
#     ), name:'user_campaigns'


Router.route '/t/:tribe_slug/u/:_id/edit', -> @render 'user_edit'


Router.route '/t:tribe_slug/p/:slug', -> @render 'page'

Router.route '/signin', -> @render 'signin'
Router.route '/register', -> @render 'register'
Router.route '/forgot-password', -> @render 'forgot-password'




Router.route '/t/:tribe_slug/', (->
    @layout 'layout'
    @render 'home'
    ), name:'home'

Router.route '/t/:tribe_slug/s/:type', (->
    @layout 'layout'
    @render 'delta'
    ), name:'tribe_delta'


# Router.route '/s/:type', -> @render 'delta'
Router.route '/t/:tribe_slug/s/:type/:_id/edit', -> @render 'type_edit'
Router.route '/t/:tribe_slug/s/:type/:_id/view', -> @render 'type_view'