# Incidents and Outages

An incident is when we have a service outage, degraded service, or a security concern that needs immediate attention.

## Setting Intention

An incident is a stressful event. This is why we conduct a collaborative incident response: our goal in DevOps culture is to reduce stress and increase trust. In the wake of some failure of our current system, our highest value use of time is to understand why our system broke and to conduct analysis so the organization can learn from what just happened.

Take some time to get into a learning frame of mind. If an outage is fixed, but no one learns anything about why the outage occurred or how to prevent it in the future, this will increase the team's stress load, because there is a failure condition we haven't accounted for. 

If, on the other hand, it takes a little longer to fix the issue, but we all leave with a good understanding of the systems that led to this failure state, and some ideas about how to prevent this outcome in the future, this will reduce the team's stress load. This is by far the better option long term. So... take a few deep breaths and get into a learning frame of mind! 

## Process

In the #incident_reports Workflows tab, find the "start incident" workflow and start it. Fill in the little form it gives you, it will post the zoom and a link to the doc.

## How the "Start Incident" workflow works

1. The workflow itself

People need to be assigned individually as managers of this workflow. If you need to manage it, ask a team lead; they are all assigned as managers.

Access the workflow in slack by clicking Pulibrary, Tools and Settings, Workflow Builder.

The workflow defines the form that's presented, and configures the population of the google sheet

1. The Google Sheet

DO NOT EDIT THIS MANUALLY

The [incident log sheet](https://docs.google.com/spreadsheets/d/1EpYN0qSUIHTTuV12yI0-OudLU50ziJVsRc4-rWydCus/edit) holds the data from slack and the code used to create the notes document and post the message back to slack.

The code was added with Extensions -> Apps Script. There's a trigger when a row gets added that will get today's date, copy the template, update the title/date/summary, and then submit a message to Incident Reports with all that info so people can hop right in.

1. The Incident Notes template

Note that if you make changes to the incident notes template, the script that auto populates some of the notes info may break. You might want to check nothing you change will break the script, or update the script alongside the template.
