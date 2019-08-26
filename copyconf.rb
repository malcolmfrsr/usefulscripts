require 'zip'

class PromoteReleaseCandidate
  def self.prepareReleaseCandidate(conf_path)

    #ToDo : git pull
    Dir.chdir(conf_path)
    system('git pull', out: $stdout, err: :out)

    #ToDo  get client confs
    imqs_mm_client_conf = "#{conf_path}/clientconfs/ImqsMaintenanceManagement/"
    client_conf_output_file = 'c:/Temp/clientconf.zip'
    client_conf_zip_file = ZipFileGenerator.new(imqs_mm_client_conf, client_conf_output_file)
    client_conf_zip_file.write("ImqsMaintenanceManagement")
    puts ("Done zipping")

    #ToDo  get client reports
    imqs_mm_client_reports_conf = "#{conf_path}/reports/client-reports/tshwane/"
    client_report_conf_output_file = 'c:/Temp/reports.zip'
    client_report_conf_zip_file = ZipFileGenerator.new(imqs_mm_client_reports_conf, client_report_conf_output_file)
    client_report_conf_zip_file.write()
    puts ("Done zipping")

    #ToDo  get Database
  end


end

class ZipFileGenerator
  # Initialize with the directory to zip and the location of the output archive.
  def initialize(input_dir, output_file)
    @input_dir = input_dir
    @output_file = output_file
  end

  # Zip the input directory.
  def write (extra_path = '')
    entries = Dir.entries(@input_dir) - %w[. ..]

    ::Zip::File.open(@output_file, ::Zip::File::CREATE) do |zipfile|
      write_entries entries, '', zipfile, extra_path
    end
  end

  private

  # A helper method to make the recursion work.
  def write_entries(entries, path, zipfile, extra_path)
    entries.each do |e|
      zipfile_path = path == '' ? e : File.join(path, e)
      disk_file_path = File.join(@input_dir, zipfile_path)

      if File.directory? disk_file_path
        recursively_deflate_directory(disk_file_path, zipfile, zipfile_path, extra_path)
      else
        put_into_archive(disk_file_path, zipfile, zipfile_path, extra_path)
      end
    end
  end

  def recursively_deflate_directory(disk_file_path, zipfile, zipfile_path, extra_path = '')
    if extra_path.empty?
      zipfile.mkdir zipfile_path
    else
      zipfile.mkdir "#{extra_path}/#{zipfile_path}"
    end
    subdir = Dir.entries(disk_file_path) - %w[. ..]
    write_entries subdir, zipfile_path, zipfile, extra_path
  end

  def put_into_archive(disk_file_path, zipfile, zipfile_path, extra_path = '')
    if extra_path.empty?
      zipfile.add(zipfile_path, disk_file_path)
    else
      zipfile.add("#{extra_path}/#{zipfile_path}", disk_file_path)
    end
  end
end

PromoteReleaseCandidate.prepareReleaseCandidate('c:\dev\_conf\qa-mm')
