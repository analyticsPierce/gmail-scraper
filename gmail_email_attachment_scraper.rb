#! /usr/bin/ruby

require 'mail'
require 'logger'

# logging setup
log = Logger.new("log file path", 10, 1024000)
log.level = Logger::INFO

log.info("started") 

# set parameters
file_dir = "folder path"

# login to gmail
Mail.defaults do
  retriever_method :imap, :address    => "imap.gmail.com",
                          :port       => 993,
                          :user_name  => 'user_name',
                          :password   => 'password',
                          :enable_ssl => true
end

# retrieve emails
log.info("retrieving the  email")
  # The first 10 emails sorted by date in ascending order
  # need to read emails from a specific label
emails = Mail.find(:what => :first, :count => 2, :order => :asc, :mailbox => 'label')

log.info("there are #{emails.length} emails") 

# start to extract attachments
emails.each do |email|
    email.attachments.each do | attachment |
      # Attachments is an AttachmentsList object containing a
      # number of Part objects
      if (attachment.filename.start_with?('filename filter'))
        # extracting images for example...
        filename = attachment.filename
        log.info("the email has a subject of: #{emails[0].subject}") 
        log.info("the file is: #{filename}") 
        begin
            File.open(file_dir + filename, "w+b", 0644) {|f| f.write attachment.body.decoded}
        rescue Exception => e
            log.warn("Unable to save data for #{filename} because #{e.message}")
        end
      end
    end
end