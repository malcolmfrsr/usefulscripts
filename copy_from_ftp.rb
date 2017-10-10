require 'net/ftp'

# Script I created to move files from an ftp location
class MoveFromFtp

  def initialize
  end

# Zips the file and moves it to the ftp folder.
  def move_from_ftp
    ftp = Net::FTP.new('speedtest.tele2.net')
    ftp.passive = true

    yesterday_zipfile = "512KB.zip"
    filesize = ftp.size(yesterday_zipfile)
    bytes_transferred = 0

    ftp.getbinaryfile(yesterday_zipfile, "c:/temp#{yesterday_zipfile}", 1024) { |data|
      bytes_transferred += data.size
      percentage_done = ((bytes_transferred.to_f)/filesize.to_f)*100
      print  "\r"
      print percentage_done
      STDOUT.flush
    }
    ftp.close
  end

end

MoveFromFtp.new.move_from_ftp if __FILE__ == $PROGRAM_NAME



