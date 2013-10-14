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

  desc 'remove old pads that are not in a group'
  task remove_old_pads: :environment do
    ether.pad_ids.each do |pid|
      unless pid =~ /.{16}\$.+/
        pad = ether.get_pad(pid)
        pad.delete
        puts "destroyed pad #{pid}"
      end
    end
  end

  desc 'remove zombie pads'
  task remove_zombie_pads: :environment do
    pads = Pad.where('edited_at < ?', 90.days.ago)
    pads.each do |pad|
      puts "killing zombie #{pad.name}"
      pad.destroy
    end
  end
end
