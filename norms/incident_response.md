### Forked from RDSS handbook, to be reviewed and updated by Incidents Response
Working Group.

# Incidents and Outages

When we have a service outage, degraded service, or a security concern that needs immediate attention, that counts as an "incident." 

## Setting Intention
An incident is a stressful event. This is why we conduct a post-mortem: our goal in DevOps culture is to reduce stress and increase trust. In the wake of some failure of our current system, our highest value use of time is to understand why our system broke and to conduct analysis so the organization can learn from what just happened. 

Take some time to get into a learning frame of mind. If an outage is fixed, but no one learns anything about why the outage occurred or how to prevent it in the future, this will increase the team's stress load. Now we all know there is a failure condition we haven't accounted for. 

If, on the other hand, it takes a little longer to fix the issue, but we all leave with a good understanding of the systems that led to this failure state, and some ideas about how to prevent this outcome in the future, this will reduce the team's stress load. This is by far the better option long term. So... take a few deep breaths and get into a learning frame of mind! 

## Process

### Roles
1. The incident point person
2. The note taker, who will also schedule the post-mortem meeting
3. An IT manager, whose job is to communicate to external stakeholders
4. Supporting cast -- anyone who helps to resolve the problem 

### During the incident
1. First, [create a post-mortem document](https://drive.google.com/drive/u/0/folders/1EImhSsuZGQb2VNW2ELLTWrVPWoqdFAg1). Assign a notetaker who will keep that document updated.
   1. Goals: Establish a timeline of what happened and what responses were taken. It's best to write this down as it is happening, instead of trying to re-build it afterwards.  
2. Open a zoom channel and post the link, along with a brief description of the outage, on the #incident_reports slack channel. 
3. Developers and Ops staff who are around and able to help resolve the outage should join that zoom.
4. If a production service is down, be sure to follow communication protocols for the downtime. (For now it should be enough to ask on the #incident_reports slack channel: "Who will communicate with users about this?" and one of the managers should step forward. See the [IT Outage Communication Plan]( https://lib-confluence.princeton.edu/display/IT/IT+Outages+Communication+Plan))
5. Troubleshooting can take advantage of our [monitoring](monitoring.md). If there is an outage that our monitoring systems didn't catch, one action item should be to understand how we might monitor that function going forward. 
6. Work with your colleagues to restore service. 
7. Once service is restored, be sure to communicate about that too. 

### After the incident
1. Once service is restored and users have been informed, the note taker should schedule a post-mortem meeting. Invite the RDSS team plus anyone who was involved in the incident, and schedule the meeting as soon as possible so it will still be fresh in people's minds. Link to the post-mortem document in the meeting invite. 
2. During the meeting, review the document together and ensure we have an accurate record of events. 
3. The most important outcome of the meeting should be analysis about WHY this incident happened. The goal for the conversation is not to place blame, but to better understand the nature of our current system. Assume good intent on everyone's part, and assume that everyone made the best choices they could with the information they had. 
4. MOST IMPORTANT: Make tickets for any actions the team identifies that might prevent such an outage in the future. Communicate with stakeholders about why the incident happened and what we're doing to improve the system going forward.

![](images/blameless.png)
