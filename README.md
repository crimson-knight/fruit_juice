
# Welcome to `FruitJuice`!

FruitJuice is a job enqueuing adapter for the [mosquito background job processor](https://github.com/mosquito-cr/mosquito)  written in [Crystal](https://crystal-lang.org/). If you're here to find out how to enqueue background jobs from Ruby/Rails and have them processed in Crystal, you've come to the right place!

## Requirements

Ruby 2.7+
Mosquito 1.0.0.rc1+
Crystal 1.0.0+
Redis 4+

## Installation
  
Install the gem and add to the application's Gemfile by executing:  

`bundle add fruit_juice`

## Types of Jobs

There are two types of jobs that can be enqueued from Ruby/Rails with this gem. The first is a `delayed job`, the second is a `periodic job`. A delayed job goes into a job queue just like Sidekiq or DelayedJob and gets executed when it's turn in the queue arrives. A periodic job can be executed just like a task scheduled from the `whenever`  gem or other cron-job scheduling gems/tools.

This gem currently only supports __`delayed job`s__ 

### Using Delayed Jobs

Delayed jobs inherit from `FruitJuice::DelayedJob`

```ruby
# my_new_job.rb
class MyNewJob < FruitJuice::DelayedJob
end
```

Your ruby job names are meant to match the class/job names used in mosquito
```crystal
class MyNewJob < Mosquito::QueuedJob
	# your job params here
	
	def perform
		# your job start code here
	end
end
```


FruitJuice will automatically convert the class name into the job parameter required for Mosquito to find the job and run it.

If you need to override this behavior, you can initialize your job with the `job_type` parameter like this:
```ruby
# Using the class MyNewRubyJob < FruitJuice::DelayedJob
# The `job_type` parameter must be a string representation of the Crystal job class you want to execute the job
delayed_job = MyNewRubyJob.new(job_type: "MyNewJob")
delayed_job.job_type # Output: my_new_job

```

#### NameSpaced Jobs
```ruby
# Using the ruby `class MyNewRubyJob < FruitJuice::DelayedJob`
# Using the crystal `class ExampleNamespace::MyNewJob < Mosquito::QueuedJob`
# The `job_type` parameter must be a string representation of the Crystal job class you want to execute the job
delayed_job = MyNewRubyJob.new(job_type: "ExampleNamespace::MyNewJob")
delayed_job.job_type # Output: example_namespace::my_new_job which matched the ExampleNamespace::MyNewJob in Crystal
```


## How to store job options

All named parameters passed into `#perform` will be turned into JSON

```ruby
# Using the class MyNewRubyJob < FruitJuice::DelayedJob
# The `job_type` parameter must be a string representation of the Crystal job class you want to execute the job
delayed_job = MyNewRubyJob.new(job_type: "MyNewJob")
delayed_job.perform(this_will: "become a job option", "job option": "and be stored", "as": "json to parse in Mosquito")
```


That's it! Triggering jobs from Ruby/Rails is pretty easy, but this makes it a nice pattern that's easy to follow.
  

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org). (Hint: only Seth can push to ruby gems for now)

  

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/crimson-knight/fruit_juice. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/fruit_juice/blob/main/CODE_OF_CONDUCT.md).

Please open an issue and discuss and grand plans beyond bug fixes before taking on huge changes :)


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


## Code of Conduct

Everyone interacting in the FruitJuice project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/fruit_juice/blob/main/CODE_OF_CONDUCT.md).