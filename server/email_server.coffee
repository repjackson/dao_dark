api_key = Meteor.settings.private.mailgun.api_key
domain = Meteor.settings.private.mailgun.domain
mailgun = require('mailgun-js')({apiKey: api_key, domain: domain});

Meteor.methods
    send_email: (mail_fields) ->
        @unblock()

        data = {
            to: mail_fields.to
            from: mail_fields.from
            subject: mail_fields.subject
            text: mail_fields.text
            html: mail_fields.html
        }
        console.log 'sending email', data
        if Meteor.isProduction
            mailgun.messages().send data, (error, body)->
              console.log(body)
        if Meteor.isDevelopment
            # mailgun.messages().send data, (error, body)->
            #   console.log(body)
            console.log 'sending email in dev', data
        return


    send_test:()->
        # ticket = Docs.findOne ticket_doc_id

        # assigned_to_user = Meteor.users.findOne username:username
        # ticket_link = "https://www.jan.meteorapp.com/p/ticket_admin_view?doc_id=#{ticket._id}"
        # complete_ticket_link = "https://www.jan.meteorapp.com/p/complete_ticket_task?doc_id=#{ticket._id}&unassign=#{username}"
    	Email.send({
            to: ["<repjackson@gmail.com>"]
    		from:"goldrun@goldrun.com",
    		subject:'Gold Run registration',
    		body:"hi"
    	})

        # mail_fields = {
        #     # to: ["<#{assigned_to_user.emails[0].address}>"]
        #     # to: ["<richard@janhub.com>","<zack@janhub.com>", "<Nicholas.Rose@premiumfranchisebrands.com>","<brad@janhub.com>","<colin.bates@jan-pro.com>","<hendra.oey@jan-pro.com>"]
        #     to: ["<repjackson@gmail.com>"]
        #     from: "Jan-Pro Customer Portal <portal@jan-pro.com>"
        #     subject: "username you have been assigned to ticket #ticket.ticket_number from customer: ticket.customer_name."
        #     html: "<h4>username, you have been assigned to ticket #ticket.ticket_number from customer: ticket.customer_name.</h4>
        #         <ul>
        #             <li>Type: ticket.ticket_type</li>
        #             <li>Number: ticket.ticket_number</li>
        #             <li>Details: ticket.ticket_details</li>
        #             <li>Created: ticket.long_timestamp</li>
        #             <li>Office: ticket.ticket_office_name</li>
        #             <li>Open: ticket.open</li>
        #             <li>Service Date: ticket.service_date</li>
        #         </ul>
        #         <p>View the ticket <a href=#ticket_link>here</a>.
        #         <p>Mark task complete <a href=complete_ticket_link>here</a>.</p>
        #     "
        # }
        # Meteor.call 'send_email', mail_fields


# Accounts.emailTemplates.siteName = "DAO"
# Accounts.emailTemplates.from     = "DAO Admin <no-reply@dao.af>"

Accounts.emailTemplates.verifyEmail =
    subject: () -> "Gold Run Email Verification"
 
    text: ( user, url )->
        emailAddress   = user.emails[0].address
        urlWithoutHash = url.replace( '#/', '' )
        supportEmail   = "support@dao.af"
        emailBody      = "To verify your email address (#{emailAddress}) visit the following link:\n\n#{urlWithoutHash}\n\n If you did not request this verification, please ignore this email. If you feel something is wrong, please contact our support team: #{supportEmail}."
        return emailBody



#     # create_transaction: (service_id, recipient_doc_id, sale_dollar_price=0, sale_point_price=0)->
#     #     service = Docs.findOne service_id
#     #     service_author = Meteor.users.findOne service.author_id
#     #     recipient_doc = Docs.findOne recipient_doc_id
        
#     #     requester = Meteor.users.findOne recipient_doc.author_id

#     #     new_transaction_id = Docs.insert
#     #         type: 'transaction'
#     #         parent_id: service_id
#     #         author_id: Meteor.userId()
#     #         object_id: recipient_doc_id
#     #         sale_dollar_price: sale_dollar_price
#     #         sale_point_price: sale_point_price

#     #     message_link = "https://www.toriwebster.com/view/#{new_transaction_id}"
        
# Meteor.methods
#     email_about_escalation_two: (incident_id)->
#         incident = Docs.findOne incident_id
#         # console.log incident
#         mailFields = {
#             to: "repjackson@gmail.com <repjackson@gmail.com>"
#             from: "Jan-Pro <support@jan-pro.com>"
#             subject: "Incident has been escalated to 2"
#             text: ''
#             html: "<h4>Incident from #{incident.customer_name} escalated to two.</h4>
#                 <h5>incident_type: #{incident.incident_type}</h5>
#                 <h5>incident_details: #{incident.incident_details}</h5>
#                 <h5>current_level: #{incident.current_level}</h5>
#                 <h5>status: #{incident.status}</h5>
#                 <h5>service_date: #{incident.service_date}</h5>
#             "
#         }
#         Meteor.call 'sendEmail', mailFields
#     #         # html: 
#     #         #     "<h4>#{message_author.profile.first_name} just sent the following message: </h4>
#     #         #     #{text} <br>
#     #         #     In conversation with tags: #{conversation_doc.tags}. \n
#     #         #     In conversation with description: #{conversation_doc.description}. \n
#     #         #     \n
#     #         #     Click <a href="/view/#{_id}"
#     #         # "
    
    
    
