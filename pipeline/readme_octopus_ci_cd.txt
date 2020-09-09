Automate CI/CD process using octopus.

1. Automatic release
    For every push of a commit to our repo, a release will be created.
    Note: It will not deploy to the environment.

2. Deploy by Scheduled trigger
    Cron based trigger, which will take latest release and deploy to the environment configured.
    Note: Since we do active developments now, it can be scheduled with min frequency (5mins to 30mins),
          moving on we can reduce it to a day or week.

If we do not want to wait for the schedule only in those times, we can trigger manually in octopus.
