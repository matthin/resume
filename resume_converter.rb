require 'erb'
require 'ostruct'
require 'yaml'
require 'fileutils'
require 'open3'

class ResumeConverter
  def initialize(template_name, result_name)
    template = File.open(template_name).read
    resume = YAML.load_file('resume.yml')

    FileUtils.mkdir_p('result')
    File.open('result/' + result_name, 'w') do |f|
      f.write(
        ERB.new(template, nil, '-').result(
          OpenStruct.new(resume).instance_eval { binding }
        )
      )
    end

    stdout, _, status = Open3.capture3('cd result; xelatex --halt-on-error resume.tex')
    puts stdout unless status.success?
  end
end

ResumeConverter.new('template.tex', 'resume.tex')
