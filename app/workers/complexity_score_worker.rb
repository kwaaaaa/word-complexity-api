class ComplexityScoreWorker
  include Sidekiq::Worker

  sidekiq_options retry: 3

  def perform(uuid)
    request = ComplexityScoreRequest.find_by!(uuid: uuid)

    WordComplexity::Pipeline.new(request).call
  end
end
