require "#{Rails.root}/lib/Etherpad"
include Etherpad

namespace :etherpad do
  desc "Import pads without groups to the 'ungrouped' group"
  task import: :environment do

  end

end
