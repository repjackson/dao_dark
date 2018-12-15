Template.front.helpers
    subtext: ->
        messages = [
            'the partriarchy'
            'liberty or death'
            'men are pigs'
            'nature is sexist'
            'men are worthless'
            ]
        rand = messages[Math.floor(Math.random() * messages.length)];
