## [DATE]

### Step 1: Declare an incident
An incident is when we have a service outage, degraded service, or a security concern that needs immediate attention.

Fill in the incident details in the text below, then post in #incident_reports on Slack:

@here We have the following incident: [Service] is [down|degraded|insecure].

[Notes document](https://docs.google.com/document/d/1Q0GFVxVDO64O7zrb3gc5y-EXAxxyoM3VQvHQjIdq9hs/edit)

Zoom link is the first bookmark on this channel.

Our goal in response is to learn about the causes, fix the issue, reflect on these, and take steps toward never having to respond to this particular issue again.

Everyone is encouraged to come, even if this system is not in your area of expertise. 

We need people in the following roles (all roles are transferrable and do not have to be the same person for the life of the incident):
- Incident moderator: Moderates the call, ensuring other roles are assigned and incident process is followed. Does not need to have technical expertise.
- Note taker: Takes notes and schedules post-incident meeting
- IT manager: Communicates to external stakeholders - see [communication plan](https://lib-confluence.princeton.edu/display/IT/IT+Outages+Communication+Plan)
- The Ensemble: Domain experts, learners
- Interpreter: Helps learners understand what's happening on the call, especially defining domain specific language. May summarize current situation as needed.

### Step 2: Investigate and resolve the incident

1. Define the behavior are we seeing or not seeing. For example: this web page is not functioning, or reindexing is slow, etc.
1. Gather information (from logs, monitoring, etc.). What do we know now about the problem? Can we spot other contributing factors or related problems (slow Solr responses, for example)? Write down all the symptoms of the problem.
1. Form as many hypotheses as we can come up with - what might be the root cause of this problem?
1. Evaluate the hypotheses - which seem most likely? which ones would be quick and easy to rule out or confirm?
1. Write all the hypotheses down!

For each hypothesis, iterate over these steps:
- Look again at the available information.
- Suggest a way to test the hypothesis:
  - if that is the root cause, what would fix it?
  - what would prove the hypothesis true (or false)?
  - how would we know if the fix actually fixed the root cause?
  - how quickly would we expect to see a change?
- Execute the suggested fix. Write down what the fix is and when we started trying it.
- Make a conclusion about whether this fix worked or not. Write down the answer.
- If the fix did not work, did it suggest new hypotheses? If so, add these to the list.
- Pick another hypothesis and start the steps again.

### Step 3: Reflect and learn from the incident


## Committee next steps
1. Refine the template google doc
1. Process for going from shared notes doc (linked above) to an archive 
1. Github issues?
1. Shared ensemble permanent zoom link for incident response
