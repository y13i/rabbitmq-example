require "bunny"

def bunny
  @bunny ||= Bunny.new(
    host:      (ENV["RABBITMQ_HOST"] || "localhost"),
    port:      (ENV["RABBITMQ_PORT"] ? ENV["RABBITMQ_PORT"].to_i : 5672),
    ssl:       false,
    vhost:     "/",
    user:      (ENV["RABBITMQ_USER"] || "guest"),
    pass:      (ENV["RABBITMQ_PASSWORD"] || "guest"),
    heartbeat: (ENV["RABBITMQ_HEARTBEAT"] ? ENV["RABBITMQ_HEARTBEAT"].to_i : :server),
  )
end