#     email_about_escalation_three: (incident_id)->
#         incident = Docs.findOne incident_id
#         # console.log incident
#         mailFields = {
#             to: "repjackson@gmail.com <repjackson@gmail.com>"
#             from: "Jan-Pro <support@jan-pro.com>"
#             subject: "Incident has been escalated to 3"
#             text: ''
#             html: "<h4>Incident from #{incident.customer_name} escalated to two.</h4>
#                 <h5>incident_type: #{incident.incident_type}</h5>
#                 <h5>incident_details: #{incident.incident_details}</h5>
#                 <h5>current_level: #{incident.current_level}</h5>
#                 <h5>status: #{incident.status}</h5>
#                 <h5>service_date: #{incident.service_date}</h5>
#             "
#         }
#         Meteor.call 'sendEmail', mailFields
#     #         # html: 
#     #         #     "<h4>#{message_author.profile.first_name} just sent the following message: </h4>
#     #         #     #{text} <br>
#     #         #     In conversation with tags: #{conversation_doc.tags}. \n
#     #         #     In conversation with description: #{conversation_doc.description}. \n
#     #         #     \n
#     #         #     Click <a href="/view/#{_id}"
#     #         # "
    
    
    
#     email_about_escalation_four: (incident_id)->
#         incident = Docs.findOne incident_id
#         # console.log incident
#         mailFields = {
#             to: "repjackson@gmail.com <repjackson@gmail.com>"
#             from: "Jan-Pro <support@jan-pro.com>"
#             subject: "Incident has been escalated to 4"
#             text: ''
#             html: "<h4>Incident from #{incident.customer_name} escalated to two.</h4>
#                 <h5>incident_type: #{incident.incident_type}</h5>
#                 <h5>incident_details: #{incident.incident_details}</h5>
#                 <h5>current_level: #{incident.current_level}</h5>
#                 <h5>status: #{incident.status}</h5>
#                 <h5>service_date: #{incident.service_date}</h5>
#             "
#         }
#         Meteor.call 'sendEmail', mailFields
#     #         # html: 
#     #         #     "<h4>#{message_author.profile.first_name} just sent the following message: </h4>
#     #         #     #{text} <br>
#     #         #     In conversation with tags: #{conversation_doc.tags}. \n
#     #         #     In conversation with description: #{conversation_doc.description}. \n
#     #         #     \n
#     #         #     Click <a href="/view/#{_id}"
#     #         # "
    
    
    
Meteor.startup ->
    Meteor.Mailgun.config
        username: 'portalmailer@sandbox97641e5041e64bfd943374748157462b.mailgun.org'
        password: 'portalmailer'
    return
    
    
# In your server code: define a method that the client can call
Meteor.methods 
    update_email: (new_email) ->
        userId = Meteor.userId();
        if !userId
            throw new Meteor.Error(401, "Unauthorized");
        Accounts.addEmail(userId, new_email);
        return "Updated Email to #{new_email}"
    
    verify_email: (user_id)->
        Accounts.sendVerificationEmail(user_id)        
        
    notify_user_about_document: (doc_id, recipient_id)->
        doc = Docs.findOne doc_id
        parent = Docs.findOne doc.parent_id
        recipient = Meteor.users.findOne recipient_id
        
        
        doc_link = "/view/#{doc._id}"
        notification = 
            Docs.findOne
                type:'notification'
                object_id:doc_id
                recipient_id:recipient_id
        if notification
            throw new Meteor.Error 500, 'User already notified.'
            return
        else
            Docs.insert
                type:'notification'
                object_id:doc_id
                recipient_id:recipient_id
                content: 
                    "<p>#{Meteor.user().name()} has notified you about <a href=#{doc_link}>#{parent.title} entry</a>.</p>"



    sendEmail: (mailFields) ->
        console.log 'about to send email...'
        # check([mailFields.to, mailFields.from, mailFields.subject, mailFields.text, mailFields.html], [String]);
        # Let other method calls from the same client start running,
        # without waiting for the email sending to complete.
        @unblock()
        if Meteor.isProduction
            Meteor.Mailgun.send
                to: mailFields.to
                from: mailFields.from
                subject: mailFields.subject
                text: mailFields.text
                html: mailFields.html
            console.log 'email sent!'
        else
            Meteor.Mailgun.send
                to: mailFields.to
                from: mailFields.from
                subject: mailFields.subject
                text: mailFields.text
                html: mailFields.html
            console.log 'email sent!'
            console.log 'not prod'
            
        return    