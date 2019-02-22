@Docs = new Meteor.Collection 'docs'
@Tags = new Meteor.Collection 'tags'


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

    parent_doc: ->
        Docs.findOne
            _id:@parent_id

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


Meteor.users.helpers
    name: -> 
        if @profile?.first_name and @profile?.last_name
            "#{@profile.first_name}  #{@profile.last_name}"
        else
            "#{@username}"
    last_login: -> moment(@status?.lastLogin.date).fromNow()

    users_customer: ->
        # console.log @
        found = Docs.findOne
            type:'customer'
            "ev.ID": @profile.customer_jpid
        # console.log found
        found
        
        
    email: -> 
        if @emails
            @emails[0].address





Meteor.methods
    create_account: (options) ->
        #console.log("options = ", options)
        # uname = options.profile.name
        id = Accounts.createUser(options)
        # if id
        #     Roles.addUsersToRoles id, 'user'
        #     Meteor.users.update id, $set: 'profile.name': uname
        #     if titheData
        #         Meteor.call 'updateTitheuserID', titheData.tithe, userID: id
        #         tithe = Tithes.findOne(titheData.tithe)
        #         source = tithe.data.source
        #         cardObj = 
        #             cardid: source.id
        #             user: id
        #             exp_month: source.exp_month
        #             exp_year: source.exp_year
        #             last4: source.last4
        #         Meteor.call 'addMyCards', cardObj
        #     userInfo = 
        #         email: options.email
        #         name: uname
        #     Meteor.call 'sendGiverEmail', userInfo
        #     Meteor.call 'STRIPE_create_customer', id, 'email'
        #     text = 'Welcome to Joyful Giver ' + uname + ', \n' + 'As a registered donor, you can save your favorite organizations, see past gifts/receipts, setup repeat giving, print reports and securely save card info for future use.'
        #     Meteor.call 'SMS_SEND', options.profile.phone, text
        return





    add_facet_filter: (delta_id, key, filter, tribe)->
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
        
        Meteor.call 'fum', delta_id, tribe, (err,res)->
            
            
    remove_facet_filter: (delta_id, key, filter, tribe)->
        if key is '_keys'
            Docs.update { _id:delta_id },
                $pull:facets: {key:filter}
        Docs.update { _id:delta_id, "facets.key":key},
            $pull: "facets.$.filters": filter
        Meteor.call 'fum', delta_id, tribe, (err,res)->

    rename_key:(old_key,new_key,parent)->
        Docs.update parent._id,
            $pull:_keys:old_key
        Docs.update parent._id,
            $addToSet:_keys:new_key
        Docs.update parent._id,
            $rename: 
                "#{old_key}": new_key
                "_#{old_key}": "_#{new_key}"
