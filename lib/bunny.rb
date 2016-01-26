require "bunny"

def bunny
  @bunny ||= Bunny.new([
    "amqp://",
    (ENV["RABBITMQ_USER"] || "guest"),
    ":",
    (ENV["RABBITMQ_PASSWORD"] || "guest"),
    "@",
    (ENV["RABBITMQ_HOST"] || "localhost"),
    ":",
    (ENV["RABBITMQ_PORT"] || "5672")
  ].join)
end
