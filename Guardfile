def run_specs_for(file_prefix)
  cmd = "crystal spec spec/#{file_prefix}_spec.cr"
  puts cmd
  `#{cmd}`
end

guard :shell do
  watch(%r{src/(.*)\.cr}) { |m| run_specs_for(m[1]) }
  watch(%r{examples/(.*)\.cr})  { |m| run_specs_for("examples/" + m[1]) }

  watch(%r{spec/(.*)_spec\.cr}) { |m| run_specs_for(m[1]) }
  watch(%r{spec/spec_helper\.cr}) { |m| `crystal spec` }
end
