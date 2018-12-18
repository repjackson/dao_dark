Template.nav.events
    'click .me': ->
        history.pushState({}, '', 'me')
        Meteor.users.update Meteor.userId(),
            $set:current_page:'me'
            
    'click .home': ->
        history.pushState({}, '', 'home')
        Meteor.users.update Meteor.userId(),
            $set:current_page:'delta'
            
    'click .reddit': ->
        history.pushState({}, '', 'reddit')
        Meteor.users.update Meteor.userId(),
            $set:current_page:'delta'
            
    'click .tasks': ->
        history.pushState({}, '', 'tasks')
        Meteor.users.update Meteor.userId(),
            $set:current_page:'tasks'
            
    'click .library': ->
        history.pushState({}, '', 'library')
        Meteor.users.update Meteor.userId(),
            $set:current_page:'library'
            
    'click .time': ->
        history.pushState({}, '', 'time')
        Meteor.users.update Meteor.userId(),
            $set:current_page:'time'
            
    'click .chat': ->
        history.pushState({}, '', 'chat')
        Meteor.users.update Meteor.userId(),
            $set:current_page:'conversations'
    
    'click .users': ->
        history.pushState({}, '', 'users')
        Meteor.users.update Meteor.userId(),
            $set:current_page:'users'
            
    'click .mail': ->
        history.pushState({}, '', 'mail')
        Meteor.users.update Meteor.userId(),
            $set:current_page:'mail'
            
    'click .school': ->
        history.pushState({}, '', 'school')
        Meteor.users.update Meteor.userId(),
            $set:current_page:'school'
            
    # 'click .blog': ->
    #     history.pushState({}, '', 'blog')
    #     Meteor.users.update Meteor.userId(),
    #         $set:current_page:'blog'
            
    'click .test': ->
        history.pushState({}, '', "bar.html");

            
            
    'click .bookmarks': ->
        Meteor.users.update Meteor.userId(),
            $set:current_page:'bookmarks'
            
    'click .logout': -> Meteor.logout()
            
            