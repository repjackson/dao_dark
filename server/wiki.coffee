Meteor.methods
    wiki: (page)->
        response = HTTP.get("http://en.wikipedia.org/w/api.php?action=parse&format=json&prop=text&section=0&page=JavaScript&callback=?")
        
        console.log response.content
        