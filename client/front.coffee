Template.front.helpers
    subtext: ->
        messages = [
            'the patriarchy'
            'liberty or death'
            'men are pigs'
            'fuck you'
            'nature is sexist'
            'where have all the good men gone'
            'decentralized autonomous organization'
            'data access object'
            'chivalry is dead'
            'men deserve it'
            'am i pretty'
            'Only time can heal what reason cannot'
            'sex is rape'
            'dont tread on me'
            'He who is brave is free'
            'No man was ever wise by chance'
            'All cruelty springs from weakness'
            'Timendi causa est nescire - Ignorance is the cause of fear'
            'Difficulties strengthen the mind, as labor does the body'
            'We suffer more in imagination than in reality'
            'If a man knows not to which port he sails, no wind is favorable'
            'what if i need you in my darkest hour'
            'They lose the day in expectation of the night, and the night in fear of the dawn'
            ]
        rand = messages[Math.floor(Math.random() * messages.length)];



Template.front.events
    'click .big':->
        Session.set 'out_page', 'login'