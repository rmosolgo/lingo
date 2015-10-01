guard :shell do
  watch %r{src/(.*)\.cr} do |m|
    cmd = "crystal spec spec/#{m[1]}_spec.cr"
    puts cmd
    `#{cmd}`
  end

  watch %r{spec/(.*)\.cr} do |m|
    file_name = m[1]
    if file_name == "spec_helper"
      spec_path = ""
    else
      spec_path = "#{m[1]}.cr"
    end
    cmd = "crystal spec spec/#{spec_path}"
    puts cmd
    `#{cmd}`
  end
end
