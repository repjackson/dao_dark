import Papa from 'papaparse'

if Meteor.isClient
    Template.parse.events
        'change .upload': (e,t)->
            imported = t.find('.upload').files[0]
            Papa.parse(imported, {
                header: true
                complete: (results, file)->
                    Meteor.call('parse_upload', results.data, (err, res) =>
                        if err
                            console.log err.reason
                        # else
                        #     console.log res
                    )
            })    
            
if Meteor.isServer
    Meteor.methods
        parse_upload:(data)->
            for doc in data
                existing = Docs.findOne doc
                if existing
                    console.log 'existing', doc
                else
                    new_id = Docs.insert doc
                    console.log 'added', new_id
                    
                    
        update_crime_stats: ->
            count = Docs.find(
                'X':$exists:true
                fields:$exists:false
                ).count()
            # example = Docs.findOne(
            #     'X':$exists:true
            #     fields:$exists:true
            #     )
            console.log count
            # result = Docs.update {
            #     'X':$exists:true
            #     fields:$exists:false
            # }, { $set: fields: example.fields }, {multi:true}
            
            # console.log result