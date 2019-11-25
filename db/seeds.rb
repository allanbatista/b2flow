# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


team = Team.create(name: "x-team")
project = team.projects.create(name: 'x-project')
10.times do |n|
  job = project.jobs.create(name: "x-job-#{n}", engine: 'docker')
  version = job.versions.new
  version.source.attach(Rack::Test::UploadedFile.new(File.open("#{Rails.root}/spec/fixtures/jobs/versions/source.zip"), "application/zip", true))
  version.save
end
