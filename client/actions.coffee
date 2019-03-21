Template.view_section.events
    'click .view_section': ->
        # console.log @
        Session.set 'loading', true
        Meteor.call 'set_delta_facets', @slug,->
            Session.set 'loading', false


Template.email_receipt.events
    'click .email_receipt': ->
        console.log @person_id
        person = Docs.findOne @person_id
        console.log person.email
        if not person.email
            alert "No Email for #{person.first_name} #{person.last_name}"
        else
            Meteor.call 'email_receipt', person.email,->
                # Session.set 'loading', false
                alert 'Email sent'





Template.checkin.onCreated ->
    @autorun -> Meteor.subscribe 'type', 'log_event'


Template.checkin.onRendered ->
    Meteor.setTimeout ->
        $('.accordion').accordion()
    , 1500


Template.rules_sign.onCreated ->
    @autorun => Meteor.subscribe 'type', 'person'
    @autorun => Meteor.subscribe 'type', 'rules_and_regulations_acknowledgement'

Template.rules_sign.helpers
    rules_signed: ->
        Docs.findOne
            type:'rules_and_regulations_acknowledgement'
            person_id: @_id

Template.rules_sign.events
    'click .sign_rules': ->
        rules_doc_id = Docs.insert
            type:'rules_and_regulations_acknowledgement'
            person_id: @_id
        Router.go("/s/rules_and_regulations_acknowledgement/#{rules_doc_id}/edit")

    'click .view_rules': ->
        rules_doc = Docs.findOne
            type:'rules_and_regulations_acknowledgement'
            person_id: @_id
        Router.go("/s/rules_and_regulations_acknowledgement/#{rules_doc._id}/view")


Template.checkin.helpers
    is_checkedin: ->

    log_events: ->
        Docs.find {
            object_id:@_id
            type:'log_event'
        }, sort:_timestamp:-1



Template.checkout.events
    'click .checkout': ->
        console.log @



Template.send_message.events
    'click .send_message': ->
        console.log @
        if confirm "Send message?"
            Docs.update @_id,
                $set:
                    sent: true
                    sent_datetime: Date.now()
                    read_ids: [Meteor.userId()]
