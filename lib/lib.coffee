@Docs = new Meteor.Collection 'docs'


Docs.before.insert (userId, doc)=>
    timestamp = Date.now()
    doc.timestamp = timestamp
    doc.timestamp_long = moment(timestamp).format("dddd, MMMM Do YYYY, h:mm:ss a")
    date = moment(timestamp).format('Do')
    weekdaynum = moment(timestamp).isoWeekday()
    weekday = moment().isoWeekday(weekdaynum).format('dddd')


    month = moment(timestamp).format('MMMM')
    year = moment(timestamp).format('YYYY')

    date_array = [weekday, month, date, year]
    if _
        date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
    doc.timestamp_tags = date_array

    doc.author_id = Meteor.userId()
    return
    
    
    
# Docs.after.update ((userId, doc, fieldNames, modifier, options) ->
#     if doc.tags
#         doc._tag_count = doc.tags.length
#     # console.log doc
#     # doc.child_count = Meteor.call('calculate_child_count', doc._id)
#     # console.log Meteor.call 'calculate_child_count', doc._id, (err, res)-> return res
# ), fetchPrevious: true


Meteor.methods
    set_page: (page, data)->
        Meteor.users.update Meteor.userId(),
            $set: 
                page:page
                page_data:data
        # Session.set 'page', page
        # Session.set 'page_data', data
    
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


if Meteor.isClient
    Template.enter.events
        'keyup .username': ->
            username = $('.username').val()
            Session.set 'username', username
            Meteor.call 'find_username', username, (err,res)->
                if res
                    Session.set 'enter_mode', 'login'
                else
                    Session.set 'enter_mode', 'register'
    
    
        'click .enter': (e,t)->
            username = $('.username').val()
            password = $('.password').val()
            if Session.equals 'enter_mode', 'register'
                if confirm "register #{username}?"
                    options = {
                        username:username
                        password:password
                        }
                    Accounts.createUser options, (err,res)->
                        Meteor.loginWithPassword username, password, (err,res)=>
                            if err 
                                if err.error is 403
                                    Session.set 'message', "#{username} not found"
                                    Session.set 'enter_mode', 'register'
                                    Session.set 'username', "#{username}"
                            else
                                Session.set 'page', 'delta'
            else
                Meteor.loginWithPassword username, password, (err,res)=>
                    if err 
                        if err.error is 403
                            Session.set 'message', "#{username} not found"
                            Session.set 'enter_mode', 'register'
                            Session.set 'username', "#{username}"
                    else
                        Session.set 'page', 'delta'
    
    
            
    
    
    Template.enter.helpers
        username: -> Session.get 'username'
        registering: -> Session.equals 'enter_mode', 'register'
        enter_class: ->
            if Meteor.loggingIn() then 'loading disabled' else ''
        
        
if Meteor.isServer
    Meteor.methods
        find_username: (username)->
            res = Accounts.findUserByUsername(username)
            return res
