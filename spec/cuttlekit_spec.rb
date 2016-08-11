require 'spec_helper'

describe 'Committer' do
  before do
    @committer = Cuttlekit::Committer.new()
  end

  it 'creates a committer object' do
    expect(@committer).to be_a(Cuttlekit::Committer)
  end

  it 'runs' do
    expect(@committer).to respond_to(:run)
  end
end
