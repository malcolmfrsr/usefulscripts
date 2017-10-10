require 'Date'
require 'FileUtils'
require 'open3'

# Purpose of this script is to create a zip archive of the previous nights backup and move it to Rustenburg's ftp folder.
# NB! This is temporary, until actual feature is built
# Runs on Rustenburg only
class ArchiveToFtp

  def initialize
  end

# Zips the file and moves it to the ftp folder.
  def move_to_ftp
    # use the previous day's backup
    yesterday = (Date.today-1).strftime("%Y-%m-%d")
    directory = File.join('c:/imqsvar/backup', yesterday)
    zip_file = "#{directory}.zip"

    # zip file
    zip_file(directory, zip_file)

    # copy to the ftp folder
    ftp_folder = 'c:/ftp'
    FileUtils.cp(zip_file, ftp_folder)
  end

  def zip_file(directory, zip_file)
    # running 7zip
    Open3.popen3("c:/7za/7za a -tzip \"#{zip_file}\" \"#{directory}\"") do |stdout, stderr, status, thread|
      while line=stderr.gets do
        puts(line)
      end
    end
  end

end

ArchiveToFtp.new.move_to_ftp if __FILE__ == $PROGRAM_NAME



