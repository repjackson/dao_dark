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
                # console.log doc
                existing = Docs.findOne doc
                unless existing
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
            
        schema_data: ->
            count = Docs.find(
                suicides_no:$exists:true
                ).count()
            example = Docs.findOne(
                suicides_no:$exists:true
                )
            Meteor.call 'detect_fields', example._id
            
            schemaed_example = Docs.findOne example._id
            console.log schemaed_example
            result = Docs.update {
                suicides_no:$exists:true
            }, { $set: 
                _keys: schemaed_example._keys
                # _country: schemaed_example._country
                # _year: schemaed_example._year
                # _sex: schemaed_example._sex
                # _age: schemaed_example._age
                # _suicides_no: schemaed_example._suicides_no
                # _population: schemaed_example._population
            }, {multi:true}
            
            console.log result
            
            
            
            