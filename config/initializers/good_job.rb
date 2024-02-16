Rails.application.configure do
  config.good_job.enable_cron = true
  config.good_job.cron = {
    posts: {
      cron: "*/2 * * * *",
      class: "GeneratePostsJob"
    },
    comments: {
      cron: "* * * * *",
      class: "GenerateCommentsJob"
    }
  }
end
