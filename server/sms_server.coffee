# Twilio = require 'twilio'
# # { parse, format } = require 'libphonenumber-js'

# twilio = Twilio(Meteor.settings.private.sms.sid, Meteor.settings.private.sms.token)
# Meteor.methods
#     send_sms: (to,body)->
#         if Meteor.isDevelopment
#             console.log 'sms to', to
#             console.log 'sms body', body
#         if Meteor.isProduction
#             twilio.messages.create({
#                 to: '+19705790321',
#                 from: '+18442525977'
#                 body: body
#             }, (err,res)->
#                 if err
#                     throw new Meteor.Error 'text_not_sent', 'error sending text'
#                 # else
#                 #     console.log 'Twilio response for eric', res
#             )
#         new_event_id = Docs.insert
#             type:'event'
#             event_type:'sms'
#             text: "SMS was sent to #{to}: #{body}"
#             recipient: to