@Docs = new Meteor.Collection 'docs'


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




Package['kadira:flow-router'] = Package['ostrio:flow-router-extra'];
            
Docs.helpers
    author: -> Meteor.users.findOne @author_id
    when: -> moment(@timestamp).fromNow()