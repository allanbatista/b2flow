require 'rails_helper'

RSpec.describe 'Scheduler::JobPublisher' do
  let!(:team) { FactoryBot.create(:team) }
  let!(:project) { FactoryBot.create(:project, team: team) }
  let!(:job) { FactoryBot.create(:job, project: project) }

  subject { Scheduler::JobPublisher }

  before do
    setting = job.settings.create(settings: { key: 1 })
    version = job.versions.new.tap do |version|
      version.source.attach(Rack::Test::UploadedFile.new(fixtures_path("jobs/versions/source.zip"), "application/zip", true))
    end
    version.save
  end

  after do
    # Do nothing
  end

  context '#initialize' do
    it 'should initialize correct' do
      expect {
        @job_publisher = subject.new(Broaker::RabbitPublisher.new("jobs"))
      }.not_to raise_error

      expect(@job_publisher.publisher).to be_a(Broaker::RabbitPublisher)
    end

    it "should not initialize without publisher" do
      expect {
        subject.new
      }.to raise_error(ArgumentError)
    end
  end

  context '#publish' do
    let!(:publisher) { subject.new(Broaker::RabbitPublisher.new("jobs")) }

    it "should enqueue a correct job" do
      expect {
        publisher.publish(job)
      }.to change { job.executions.count }.by(1)

      execution = job.executions.last
      expect(execution.enqueued_at).to be_a(ActiveSupport::TimeWithZone)
      expect(execution.status).to eq('enqueued')
    end
  end
end