# Cuttlekit [![GitHub version](https://badge.fury.io/gh/trevormast%2Fcuttlekit.svg)](https://badge.fury.io/gh/trevormast%2Fcuttlekit)
### BETA

Cuttlekit is a simple extension to [Octokit](https://github.com/octokit) that allows you to quickly commit whole directories to GitHub. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cuttlekit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cuttlekit

## Usage

Simply instantiate a Cuttlekit::Committer object:

```ruby
committer = Cuttlekit::Committer.new
```
And send `commit` to it:

```ruby
committer.commit(user, dir, path)
```
Here, `user` is an authenticated Octokit::Client object, `dir` is the directory tree you would like to commit, and the optional `path` argument is the name of your new repository. If no `path` is given, Cuttlekit will commit to your root repository.


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

You will need to [Register your new Oauth application](https://developer.github.com/v3/oauth/) with GitHub in order to supply Cuttlekit with an authenticated user.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/trevormast/cuttlekit.

