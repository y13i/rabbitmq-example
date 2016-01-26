desc "publish messages"
task :publisher => "db:connect" do
  destination_kinds = [:all, :company, :state, :user, :nothing]
  threads           = []
  user_ids          = User.pluck(:id)

  bunny.start

  channel = bunny.create_channel
  fanout  = channel.fanout("amq.fanout")
  direct  = channel.direct("amq.direct")

  interval_range = (ENV["MIN_INTERVAL"] || 5)..(ENV["MAX_INTERVAL"] || 20)

  User.all.each do |user|
    threads << Thread.new do
      begin
        loop do
          sleep(rand(interval_range))

          dest = destination_kinds.sample

          if dest == :nothing
            print "."
            next
          end

          body = Faker::Lorem.sentence

          headers = {
            user_id: user.id,
            sent_at: Time.now.to_i,
          }

          case dest
          when :all
            print "*"
            fanout.publish(body, headers: headers)
          when :company
            print "C"
            direct.publish(body, headers: headers, routing_key: "company.#{user.company.id}")
          when :state
            print "S"
            direct.publish(body, headers: headers, routing_key: "state.#{user.state.id}")
          when :user
            print "U"
            direct.publish(body, headers: headers, routing_key: "user.#{user_ids.sample}")
          else
            fanout.publish(body, headers: headers)
          end
        end
      rescue => e
        p e
      ensure
        bunny.close
      end
    end
  end

  threads.each(&:join)
end
