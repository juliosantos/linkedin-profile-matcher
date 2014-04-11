module Comparer
  def compare_to(profile)
    [
      compare_skills( self, profile ),
      compare_groups( self, profile ),
      compare_industry( self, profile )
    ].reduce( :+ )
  end

  def rank(profiles)
    profiles.map do |profile|
      {
        profile: profile,
        affinity: self.compare_to( profile )
      }
    end
  end

  private

  def weights
    {
      skills: 1,
      groups: 3,
      industry: 5
    }
  end

  def compare_skills(p1, p2)
    (p1.skills & p2.skills).count * weights[:skills]
  end

  def compare_groups(p1, p2)
    (p1.groups.map{ |g| g[:name] } & p2.groups.map{ |g| g[:name] }).count * weights[:groups]
  end

  def compare_industry(p1, p2)
    p1.industry == p2.industry ? weights[:industry] : 0
  end
end

class Linkedin::Profile
  include Comparer
end

