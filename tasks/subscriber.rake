desc "subscribe to message queue"
task :subscriber => "db:connect" do
  user = if ENV["USER_ID"]
    User.includes(:company, :state).find_by(id: ENV["USER_ID"])
  else
    User.includes(:company, :state).sample
  end

  puts "User: #{user}"

  begin
    bunny.start

    channel = bunny.create_channel
    fanout  = channel.fanout("amq.fanout")
    direct  = channel.direct("amq.direct")

    queue = channel.queue("user.#{user.id}", auto_delete: true).
    bind(fanout).
    bind(direct, routing_key: "company.#{user.company.id}").
    bind(direct, routing_key: "state.#{user.state.id}").
    bind(direct, routing_key: "user.#{user.id}").
    subscribe do |delivery_info, metadata, payload|
      sender = User.includes(:company, :state).find_by(id: metadata[:headers]["user_id"])

      destination = if delivery_info[:exchange] == "amq.fanout"
        "All"
      else
        case delivery_info[:routing_key]
        when /\Acompany/
          "COMPANY"
        when /\Astate/
          "STATE"
        when /\Auser/
          "!!!!!! DIRECT MESSAGE !!!!!!!"
        end
      end

      puts [
        Time.at(metadata[:headers]["sent_at"]),
        " | ",
        sender,
        " >> ",
        destination,
        ": ",
        payload.light_white
      ].join
    end

    loop do
      puts "Waiting message..."
      sleep 60
    end
  ensure
    bunny.close
  end
end
