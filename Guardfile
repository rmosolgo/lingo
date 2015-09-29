guard :shell do
  watch %r{src/(.*)\.cr} do |m|
    cmd = "crystal spec spec/#{m[1]}_spec.cr"
    puts cmd
    `#{cmd}`
  end

  watch %r{spec/(.*)\.cr} do |m|
    cmd = "crystal spec spec/#{m[1]}.cr"
    puts cmd
    `#{cmd}`
  end
end
