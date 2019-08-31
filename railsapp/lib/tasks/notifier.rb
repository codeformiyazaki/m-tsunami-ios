
# runner push.rb --token token --message
# runner push.rb --purpose purpose --message

class Notifier
  attr_accessor :dry_run
  def initialize
    @dry_run = true
  end

  def push(tokens,message)
    require 'apnotic'
    apn_cert_string = ENV["APN_CERT"]
    raise "APN_CERT is not set." unless apn_cert_string
    print "[dry-run]" if @dry_run
    puts "Notification is going to be sent to #{tokens.count} devices. message: #{message}"
    connection = Apnotic::Connection.development(
      auth_method: :token,
      cert_path: StringIO.new(apn_cert_string),
      key_id: "P9L3783LP4",
      team_id: "NU78774256"
    )
    tokens.each do |t|
      notification       = Apnotic::Notification.new(t.token)
      notification.topic = "net.lmlab.m-tsunami"
      notification.alert = message

      push = connection.prepare_push(notification)
      push.on(:response) do |response|
        m = "#{response.status} #{response.body}"
        if response.ok?
          puts m
          Rails.logger.debug(m)
        else
          puts m
          Rails.logger.warn(m)
        end
      end
      puts (@dry_run ? "[dry-run]" : "")+"to: "+t.token
      connection.push_async(push) unless @dry_run
    end

    connection.join
    connection.close
  end
end

if __FILE__ == $0
  require 'optparse'
  Version = "1.0.0"

  token = nil
  purpose = nil
  message = "Hello! from m-tsunami-ios"
  n = Notifier.new

  opt = OptionParser.new
  opt.on('-m message','--message message') { |v| message = v }
  opt.on('-t token','--token token') { |v| token = v }
  opt.on('-p purpose','--purpose purpose') { |v| purpose = v }
  opt.on('--exec') { |v| n.dry_run = false } # -e is taken by Rails

  opt.parse!(ARGV)
  puts n.dry_run
  if token.nil? && purpose.nil?
    puts "USAGE: rails runner #{$0} (-t token or -p purpose) -m message [--exec]"
    exit 1
  elsif token
    tokens = [ApnToken.new(token:token)]
  else
    tokens = ApnToken.where("purpose = 'default' or purpose = 'tidalwave'")
  end

  n.push(tokens,message)
end

# https://github.com/ostinelli/apnotic
