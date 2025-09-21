class JobPublished < ActiveEventStore::Event
  attributes :job_id
end
