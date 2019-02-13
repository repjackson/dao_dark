Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'not_found'
    loadingTemplate: 'splash'
    trackPageView: true


Router.route '/delta', -> @render 'delta'

Router.route '/', -> @render 'delta'

Router.route '/enter', -> @render 'enter'
Router.route '/me', -> @render 'me'
Router.route '/users', -> @render 'users'
Router.route '/inbox', -> @render 'inbox'
Router.route '/bank', -> @render 'bank'
Router.route '/settings', -> @render 'settings'

Router.route '/people', -> @render 'people'



# Router.route '/u/:username', -> @render 'user'
Router.route '/edit/:id', -> @render 'edit'
Router.route '/view/:id', -> @render 'view'
Router.route '*', -> @render 'not_found'

# Router.route '/u/:_id/s/:type', -> @render 'profile_layout', 'user_section'
Router.route '/u/:_id/s/:type', (->
    @layout 'profile_layout'
    @render 'user_section'
    ), name:'user_section'


Router.route '/u/:_id/about', (->
    @layout 'profile_layout'
    @render 'user_about'
    ), name:'user_about'
    
Router.route '/u/:_id/stripe', (->
    @layout 'profile_layout'
    @render 'user_stripe'
    ), name:'user_stripe'

# Router.route '/u/:_id/blog', (->
#     @layout 'profile_layout'
#     @render 'user_blog'
#     ), name:'user_blog'

# Router.route '/u/:_id/events', (->
#     @layout 'profile_layout'
#     @render 'user_events'
#     ), name:'user_events'

Router.route '/u/:_id/chat', (->
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


Router.route '/u/:_id/edit', -> @render 'user_edit'

Router.route '/s/:type', -> @render 'type'
Router.route '/s/:type/:_id/edit', -> @render 'type_edit'
Router.route '/s/:type/:_id/view', -> @render 'type_view'

Router.route '/p/:slug', -> @render 'page'

@Docs = new Meteor.Collection 'docs'
@Tags = new Meteor.Collection 'tags'
@Types = new Meteor.Collection 'types'


Docs.before.insert (userId, doc)=>
    timestamp = Date.now()
    doc._timestamp = timestamp
    doc._timestamp_long = moment(timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")
    date = moment(timestamp).format('Do')
    weekdaynum = moment(timestamp).isoWeekday()
    weekday = moment().isoWeekday(weekdaynum).format('dddd')

    month = moment(timestamp).format('MMMM')
    year = moment(timestamp).format('YYYY')

    date_array = [weekday, month, date, year]
    if _
        date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
    # date_array = _.each(date_array, (el)-> console.log(typeof el))
    # console.log date_array
        doc._timestamp_tags = date_array

    doc._author_id = Meteor.userId()
    doc._author_username = Meteor.user().username
    return


Docs.helpers
    author: -> Meteor.users.findOne @_author_id
    when: -> moment(@_timestamp).fromNow()
    is_author: -> Meteor.userId() is @_author_id

    downvoters: ->
        Meteor.users.find
            _id: $in: @downvoter_ids
    upvoters: ->
        Meteor.users.find
            _id: $in: @upvoters_ids

    schema: ->
        Docs.findOne
            type:'schema'
            slug:@type

Meteor.methods
    add_facet_filter: (delta_id, key, filter)->
        if key is '_keys'
            new_facet_ob = {
                key:filter
                filters:[]
                res:[]
            }
            Docs.update { _id:delta_id },
                $addToSet: facets: new_facet_ob
        Docs.update { _id:delta_id, "facets.key":key},
            $addToSet: "facets.$.filters": filter
        
        Meteor.call 'fum', delta_id, (err,res)->
            
            
    remove_facet_filter: (delta_id, key, filter)->
        if key is '_keys'
            Docs.update { _id:delta_id },
                $pull:facets: {key:filter}
        Docs.update { _id:delta_id, "facets.key":key},
            $pull: "facets.$.filters": filter
        Meteor.call 'fum', delta_id, (err,res)->

    rename_key:(old_key,new_key,parent)->
        Docs.update parent._id,
            $pull:_keys:old_key
        Docs.update parent._id,
            $addToSet:_keys:new_key
        Docs.update parent._id,
            $rename: 
                "#{old_key}": new_key
                "_#{old_key}": "_#{new_key}"
