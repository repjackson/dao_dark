if Meteor.isClient
	Template.payment_methods.helpers
		cards: ->
			Docs.find
				type:'card'
	
	
	Template.payment_methods.onRendered ->
		style = 
			base: {
				color: '#32325d',
				lineHeight: '18px',
				fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
				fontSmoothing: 'antialiased',
				fontSize: '20px',
				'::placeholder': {
					color: '#aab7c4'
				}
			},
			invalid: {
				color: '#fa755a',
				iconColor: '#fa755a'
			}
		# Create an instance of the card Element.
		card = elements.create('card', style: style)
		# Add an instance of the card Element into the `card-element` <div>.
		card.mount '#card-element'
		# $('#add_buttons').show()
		card.addEventListener 'change', (event) ->
			displayError = document.getElementById('card-errors')
			if event.error
				displayError.textContent = event.error.message
			else
				displayError.textContent = ''
			return
		# Handle form submission.
		process = (res)-> Meteor.call 'STRIPE_store_card', res, Meteor.userId(), (err, res)->

		form = document.getElementById('payment-form')
		form.addEventListener 'submit', (event) ->
			event.preventDefault()
			stripe.createToken(card).then (result) ->
				if result.error
					# Inform the user if there was an error.
					errorElement = document.getElementById('card-errors')
					errorElement.textContent = result.error.message
				else
					# Send the token to your server.
					console.log result.token
					console.log result
					process(result.token.id)
			
	Template.stripe_connect.helpers
		stripe_settings: -> 
			console.log Meteor.settings
			Meteor.settings.public.stripe
	