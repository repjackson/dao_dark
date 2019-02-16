Future = Npm.require('fibers/future')
Meteor.methods
    remove_stripe: (id) ->
        Meteor.users.update id, 
            $unset:
                'stripe': null
                'profile.stripe': null
            
        
    STRIPE_create_customer: (userID, type) ->
        `var userData`
        `var user_email`
        `var userData`
        #console.log(userID);
        Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret)
        user = Meteor.users.findOne(userID)
        if user.roles.length == 0
            Roles.addUsersToRoles userID, 'user'
        #SETUP THE CUSTOMER data
        if type == 'email'
            user_email = user.emails[0].address
            userData = 
                email: user_email
                description: user_email + ' - ' + userID
                metadata: userID: userID
        if type == 'phone'
            userData = 
                description: user.profile.phone + ' - ' + userID
                metadata:
                    userID: userID
                    phone: user.profile.phone
        if type == 'both'
            user_email = user.emails
            userData = 
                description: user_email[0]['address'] + ' - ' + user.profile.phone + ' - ' + userID
                metadata:
                    userID: userID
                    phone: user.profile.phone
                    email: user_email[0]['address']
        #CREATE THE CUSTOMER
        createCustomer = new Future
        Stripe.customers.create userData, (err, customer) ->
            if err
                createCustomer.return error: err
            else
                createCustomer.return result: customer
            return
        newCustomer = createCustomer.wait()
        if newCustomer
            Meteor.users.update userID, 
                $set: 
                    stripe:
                        data: newCustomer.result
                        id: newCustomer.result.id
        
        
    STRIPE_store_card: (token, user) ->
        console.log(token)
        console.log(user)
        if Meteor.isDevelopment
            SERVER_SETTINGS = Meteor.settings.development.private
            console.log 'serv settings', SERVER_SETTINGS
        if process.env.NODE_ENV == 'staging'
            SERVER_SETTINGS = Meteor.settings.staging.private
        
        if process.env.NODE_ENV == 'production'
            SERVER_SETTINGS = Meteor.settings.production.private
        
        Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret)
        userData = Meteor.users.findOne(user)
        stripeId = userData.profile.stripe.id
        #ADD A CARD
        addCard = new Future
        Stripe.customers.createCard stripeId, { source: token }, (err, card) ->
            console.log(err,card);
            if err
                addCard.return err
            else
                addCard.return card
            return
        newCard = addCard.wait()
        if !newCard.error
            console.log("last4 = ", newCard);
            count = MyCards.find(user: user).count()
            cardData = 
                cardid: newCard.id
                token: token
                user: user
                exp_month: newCard.exp_month
                exp_year: newCard.exp_year
                last4: newCard.last4
                brand: newCard.brand
                created: moment().format('X')
            if count <= 0
                cardData.default = true
            MyCards.insert cardData
        newCard
        
    stripeChurchAuth: (code, user) ->
        #console.log(code)
        responseContent = undefined
        try
            # Request an access token
            responseContent = HTTP.post('https://connect.stripe.com/oauth/token', params:
                client_secret: SERVER_SETTINGS.stripeSecret
                code: code
                grant_type: 'authorization_code'
                redirect_uri: Meteor.absoluteUrl('/church/dashboard')).content
        catch err
            throw _.extend(new Error('Failed to complete OAuth handshake with stripe. ' + err.message), response: err.response)
        # Success!  Extract the stripe access token and key
        # from the response
        parsedResponse = JSON.parse(responseContent)
        data = 
            stripeResponse: parsedResponse
            stripeAccessToken: parsedResponse.access_token
            stripeId: parsedResponse.stripe_user_id
            stripePublishableKey: parsedResponse.stripe_publishable_key
        #console.log(data)
        Meteor.users.update user, $set: stripe: data
        if !parsedResponse.access_token
            throw new Error('Failed to complete OAuth handshake with stripe ' + '-- can\'t find access token in HTTP response. ' + responseContent)
        else
            Meteor.users.update user, $set: 'stripe': true
            return true
        return
        
        
    STRIPE_single_charge: (data) ->
        Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret)
        account = Meteor.users.findOne(data.church)
        #console.log(data)
        console.log '------------------------------------------------------'
        console.log account
        if !account.stripe
            retVal = error:
                error: 'Donation Failed'
                message: 'Not ready for donations, please contact your Organization.'
            return retVal
        console.log account.stripe
        chargeCard = new Future
        fee_addition = 0
        if account.profile.isJGFeesApply
            fee_addition = Math.round(data.amount * 100 * 0.019 + 70)
        else
            fee_addition = Math.round(data.amount * 100 * 0.019 + 30)
        #console.log(fee_addition);
        chargeData = 
            amount: data.amount * 100
            currency: 'usd'
            source: data.source
            metadata:
                church: data.church
                givingCODE: data.givingCODE
                user: data.userID
                plan: data.plan
            description: account.profile.churchName
            application_fee: fee_addition
            destination: account.stripe.stripeId
        if data.customer
            chargeData.customer = data.customer
        else
            chargeData.metadata.givername = data.givername
        Stripe.charges.create chargeData, (error, result) ->
            if error
                chargeCard.return error: error
            else
                chargeCard.return result: result
            return
        newCharge = chargeCard.wait()
        console.log newCharge
        newCharge
        
        
    STRIPE_recurring_charge: (data) ->
        `var source`
        Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret)
        account = Meteor.users.findOne(data.church)
        #console.log(account.stripe.stripeId)
        chargeCard = new Future
        if MyCards.findOne(cardid: data.source)
            source = data.source
        else
            newsource = MyCards.findOne(
                user: data.userID
                'default': true)
            source = newsource.cardid
        fee_addition = Math.round(data.amount * 100 * 0.019 + 30)
        console.log fee_addition
        chargeData = 
            amount: data.amount * 100
            currency: 'usd'
            source: source
            metadata:
                church: data.church
                givingCODE: data.givingCODE
                user: data.userID
                plan: data.plan
            description: account.profile.churchName
            application_fee: 100 + fee_addition
            destination: account.stripe.stripeId
        if data.customer
            chargeData.customer = data.customer
        Stripe.charges.create chargeData, (error, result) ->
            if error
                chargeCard.return error: error
            else
                chargeCard.return result: result
            return
        newCharge = chargeCard.wait()
        console.log newCharge
        newCharge
        
        
    SMS_OneOffCharge: (data) ->
        account = Meteor.users.findOne(data.church)
        if account.stripe.stripeId
        else
            return 'Invalid Stripe account'
        console.log data
        console.log account.stripe.stripeId
        Stripe = StripeAPI(SERVER_SETTINGS.stripeSecret)
        user = Meteor.users.findOne(data.user)
        chargeCard = new Future
        fee_addition = Math.round(data.amount * 100 * 0.019 + 30)
        #console.log(fee_addition);
        Stripe.charges.create {
            amount: data.amount * 100
            currency: 'usd'
            card: data.card
            customer: user.profile.stripe.id
            metadata:
                church: data.church
                givingCODE: data.code
                user: data.user
                sms_record: data.sms_record
                method: 'SMS'
                phone: data.phone
            description: 'Joyful-Giver SMS Gift'
            application_fee: 100 + fee_addition
            destination: account.stripe.stripeId
        }, (error, result) ->
            if error
                chargeCard.return error: error
            else
                chargeCard.return result
            return
        chargeCard.wait()
