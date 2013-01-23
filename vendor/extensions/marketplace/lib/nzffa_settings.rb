class NzffaSettings
  class << self
    attr_accessor :admin_levy
    attr_accessor :forest_size_levys
    attr_accessor :full_member_tree_grower_magazine_levy
    attr_accessor :full_member_fft_marketplace_levy
    attr_accessor :casual_member_fft_marketplace_levy
    attr_accessor :tree_grower_magazine_within_new_zealand
    attr_accessor :tree_grower_magazine_within_australia
    attr_accessor :tree_grower_magazine_everywhere_else
    attr_accessor :fft_marketplace_group_id
    attr_accessor :tree_grower_magazine_group_id
    attr_accessor :full_membership_group_id
    attr_accessor :special_interest_group_levys
    attr_accessor :fft_newsletter_group_id
    attr_accessor :nzffa_members_newsletter_group_id
  end

  def self.remove_defaults
    admin_levy = nil
    forest_size_levys = nil
    full_member_tree_grower_magazine_levy = nil
    full_member_fft_marketplace_levy = nil
    casual_member_fft_marketplace_levy = nil
    tree_grower_magazine_within_new_zealand = nil
    tree_grower_magazine_within_australia = nil
    tree_grower_magazine_everywhere_else = nil
    fft_marketplace_group_id = nil
    tree_grower_magazine_group_id = nil
    full_membership_group_id = nil
    special_interest_group_levys = nil
    fft_newsletter_group_id = nil
    nzffa_members_newsletter_group_id = nil
  end

  @admin_levy = 19

  @forest_size_levys = {'0 - 10'  => 0, 
                        '11 - 40' => 51, 
                        '41+'     => 120}

  @special_interest_group_levys = {
    'Eucalyptus Action Group'  => 15,
    'Cypress Development Group' => 15,
    'Acacia Melanoxylon Interest Group Organisation (AMIGO)' => 15,
    'Indigenous Forest Section' => 30,
    'Sequoia Action Group' => 15
  }

  @full_member_tree_grower_magazine_levy = 50
  @tree_grower_magazine_within_new_zealand = 50
  @tree_grower_magazine_within_australia = 55
  @tree_grower_magazine_everywhere_else = 60

  @full_member_fft_marketplace_levy = 15
  @casual_member_fft_marketplace_levy = 15

  @fft_marketplace_group_id = 229
  @tree_grower_magazine_group_id = 80
  @full_membership_group_id = 232

  @fft_newsletter_group_id = 230
  @nzffa_members_newsletter_group_id = 211
end
