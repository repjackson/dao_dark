Template.front.helpers
    subtext: ->
        messages = [
            'the patriarchy'
            'liberty or death'
            'men are pigs'
            'nature is sexist'
            'where have all the good men gone'
            'decentralized autonomous organization'
            'data access object'
            'chivalry is dead'
            'men deserve it'
            'am i pretty'
            'all sex is rape'
            'dont tread on me'
            'He who is brave is free'
            'No man was ever wise by chance'
            'All cruelty springs from weakness'
            'Difficulties strengthen the mind, as labor does the body'
            'We suffer more in imagination than in reality'
            'If a man knows not to which port he sails, no wind is favorable'
            ]
        rand = messages[Math.floor(Math.random() * messages.length)];



Template.front.events
    'click .big':->
        Session.set 'out_page', 'login'