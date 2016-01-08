require 'gmail'
require 'rubygems'
require 'twilio-ruby'

class GmailClient
	# Get client instance var setup
	def initialize
		@client = Gmail.new "lalithr1995@gmail.com", "adminr95"
		account_sid = 'AC4fd5e16d1ac2a6a03ebe0ee1011e60fd'
		auth_token = '183beed6fb87b7d75062e4cb01ee4fa1'
		@twilio = Twilio::REST::Client.new account_sid, auth_token
		@unread = 0
		puts "Client setup complete"
	end

	def ping email="lalithr95@gmail.com", after="2016-01-07"
		@unread += @client.inbox.count(:unread, :from => email, :after => Date.parse(after))
	end

	def schedule
		if ping > 0
			puts "You have unread mails"
			@unread -= 1
			makecall
		end
	end

	def makecall
		@call = @twilio.calls.create(
		  from: '+918008840099',
		  to: '+918008840099',
		  url: 'https://demo.twilio.com/welcome/voice/'
		)
		puts "Called the number, Have a look!"
	end
end

gObj = GmailClient.new
while 1
	gObj.schedule
	sleep 15000
	puts "Retrying"
end
