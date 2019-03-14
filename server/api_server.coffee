unirest = require('unirest')


Meteor.methods
    call_text_api: (input)->
        unirest.get("https://aylien-text.p.rapidapi.com/summarize?title=Batman+at+his+best+and+beyond&text=Batman+has+always+been+my+favourite+superhero+ever+since+the+first+time+I+heard+about+him+because+he+his+human+with+no+powers%2C+also+he+is+much+more+questionable+than+any+other+superhero.+The+story+of+the+film+is+about+Batman%2C+Lieutenant+James+Gordon%2C+and+new+district+attorney+Harvey+Dent+beginning+to+succeed+in+rounding+up+the+criminals+that+plague+Gotham+City.+They+are+unexpectedly+challenged+when+a+mysterious+criminal+mastermind+known+as+the+Joker+appears+in+Gotham.+Batman's+struggle+against+the+Joker+becomes+deeply+personal%2C+forcing+him+to+%22confront+everything+he+believes%22+and+to+improve+his+technology+(which+introduces+the+recreation+of+the+Batcycle%2C+known+as+the+Batpod+and+the+Batsuit+was+redesigned)+to+stop+the+madman's+campaign+of+destruction.+During+the+course+of+the+film%2C+a+love+triangle+develops+between+Bruce+Wayne%2C+Dent+and+Rachel+Dawes.++There+are+now+six+Batman+films+and+I+must+say+that+The+Dark+Knight+is+the+best+out+of+all+of+them.+The+title+is+good+because+that+is+what+Batman+actually+is.+It+has+been+3+years+for+the+adventure+to+continue+from+Batman+Begins+but+that+entire+wait+was+worth+it.+Gotham+city+is+very+Gothic+looking+and+is+very+haunting+and+visionary.+The+whole+movie+is+charged+with+pulse-pounding+suspense%2C+ingenious+special+effects+and+riveting+performances+from+a+first-rate+cast+especially+from+Heath+Ledger+who+gave+an+Oscar+nomination+performance+for+best+supporting-actor.+It+is+a+shame+that+he+can't+see+his+terrific+work+on-screen.+The+cinematography+is+excellent+which+is+made+so+dark+%26+sinister+that+really+did+suit+the+mood+for+the+film.+Usually+sequels+don't+turn+out+to+be+better+than+the+original+but+The+Dark+Knight+is+one+of+those+rare+sequels+that+surpasses+the+original+like+The+Godfather+2.+I+also+really+liked+the+poster+where+the+building+is+on+fire+in+a+Bat+symbol+%26+Batman+is+standing+in+front+of+it.+Christopher+Nolan+is+a+brilliant+director+and+his+film+Memento+is+one+of+my+most+favourite+films.+He+hasn't+made+10+movies+yet+and+3+of+them+are+already+on+the+IMDb+top+250.+Overall+The+Dark+Knight+is+the+kind+of+movie+that+will+make+the+audience+cheer+in+the+end+instead+of+throwing+fruit+%26+vegetables+on+the+screen.")
        .header("X-RapidAPI-Key", "MwkK2zjrEFmsh75gjcFekcmnQgUfp1V3vYjjsns5chPqEsUmAH")
        .end( (result)->
          console.log(result.status, result.headers, result.body);
        );


    imdb: (iid)->
        # console.log unirest
        unirest.get("https://innocentabi-imdb-grabber-v1.p.rapidapi.com/imdb/#{iid}").header('X-RapidAPI-Key', 'MwkK2zjrEFmsh75gjcFekcmnQgUfp1V3vYjjsns5chPqEsUmAH').end (result) ->
            console.log result.status, result.headers, result.body



    famous_quote: ()->
        unirest.post('https://andruxnet-random-famous-quotes.p.rapidapi.com/?count=10&cat=famous').header('X-RapidAPI-Key', 'MwkK2zjrEFmsh75gjcFekcmnQgUfp1V3vYjjsns5chPqEsUmAH').header('Content-Type', 'application/x-www-form-urlencoded').end Meteor.bindEnvironment((result) ->
            for quote in result.body
                new_quote_doc = Docs.findOne quote

                unless new_quote_doc
                    quote_id = Docs.insert quote
                    console.log 'added quote', quote
                else
                    console.log 'existing quote', quote
        )


    movie_quote: ()->
        unirest.post('https://andruxnet-random-famous-quotes.p.rapidapi.com/?count=10&cat=movies').header('X-RapidAPI-Key', 'MwkK2zjrEFmsh75gjcFekcmnQgUfp1V3vYjjsns5chPqEsUmAH').header('Content-Type', 'application/x-www-form-urlencoded').end (result) ->
            for quote in result.body
                console.log quote
