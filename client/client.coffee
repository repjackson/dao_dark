allMapMarkers = []

Template.registerHelper 'dev', () -> Meteor.isDevelopment

Template.registerHelper 'is_church', () ->
    Roles.userIsInRole(Meteor.userId(), 'church')

Template.registerHelper 'is_user', () ->
    Roles.userIsInRole(Meteor.userId(), 'user')

Template.registerHelper 'is_admin', () ->
    Roles.userIsInRole(Meteor.userId(), 'admin')

Template.registerHelper 'in_list', (key) ->
    if Meteor.userId()
        if Meteor.userId() in @["#{key}"] then true else false

Template.registerHelper 'doc', () ->
    Docs.findOne Router.current().params.id


Template.registerHelper 'field_value', () ->
    parent = Template.parentData()
    if parent["#{@key}"] then parent["#{@key}"]




Meteor.startup ->
    # Meteor.call 'PUBLIC_SETTINGS', (error, result) ->
    #     Session.set 'SETTINGS', result
    #     Stripe.setPublishableKey result.stripePublishable
    #     mapsApiKey = result.mapsApiKey
    #     return
    Meteor.subscribe 'appSettings'
    Template.registerHelper 'JOYsettings', ->
        AppSettings.findOne()
    # GoogleMaps.load
    #     v: '3'
    #     key: 'AIzaSyA44_Aq1-OkLvnmDKnTlfDBCRn-aOsSnKU'
    # Slingshot.fileRestrictions 'myFileUploads',
    #     allowedFileTypes: [
    #         'image/png'
    #         'image/jpeg'
    #         'image/gif'
    #     ]
    #     maxSize: 2 * 1024 * 1024

    iosgivepageload = (giveid) ->
        #console.log('entered iospageload... giveid=> ', giveid);
        if Meteor.isCordova
            devicePlatform = device.platform
            #console.log(devicePlatform);
            if devicePlatform == 'iOS'
                #window.open(encodeURI("http://localhost:3000/give/"+giveid), '_system'); //FIXME change to localhost:3000 to joyful-giver.com
                window.open encodeURI('https://joyful-giver.com/give/' + giveid), '_system'
            else
                Router.go '/give/' + giveid
        else
            #console.log('Loading give - ', giveid );
            Router.go '/give/' + giveid
        return

    iosorgpageload = (giveid) ->
        Router.go '/churchDetail/' + giveid
        return

    # ioscamppageload = function(giveid){
    #     console.log('entered ioscamppageload...');
    #     if(Meteor.isCordova){
    #         var devicePlatform = device.platform;
    #         console.log(devicePlatform);
    #         if(devicePlatform=="iOS"){
    #            //window.open(encodeURI("http://localhost:3000/"+giveid), '_system'); //FIXME change to localhost:3000 to joyful-giver.com
    #            window.open(encodeURI("https://joyful-giver.com/"+giveid), '_system');
    #         }else{
    #            Router.go('/'+giveid)
    #         }
    #     }else{
    #         //console.log('not iOS');
    #         Router.go('/'+giveid)
    #     }
    #
    # }