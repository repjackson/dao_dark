Docs.allow
    # insert: (userId, doc) -> doc.author_id is userId
    insert: (userId, doc) -> true
    update: (userId, doc) -> true
    remove: (userId, doc) -> true



Meteor.publish 'deltas', ->
    Docs.find
        type:'delta'
        
Meteor.publish 'stats', ->
    Docs.find
        type:'stat'

Meteor.publish 'doc_id', (doc_id)->
    Docs.find doc_id

Meteor.publish 'type', (schema)->
    Docs.find
        type:schema

Meteor.publish 'children', (type, parent_id)->
    Docs.find
        type:type
        parent_id:parent_id

Meteor.publish 'ref_choices', (schema)->
    Docs.find
        type:schema    
    
Meteor.publish 'delta', (delta_id)->
    Docs.find delta_id
    
    
    
Meteor.methods 
    tagify_date_time: (val)->
        console.log moment(val).format("dddd, MMMM Do YYYY, h:mm:ss a")
        minute = moment(val).minute()
        hour = moment(val).format('h')
        date = moment(val).format('Do')
        ampm = moment(val).format('a')
        weekdaynum = moment(val).isoWeekday()
        weekday = moment().isoWeekday(weekdaynum).format('dddd')

        month = moment(val).format('MMMM')
        year = moment(val).format('YYYY')

        date_array = [hour, minute, ampm, weekday, month, date, year]
        date_array = _.map(date_array, (el)-> el.toString().toLowerCase())
        # date_array = _.each(date_array, (el)-> console.log(typeof el))
        # console.log date_array
        return date_array

    rename_key:(old_key,new_key,parent)->
        Docs.update parent._id,
            $pull:_keys:old_key
        Docs.update parent._id,
            $addToSet:_keys:new_key
        Docs.update parent._id,
            $rename: 
                "#{old_key}": new_key
                "_#{old_key}": "_#{new_key}"


    site_stat: ->
        doc_count = Docs.find({}).count()
        Docs.insert
            type:'stat'
            doc_count:doc_count
            user_count:user_count
