# frozen_string_literal: true
require_relative "string"
require_relative "hash"

module FruitJuice
  class DelayedJob
    using FruitJuiceString
    using FruitJuiceHash

    attr_reader :job_type, :waiting_queue_key

    def initialize(**config_options)
      raise "job_type must be a string" if config_options.has_key?(:job_type) && config_options[:job_type].class != String
      
      @redis_adapter = set_redis_adapter(config_options[:redis_adapter])
      @job_type = set_job_type(config_options[:job_type])
      @waiting_queue_key = "mosquito:waiting:#{@job_type.underscore}"
    end

    def perform(**job_options)
      @job_options = job_options.deep_stringify_keys!
      enqueue_job
    end

    protected

      def enqueue_job
        enqueue_time = (Time.now.utc.to_f*1000).to_i
        job_id = "#{enqueue_time}:#{rand(1000)}"
        job_run_key = "mosquito:job_run:#{job_id}"

        job_run_meta_data = { 
          # Mosquito required meta data
          "type": @job_type,
          "enqueue_time": enqueue_time.to_s,
          "retry_count": 0,

          # Job specific params
          "job_options": @job_options
        }

        # Required to support both Redis v4.x & v5+ due to behavior changes
        job_run_meta_data.transform_values!(&:to_s) if Redis::VERSION.to_i > 4

        @redis_adapter.hset(job_run_key, job_run_meta_data)
        @redis_adapter.lpush(@waiting_queue_key, job_id)
        job_run_key
      end

      def set_redis_adapter(redis_adapter)
        case redis_adapter.class.to_s.downcase
        when "redis"
          redis_adapter
        when "hash"
          Redis.new(redis_adapter)
        when "nilclass"
          if ENV["REDIS_URL"]
            Redis.new(url: ENV["REDIS_URL"])
          else
            raise Error.new("Expecting a hash of options for the Redis class, a Redis instance or the REDIS_URL environment variable to be set")
          end
        end
      end

      def set_job_type(job_type)
        case job_type.class.to_s
        when "NilClass"
          self.class.to_s.underscore
        when "String"
          job_type.underscore
        end
      end
  end
end