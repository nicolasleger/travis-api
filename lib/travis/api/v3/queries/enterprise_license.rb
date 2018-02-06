require 'redis'

module Travis::API::V3
  class Queries::EnterpriseLicense < Query
    def active_users
      redis = Thread.current[:redis] ||= ::Redis.connect(url: Travis.config.redis.url)
      # redis = ::Redis.connect(url: ENV['REDIS_URL'])
      redis.keys("t:*").count
    end
  end
end