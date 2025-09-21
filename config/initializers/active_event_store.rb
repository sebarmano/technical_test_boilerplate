ActiveSupport.on_load :active_event_store do |store|
  store.subscribe OnJobPublished::ScheduleJobUnpublishing, to: JobPublished
end
