require 'octokit'

module Ghissues
class Ghissues
  @@milestones = []
  @@config = { }

  def self.initialize(config)
    @@config = config
    initialize_octokit(config[:user], config[:token])
    fetchMilestones(config[:repo])
  end

  def self.initialize_octokit(user, token)
    Octokit.configure do |c|
      c.login = user
      c.access_token = token
    end
  end

  def self.fetchMilestones(repo)
    @@milestones = Octokit.list_milestones(repo)
  end

  def self.milestoneText2number(str)
    if @@milestones.size > 0
      match_array = @@milestones.select { |item| item[:title] == str }
      if match_array.size > 0
        return match_array[0][:number]
      else
        ret = Octokit.create_milestone(@@config[:repo], str)
        fetchMilestones(@@config[:repo])
        return ret[:number]
      end
    else
      Octokit.create_milestone(@@config[:repo], str)
      fetchMilestones(@@config[:repo])
      return ret[:number]
    end
  end
end
end