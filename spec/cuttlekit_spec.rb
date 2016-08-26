require 'spec_helper'
require 'githubstubs'
require 'pry'

describe 'Committer' do
  before do
    include GitHubStubs
    GitHubStubs.valid_stubs

    @committer = Cuttlekit::Committer.new()
  end

  it 'creates a committer object' do
    expect(@committer).to be_a(Cuttlekit::Committer)
  end

  it 'returns repo data' do
    @user = Sinatra::Auth::Github::Test::Helper::User.make.api
    @dir = Dir.mktmpdir
    @path = "path"

    expect(@committer.commit(@user, @dir, @path)).to include(:repo)
  end

  context 'when committing to root repo' do
    it 'commits to master' do
      @user = Sinatra::Auth::Github::Test::Helper::User.make.api
      @dir = Dir.mktmpdir

      expect(@committer.commit(@user, @dir)[:branch_name]).to eq('master')
    end
  end

  context 'when committing to a path' do
    it 'commits to gh-pages' do
      @user = Sinatra::Auth::Github::Test::Helper::User.make.api
      @dir = Dir.mktmpdir
      @path = "path"
      # binding.pry
      expect(@committer.commit(@user, @dir, @path)[:branch_name]).to eq('gh-pages')
    end
  end
end
