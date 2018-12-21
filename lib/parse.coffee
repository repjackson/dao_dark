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