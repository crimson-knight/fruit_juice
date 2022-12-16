# frozen_string_literal: true

RSpec.describe FruitJuice::DelayedJob do

  after(:all) do
    unless ENV["REDIS_NO_FLUSH"].nil?
      Redis.new(host: "localhost", port: "6379", db: 1).flushdb
    end
  end

  context "initialization options" do
    it "creates a DelayedJob using the REDIS_URL env var" do
      expect(FruitJuice::DelayedJob.new).to be_instance_of(FruitJuice::DelayedJob)
    end

    it "creates a DelayedJob when passing in hash options" do
      expect(FruitJuice::DelayedJob.new(redis_adapter: {host: "localhost", port: 6379, db: 0})).to be_instance_of(FruitJuice::DelayedJob)
    end

    it "creates a DelayedJob when passing in a Redis instance" do
      redis = Redis.new(host: "localhost")

      expect(FruitJuice::DelayedJob.new(redis_adapter: redis)).to be_instance_of(FruitJuice::DelayedJob)
    end

    it "raises an error if no redis adapter is provided and the REDIS_URL ENV var is not configured" do
      redis_url = ENV.delete("REDIS_URL")
      expect { FruitJuice::DelayedJob.new }.to raise_error "Expecting a hash of options for the Redis class, a Redis instance or the REDIS_URL environment variable to be set"
      ENV["REDIS_URL"] = redis_url
    end
  end

  context "enqueueing jobs" do
    it "uses a custom job_type" do
      delayed_job = FruitJuice::DelayedJob.new(job_type: "custom_job_type")
      expect(delayed_job.job_type).to eq("custom_job_type")
    end

    it "generates a job_type from the class name" do
      delayed_job = FruitJuice::DelayedJob.new()
      expect(delayed_job.job_type).to eq("fruit_juice::delayed_job")
    end

    it "queues up a delayed job when using #perform" do
      delayed_job = FruitJuice::DelayedJob.new()
      expect(delayed_job.perform.class).to eq(String)
    end

    it "queues up a delayed job when using passing params to #perform" do
      delayed_job = FruitJuice::DelayedJob.new()
      expect(delayed_job.perform(test_param: "test value")).to include "mosquito:job_run:"
    end

    it "verifies jobs are being created into the correct queue" do
      delayed_job = FruitJuice::DelayedJob.new()
      delayed_job.perform(test_param: "test_value", "the first": "params")
      expect(delayed_job.waiting_queue_key).to eq("mosquito:waiting:fruit_juice::delayed_job")
    end

  end
end
