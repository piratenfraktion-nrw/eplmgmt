require "#{Rails.root}/lib/Etherpad"
include Etherpad

namespace :etherpad do
  desc "Import pads without groups to the 'ungrouped' group"
  task import: :environment do
    ether.pad_ids.each do |pid|
      unless pid =~ /.{16}\$.+/
        pad = Pad.new
        pad.name = pid
        if pad.save
          pad.pad_text = ether.get_pad(pid).text
          puts "imported pad #{pid}"
        else
          puts pad.errors.full_messages
        end
      end
    end
  end

end
