Template.profile_layout.onCreated ->
    @autorun -> Meteor.subscribe 'user_from_username', Router.current().params.username
    @autorun -> Meteor.subscribe 'user_schemas', Router.current().params.username
    
Template.user_section.helpers
    user_section_template: ->
        "user_#{Router.current().params.group}"
    
Template.profile_layout.helpers
    user: ->
        Meteor.users.findOne 'username': Router.current().params.username
    
    user_schemas: ->
        user = Meteor.users.findOne Router.current().params.username
        Docs.find
            type:'schema'
            _id:$in:user.schema_ids

    
    
#     # titheTotalGive: ->
#     #     tithesList = Tithes.find({}).fetch()
#     #     totalGive = 0
#     #     tithesList.forEach (d, i) ->
#     #         totalGive += d.amount
#     #         return
#     #     if totalGive
#     #         totalGive = totalGive / 100
#     #     parseInt totalGive
    
#     # TotalDonation: ->
#     #     tithesList = Tithes.find({}).fetch()
#     #     if tithesList then tithesList.length else 0
    
#     # codeDetail: ->
#     #     tithesList = Tithes.find({}, sort: 'date': -1).fetch()
#     #     codeDetail = []
#     #     tithesList.forEach (d, i) ->
#     #         churchCodeDet = {}
#     #         if d.churchCODE
#     #             churchCodeDet = ChurchCodes.findOne('code': d.churchCODE)
#     #         else
#     #             churchDet = Meteor.users.findOne('_id': d.church)
#     #             churchCodeDet['campaign'] = churchDet.profile.churchName
#     #             churchCodeDet['customPage.header_image'] = churchDet.profile.profilePic
#     #             churchCodeDet['code'] = 'churchDetail/' + churchDet._id
#     #         churchCodeDet['date'] = moment(d.date, 'X').fromNow()
#     #         churchCodeDet['giveAmount'] = d.amount / 100
#     #         codeDetail.push churchCodeDet
#     #         return
#     #     codeDetail



Template.profile_layout.events
    'click .set_delta_schema': ->
        console.log @
        Meteor.call 'set_delta_facets', @slug, Session.get('delta_id'), Router.current().params.username

    'click .logout': ->
        Meteor.logout()
        Router.go '/signin'


Template.user_array_element_toggle.helpers
    user_array_element_toggle_class: ->
        # user = Meteor.users.findOne Router.current().params.username
        if @value in @user["#{@key}"] then 'blue' else ''
        
        
Template.user_array_element_toggle.events
    'click .toggle_element': (e,t)->
        # console.log @
        # user = Meteor.users.findOne Router.current().params.username
        if @user["#{@key}"]
            if @value in @user["#{@key}"]
                Meteor.users.update @user._id,
                    $pull: "#{@key}":@value
            else
                Meteor.users.update @user._id,
                    $addToSet: "#{@key}":@value
        else
            Meteor.users.update @user._id,
                $addToSet: "#{@key}":@value
     
     
Template.site_switcher.onCreated ->
    @autorun => Meteor.subscribe 'user_sites', Router.current().params.username
        
Template.user_array_list.helpers
    users: ->
        users = []
        if @user["#{@array}"]
            for user_id in @user["#{@array}"]
                user = Meteor.users.findOne user_id
                users.push user
            users
            
            
    
    
     
     
     
# Template.follow_user.events
#     'click .toggle_follow_user': ->
#         if @followed_by_ids and Meteor.userId() in @followed_by_ids        
#             Meteor.users.update @_id,
#                 $pull: followed_by_ids:Meteor.userId()
#             Meteor.users.update Meteor.userId(),
#                 $pull: following_ids: @_id
#         else 
#             Meteor.users.update @_id,
#                 $addToSet: followed_by_ids:Meteor.userId()
#             Meteor.users.update Meteor.userId(),
#                 $addToSet: following_ids: @_id
        
Template.user_array_list.onCreated ->
    @autorun => Meteor.subscribe 'user_array_list', @data.user, @data.array
        
Template.user_array_list.helpers
    users: ->
        users = []
        if @user["#{@array}"]
            for user_id in @user["#{@array}"]
                user = Meteor.users.findOne user_id
                users.push user
            users
            
            
            
Template.user_tags.events
    'keyup .tag_user': (e,t)->
        if e.which is 13
            element_val = t.$('.tag_user').val().trim()
            # # console.log element_val
            Meteor.users.update Router.current().params.username,
                $addToSet:tags:element_val
            
            t.$('.tag_user').val('')


    'click .remove_tag': (e,t)->
        element = @valueOf()
        console.log @
        Meteor.users.update Router.current().params.username,
            $pull:tags:element
