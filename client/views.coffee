Template.day.helpers
    hours: -> [1..12]
    
Template.year.helpers
    array_days: ->
        [1..@days]
        
        
    months: ->
        [
            {
                title:'January'
                days:31
            }
            {
                title:'February'
                days:28
            }
            {
                title:'March'
                days:31
            }
            {
                title:'April'
                days:30
            }
            {
                title:'May'
                days:31
            }
            {
                title:'June'
                days:30
            }
            {
                title:'July'
                days:31
            }
            {
                title:'August'
                days:31
            }
            {
                title:'September'
                days:30
            }
            {
                title:'October'
                days:31
            }
            {
                title:'November'
                days:30
            }
            {
                title:'December'
                days:31
            }
        ]
            
            
            