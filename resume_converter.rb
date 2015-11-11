require 'erb'
require 'ostruct'
require 'yaml'

class ResumeConverter
  def initialize(template_name, result_name)
    template = File.open(template_name).read
    resume = YAML.load_file('resume.yml')

    File.open('result/' + result_name, 'w') do |f|
      f.write(
        ERB.new(template, nil, '-').result(
          OpenStruct.new(resume).instance_eval { binding }
        )
      )
    end
  end
end

ResumeConverter.new('template.tex', 'resume.tex')

