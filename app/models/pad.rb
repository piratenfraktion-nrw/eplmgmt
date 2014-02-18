class Pad < ActiveRecord::Base
  include Etherpad
  before_validation :etherpad, on: [:create]
  before_update :update_ep
  before_destroy :delete_pad
  belongs_to :group, touch: true
  belongs_to :creator, :class_name => 'User', :foreign_key => 'creator_id'

  validates_presence_of :pad_id, :on => :create
  validates_presence_of :group_id, :on => :create
  validates_presence_of :name
  validates :name, length: { in: 2..50 }
  validates_format_of :name, :with => /\A[\.[:alnum:][:space:],%_-]+\z/, :message => I18n.t('is_invalid')
  validates :name, uniqueness: {scope: :group_id}
  validates_uniqueness_of :pad_id

  has_paper_trail

  def self.skip_time_zone_conversion_for_attributes
    [
      'users.id'.to_sym,
      'users.password'.to_sym,
      'users.encrypted_password'.to_sym,
      'users.reset_password_token'.to_sym,
      'users.reset_password_sent_at'.to_sym,
      'users.remember_created_at'.to_sym,
      'users.remember_token'.to_sym,
      'users.nickname'.to_sym,
      'users.created_at'.to_sym,
      'users.updated_at'.to_sym,
      'users.name'.to_sym,
      'users.sign_in_count'.to_sym,
      'users.current_sign_in_at'.to_sym,
      'users.current_sign_in_ip'.to_sym,
      'users.last_sign_in_ip'.to_sym,
      'users.last_sign_in_at'.to_sym,
      'users.email'.to_sym
    ]
  end

  def etherpad
    if self.group.nil?
      @ep_group = ether.group(ENV['UNGROUPED_NAME'])
      group = Group.find_by_group_id(@ep_group.id)
      if group.nil?
        group = Group.new
        group.group_id = @ep_group.id
        group.name = ENV['UNGROUPED_NAME']
        group.creator_id = self.creator_id
        group.save
      end
      self.group = group
    end
    if self.name.present? && self.name.length <= 50
      pad = self.group.ep_group.pad(self.name)
      self.pad_id = pad.id
      self.edited_at = DateTime.strptime(pad.last_edited.to_s, '%Q')
      self.readonly_id = pad.read_only_id
      update_ep
    end
  end

  def update_ep
    if ((self.name != self.name_was) || (self.group_id != self.group_id_was)) && !self.new_record?
      if self.group.pads.find_by(name: self.name).blank?
        text_was = self.ep_pad.text
        self.ep_pad.delete
        pad = self.group.ep_group.pad(self.name, text: text_was)
        self.pad_id = pad.id
      else
        return false
      end
    end
    pad = ep_pad
    pad.password = self.password
    pad.public = (self.is_public || self.is_public_readonly)
    self.readonly_id = pad.read_only_id
    true
  end

  def ep_pad
    self.group.ep_group.get_pad(self.pad_id)
  end

  def delete_pad
    self.ep_pad.delete
  end

  def delete_ep_pad
    false
  end

  def delete_ep_pad=(del_pad)
    del_pad
  end

  def options
    return 'read' if self.is_public_readonly && self.is_public
    return 'write' if self.is_public && !self.is_public_readonly
    return 'closed' if !self.is_public && !self.is_public_readonly
  end

  def options=(opt)
    attribute_will_change!('is_public')
    attribute_will_change!('is_public_readonly')
    self.is_public = (opt != 'closed')
    self.is_public_readonly = (opt == 'read')
    opt
  end

  def pad_text
    ep_pad.text
  end

  def pad_text=(text)
    attribute_will_change!('pad_text') if ep_pad.text != value
    ep_pad.text = text
  end

  def pad_text_changed?
    changed.include?('pad_text')
  end

  def wiki_url
    return nil unless self.wiki_page.present?
    ENV['MW_URL']+'/wiki/'+self.wiki_page
  end
end
