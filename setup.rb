require 'gmail'
require 'rubygems'
require 'twilio-ruby'
require 'newrelic_rpm'
require 'active_support/time'
class GmailClient
	# Get client instance var setup
	def initialize
		@client = Gmail.new "lalithr1995@gmail.com", "adminr951"
		account_sid = 'AC4fd5e16d1ac2a6a03ebe0ee1011e60fd'
		auth_token = '183beed6fb87b7d75062e4cb01ee4fa1'
		@twilio = Twilio::REST::Client.new account_sid, auth_token
		@previous = 0
		@email = 'support@synack.com'
		puts "Client setup complete"
	end

	def ping after="2016-01-07"
		@unread = @client.inbox.count(:unread, :from => @email, :after => Date.parse(after))
	end

	def schedule
		if ping > 0 and @unread > @previous
			puts "You have #{@unread} unread mails"
			@previous = @unread
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
		@twilio.messages.create(
		  from: '+14014000674',
		  to: '+918008840099',
		  body: "Hey, You have a new mail from #{@email}"
		)
		puts "Message sent to user, Have a look!"
	end
end

gObj = GmailClient.new
NewRelic::Agent.manual_start
while 1
	gObj.schedule
	sleep 5.minutes
	puts "Retrying"
end
