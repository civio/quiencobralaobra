module ApplicationHelper
  # render bidder group name from award
  def render_bidder_group award
    if award.is_ute?
      str = 'UTE: '
      award.get_ute_groups().each_with_index do |group, i|
        str += i==0 ? '' : ' - '
        str += link_to group[:name], bidder_path(group[:slug])
      end
      return str.html_safe
    else
      return link_to award.bidder.group, bidder_path(award.bidder) unless award.bidder.group.blank?
    end
  end
end
