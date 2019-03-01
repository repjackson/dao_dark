Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'
    loadingTemplate: 'splash'
    trackPageView: true



Router.route '/', -> @redirect '/t/goldrun/menu'

Router.route '/t/:tribe_slug/chat', -> @render 'view_chats'
Router.route '/t/:tribe_slug/add', -> @render 'add'
Router.route '/t/:tribe_slug/pages', -> @render 'pages'
Router.route '/t/:tribe_slug/menu', -> @render 'menu'
Router.route '/me', -> @render 'me'
# Router.route '/t/:tribe_slug/users', -> @render 'users'
Router.route '/t/:tribe_slug/inbox', -> @render 'inbox'
Router.route '/bank', -> @render 'bank'



# Router.route '/u/:username', -> @render 'user'
Router.route '/edit/:id', -> @render 'edit'
Router.route '/view/:id', -> @render 'view'
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
    ), name:'user_user_chat'

Router.route '/u/:username/gallery', (->
    @layout 'profile_layout'
    @render 'user_Gallery'
    ), name:'user_Gallery'

# Router.route '/u/:username/staff', (->
#     @layout 'profile_layout'
#     @render 'user_staff'
#     ), name:'user_staff'

Router.route '/u/:username/contact', (->
    @layout 'profile_layout'
    @render 'user_contact'
    ), name:'user_contact'

# Router.route '/u/:username/campaigns', (->
#     @layout 'profile_layout'
#     @render 'user_campaigns'
#     ), name:'user_campaigns'


Router.route '/u/:username/edit', -> @render 'user_edit'


Router.route '/t/:tribe_slug/p/:slug', -> @render 'page'

Router.route '/login', -> @render 'login'
Router.route '/register', -> @render 'register'
Router.route '/forgot-password', -> @render 'forgot-password'


Router.route '/t/:tribe_slug/add_resident', -> @render 'add_resident'
Router.route '/t/:tribe_slug/sign_waiver/:receipt_id', -> @render 'sign_waiver'
Router.route '/t/:tribe_slug/settings', -> @render 'settings'

Router.route '/t/:tribe_slug/users', -> @render 'people'




Router.route '/t/:tribe_slug/', (->
    @layout 'layout'
    @render 'menu'
    ), name:'home'

Router.route '/t/:tribe_slug/s/:type', (->
    @layout 'layout'
    @render 'delta'
    ), name:'tribe_delta'


# Router.route '/s/:type', -> @render 'delta'
Router.route '/t/:tribe_slug/s/:type/:_id/edit', -> @render 'type_edit'
Router.route '/t/:tribe_slug/s/:type/:_id/view', -> @render 'type_view'