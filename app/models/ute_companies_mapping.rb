class UteCompaniesMapping < ActiveRecord::Base

  # FIXME: We really should cache this
  # Often in the views we want to display the list of groups composing a UTE,
  # instead of the UTE name. Rewriting all existing queries at this point,
  # specially given the "not ideal" data model is risky and painful,
  # so we create a singleton containing all the mapping info and use that
  # freely from the views.
  def self.getUTEGroups()
    ute_groups = {}
    UteCompaniesMapping.find_each do |map|
      ute = map.ute
      ute_groups[ute] = [] if ute_groups[ute].nil?
      ute_groups[ute].push({ name: map.group, slug: map.group.to_url })
    end
    ute_groups.each_value {|v| v.uniq! }  # Remove duplicates
    ute_groups
  end

end
