require "#{Rails.root}/lib/Etherpad"
include Etherpad

namespace :etherpad do
  desc "Import pads without groups to the ENV['UNGROUPED_NAME'] group"
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
      puts "killing zombie #{pad.group.name}/#{pad.name}"
      path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'zombies')
      Dir.mkdir(path, 0700) unless Dir.exist?(path)
      pad_file = File.join(path, "#{pad.group.name}_#{pad.name}_#{pad.group.group_id}_#{pad.id}.txt")
      File.open(pad_file, File::RDWR|File::CREAT, 0600) { |file| file.write(pad.ep_pad.text) }
      pad.destroy
    end
  end

  desc 'remove orphaned pads'
  task remove_orphaned_pads: :environment do
    pads = Pad.where('creator_id IS NULL')
    pads.each do |pad|
      puts "killing orphan #{pad.group.name}/#{pad.name}"
      path = File.join(File.expand_path(File.dirname(__FILE__)), '..', '..', 'orphans')
      Dir.mkdir(path, 0700) unless Dir.exist?(path)
      pad_file = File.join(path, "#{pad.group.name}_#{pad.name}_#{pad.group.group_id}_#{pad.id}.txt")
      File.open(pad_file, File::RDWR|File::CREAT, 0600) { |file| file.write(pad.ep_pad.text) }
      pad.destroy
    end
  end

  desc 'cron task to fetch last pad edit date'
  task fetch_last_edit: :environment do
    pads = Pad.all
    pads.each do |pad|
      last_edit = DateTime.strptime(pad.ep_pad.last_edited.to_s, '%Q')
      if last_edit.to_time.to_i > pad.edited_at.to_time.to_i
        pad.edited_at = last_edit
        pad.save
      end
    end
  end
end
