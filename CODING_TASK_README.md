# Coding Task Readme

This is a short summary of my changes to the codebase for the coding task.

I picked the following improvements from the list:

## Change 1: API Endpoints for GET and POST jobs

Simple API endpoint for the `jobs` resource to be able to create and update jobs, list all the jobs and get a single job by id. There's an additional parameter to decide if the jobs returned should be filtered by the `published` parameter. For creating and updating jobs, there's an additional parameter to decide if the job should be published or not. 
For example, a job may be created ahead of time and updated to be published later. It is not possible destroy a job through the API and there's a limit to the number of requests per minute (10 for the moment), to prevent abuse.
The API endpoint is protected by an API key, which is passed in the `Authorization` header as a bearer token. Initially, this tool is thought for an internal use, so the API key is for a client who can add or modify jobs for all companies. The API endpoints are versioned to ensure backwards compatibility for future breaking changes and the API related controllers (only the jobs one for the moment) inherit from the `ApiController` which sets the rate limit, verifies the API key and enforces the request to be in JSON format.


### Example requests 

_Note: For this requests to work the API key needs to be created in the console with the following command:

```ruby
ApiKey.create(key: SecureRandom.hex, client: "test")
```

- List all jobs

```bash
curl --location '<YOUR_API_URL>/api/v1/jobs' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <API_KEY>' \
--data ''
```
- Get a single job

```bash
curl --location '<YOUR_API_URL>/api/v1/jobs/<JOB_ID>' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <API_KEY>' \
--data ''
```

- Create a new job

```bash
curl --location '<YOUR_API_URL>/api/v1/jobs' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <API_KEY>' \
--data '{
    "job": {
        "company_id": 1,
        "location": "Sydney",
        "title": "Surf & Dev",
        "content": "This is a great job! Bring your water resistant laptop.",
        "published": true
    }
}'
```

- Update a job

```bash
curl --location '<YOUR_API_URL>/api/v1/jobs/<JOB_ID>' \
--header 'Accept: application/json' \
--header 'Content-Type: application/json' \
--header 'Authorization: Bearer <API_KEY>' \
--data '{
    "job": {
        "title": "Updated Title",
        "published": true
    }
}'
```

### Improvements in case of additional time or to support more features

- Add Authentication for company users to create and update jobs for their own company (requires an authentication implementation for example via JWT tokens. Devise JWT is a good option).
- Add endpoints to create and update companies, so it is not required for a company to be created in the database before creating a job.
- The ApiKey could be made more secure by using a more secure hashing algorithm like SHA-256 or SHA-512 and rotating it periodically.
- Publishing a job by updating it can be improved by creating a new publishing set of endpoints instead to make it more explicit and clear what is happening.


## Change 2: Auto-unpublish jobs after 30 days

Connected to the previous change, the jobs are scheduled to be unpublished after a certain configurable period of time with a default to 30 days.
The architecture is a Publish-Subscribe pattern, so the job is published to the event store and the `JobUnpublisherJob` is scheduled to run after the configured period of time (via Solid Queue and active_event_store gems).
Pub/Sub system was the preferred architecture for this case because the job unpublishing is a side effect that is both not related to the central logic of creating/publishing a job, and it is not required to be executed immediately.
The unpublishing job is directly scheduled to be run 30 days ahead of time. This is an approach that is possible given that the persistence layer for the job is PostgreSQL and not Redis. For the case of Redis (for example for Sidekiq) scheduling a job in an in-memory database can be problematic (in case the records are deleted before the job is executed). In that case a scheduler that runs periodically (like cron) would be needed to expire the jobs.
The Pub/Sub architecture is also a good choice in case some other side effects are needed (for example to setup the email alerts for the job when it is published, add a new event with side effect for when the job is unpublished alerting the company that the job is no longer published, etc.).

(First time using Solid Queue! It was fun although it took me a while to configure it properly for local development)

### Improvements in case of additional time or to support more features

- Analyze if scheduling a job in advance is the right way or the periodic job approach is better even for the Solid Queue case.
- Product decisions about how to handle already published jobs that are republished may be needed. For example, if a job is republished, should it be published again or should it be considered as a new job? This could modify the unpublishing logic.

## Change 3 [WIP]: pagination 
(Not completely implemented yet, I wanted to at least give it a shot to create manual pagination which didn't seem that complex at a basic level. It would require more reviews and time to get it ready to be merged. The changes are in the `sa/pagination` branch).

I implemented pagination for controllers (web and API). The logic for pagination is extracted to a `Paginatable` concern that receives the collection of records and sets the parameters for the pagination and the helpers for the views (that appear at the bottom of the page from the view partial).
The API requests have more flexibility for the parameters to be passed, selecting the page and the number of records per page. For the web, each page returns 10 records.

In the same change there were other duplication to the jobs filtering and sorting, so that was extracted to model scopes and to a concern whose only purpose is to provide clarity by grouping and naming related logic together.

### Improvements in case of additional time or to support more features

- Complete the feature, thorough testing manual and potentially integration tests
- Add Last/First pages (not implemented in the UI as helpers yet).
- Make the pagination configurable for the web as well with a way to select the number of records per page.

# Conclusion

It was overall fun experience. I had not used several of the latest Rails feature like Solid Queue, rate limiters, etc, so it was great to learn about them and to use them in this project. This is not a thorough documentation of the codebase but I think it serves as a great conversation starter the call to chat about design decisions, architecture choices, etc. Also, not 100% is been coded by me, and I used some help from AI to learn about options and best practices, and help with the Solid Queue setup for example. It would be great to discuss the pros and cons of using AI for this kind of tasks and how to use it in a more efficient way as well (as that's what I expect to happen in my future work).

Thanks!