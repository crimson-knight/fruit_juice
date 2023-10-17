appraise "redis-4" do
  gem "redis", ">= 4.0.0", "< 5.0.0"
end

appraise "redis-5" do
  if RUBY_VERSION >= "2.5.0"
    gem "redis", ">= 5.0.0"
  end
end
